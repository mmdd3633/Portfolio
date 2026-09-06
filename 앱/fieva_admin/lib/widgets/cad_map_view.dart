import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../models/cad_map.dart';

class CadMapController extends ChangeNotifier {
  void focusOnUser() => notifyListeners();
}

class CadMapView extends StatefulWidget {
  final CadMap cadMap;
  final String imageUrl;
  final UserLiveLocation? userLocation;
  final List<UserLiveLocation> userLocations;
  final Set<String> isolatedUserIds;
  final CadMapBeacon? fireBeacon;
  final Offset? destinationPoint;
  final String destinationLabel;
  final List<Offset> routePoints;
  final ValueChanged<Offset>? onMapTap;
  final CadMapController? controller;
  final ValueChanged<bool>? onBrowsingChanged;

  const CadMapView({
    super.key,
    required this.cadMap,
    required this.imageUrl,
    this.userLocation,
    this.userLocations = const [],
    this.isolatedUserIds = const {},
    this.fireBeacon,
    this.destinationPoint,
    this.destinationLabel = '',
    this.routePoints = const [],
    this.onMapTap,
    this.controller,
    this.onBrowsingChanged,
  });

  @override
  State<CadMapView> createState() => _CadMapViewState();
}

class _CadMapViewState extends State<CadMapView> {
  Size? _imageSize;
  ui.Image? _decodedImage;
  Rect? _mapBounds;
  Object? _imageError;
  ImageStream? _stream;
  ImageStreamListener? _listener;
  double? _manualScale;
  Offset? _manualOffset;
  double _renderedScale = 1;
  Offset _renderedOffset = Offset.zero;
  double _gestureStartScale = 1;
  Offset _gestureStartOffset = Offset.zero;
  Offset _gestureStartFocal = Offset.zero;
  double _minimumScale = 1;
  double _maximumScale = 6;

  @override
  void initState() {
    super.initState();
    _computeMapBounds();
    _resolveImage();
    widget.controller?.addListener(_focusOnUser);
  }

  @override
  void didUpdateWidget(CadMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_focusOnUser);
      widget.controller?.addListener(_focusOnUser);
    }
    if (oldWidget.cadMap.id != widget.cadMap.id ||
        oldWidget.cadMap.bounds != widget.cadMap.bounds ||
        oldWidget.cadMap.image != widget.cadMap.image ||
        oldWidget.cadMap.beacons.length != widget.cadMap.beacons.length) {
      _computeMapBounds();
      _focusOnUser();
    }
    if (oldWidget.imageUrl != widget.imageUrl) {
      _resolveImage();
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_focusOnUser);
    if (_listener != null) {
      _stream?.removeListener(_listener!);
    }
    super.dispose();
  }

  void _focusOnUser() {
    if (!mounted) return;
    setState(() {
      _manualScale = null;
      _manualOffset = null;
    });
    widget.onBrowsingChanged?.call(false);
  }

  void _startBrowsing(ScaleStartDetails details) {
    _gestureStartScale = _renderedScale;
    _gestureStartOffset = _renderedOffset;
    _gestureStartFocal = details.localFocalPoint;
    if (_manualScale == null) widget.onBrowsingChanged?.call(true);
    _manualScale = _renderedScale;
    _manualOffset = _renderedOffset;
  }

  void _updateBrowsing(ScaleUpdateDetails details) {
    final scale = (_gestureStartScale * details.scale)
        .clamp(_minimumScale, _maximumScale)
        .toDouble();
    final ratio = scale / _gestureStartScale;
    final offset =
        details.localFocalPoint -
        (_gestureStartFocal - _gestureStartOffset) * ratio;
    setState(() {
      _manualScale = scale;
      _manualOffset = offset;
    });
  }

  void _resolveImage() {
    if (_listener != null) {
      _stream?.removeListener(_listener!);
      _listener = null;
      _stream = null;
    }

    setState(() {
      _imageSize = null;
      _decodedImage = null;
      _imageError = null;
    });

    if (widget.imageUrl.trim().isEmpty) {
      setState(() => _imageError = 'Converted CAD image URL is empty.');
      return;
    }

    final provider = NetworkImage(widget.imageUrl);
    final stream = provider.resolve(ImageConfiguration.empty);
    final listener = ImageStreamListener(
      (info, _) {
        if (!mounted) return;
        setState(() {
          _decodedImage = info.image;
          _imageSize = Size(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          );
        });
      },
      onError: (error, _) {
        if (!mounted) return;
        setState(() => _imageError = error);
      },
    );
    _stream = stream;
    _listener = listener;
    stream.addListener(listener);
  }

  void _computeMapBounds() {
    final bounds = widget.cadMap.bounds;
    if (bounds != null && bounds.isValid) {
      _mapBounds = Rect.fromLTRB(
        bounds.minX,
        bounds.minY,
        bounds.maxX,
        bounds.maxY,
      );
      return;
    }

    if (widget.cadMap.beacons.isEmpty) {
      _mapBounds = null;
      return;
    }

    var minX = double.infinity;
    var minY = double.infinity;
    var maxX = double.negativeInfinity;
    var maxY = double.negativeInfinity;
    for (final beacon in widget.cadMap.beacons) {
      minX = math.min(minX, beacon.x);
      minY = math.min(minY, beacon.y);
      maxX = math.max(maxX, beacon.x);
      maxY = math.max(maxY, beacon.y);
    }

    final width = math.max(1.0, maxX - minX);
    final height = math.max(1.0, maxY - minY);
    final padding = math.max(width, height) * 0.08;
    _mapBounds = Rect.fromLTRB(
      minX - padding,
      minY - padding,
      maxX + padding,
      maxY + padding,
    );
  }

  Offset _toImagePoint(double x, double y) {
    return _tryToVisibleImagePoint(x, y, clamp: true) ?? Offset.zero;
  }

  Rect _visibleImageRect() {
    final image = widget.cadMap.image;
    final imageSize = _imageSize;
    if (image != null && image.isValid) {
      return Rect.fromLTRB(
        image.visibleLeft,
        image.visibleTop,
        image.visibleRight,
        image.visibleBottom,
      );
    }
    if (imageSize == null) return Rect.zero;
    return Offset.zero & imageSize;
  }

  Offset? _tryToVisibleImagePoint(double x, double y, {bool clamp = false}) {
    final bounds = _mapBounds;
    final imageSize = _imageSize;
    final visibleRect = _visibleImageRect();
    if (bounds == null ||
        imageSize == null ||
        bounds.width == 0 ||
        bounds.height == 0 ||
        visibleRect.width <= 0 ||
        visibleRect.height <= 0) {
      return null;
    }

    final sxRaw = (x - bounds.left) / bounds.width;
    final syRaw = (y - bounds.top) / bounds.height;
    if (!clamp && (sxRaw < 0 || sxRaw > 1 || syRaw < 0 || syRaw > 1)) {
      return null;
    }

    final sx = sxRaw.clamp(0.0, 1.0).toDouble();
    final sy = syRaw.clamp(0.0, 1.0).toDouble();
    final image = widget.cadMap.image;
    final coordinateWidth = (image?.coordinateWidth ?? imageSize.width)
        .toDouble();
    final coordinateHeight = (image?.coordinateHeight ?? imageSize.height)
        .toDouble();
    final sourcePoint = Offset(
      sx * coordinateWidth,
      (1 - sy) * coordinateHeight,
    );
    final filePoint =
        sourcePoint -
        Offset(image?.coordinateLeft ?? 0, image?.coordinateTop ?? 0);
    return filePoint - visibleRect.topLeft;
  }

  Offset _focusPointForMap() {
    final user = widget.userLocation;
    if (user != null) return Offset(user.x, user.y);
    if (widget.userLocations.isNotEmpty) {
      final first = widget.userLocations.first;
      return Offset(first.x, first.y);
    }
    if (widget.routePoints.isNotEmpty) return widget.routePoints.first;
    final bounds = _mapBounds;
    if (bounds != null) return bounds.center;
    return Offset.zero;
  }

  Offset _mapOffsetFor({
    required Size viewport,
    required Size displaySize,
    required double displayScale,
  }) {
    if (!_hasFocusTarget) {
      return Offset(
        (viewport.width - displaySize.width) / 2,
        (viewport.height - displaySize.height) / 2,
      );
    }

    final focus = _focusPointForMap();
    final imagePoint = _tryToVisibleImagePoint(focus.dx, focus.dy, clamp: true);
    if (imagePoint == null) return Offset.zero;

    final desired = Offset(
      viewport.width / 2 - imagePoint.dx * displayScale,
      viewport.height / 2 - imagePoint.dy * displayScale,
    );

    return Offset(
      clampAxisRelaxed(desired.dx, viewport.width, displaySize.width),
      clampAxisRelaxed(desired.dy, viewport.height, displaySize.height),
    );
  }

  double clampAxisRelaxed(
    double value,
    double viewportExtent,
    double contentExtent,
  ) {
    if (contentExtent <= viewportExtent) {
      return (viewportExtent - contentExtent) / 2;
    }

    // Users are always inside the building. Allow a little empty map margin so
    // edge corridors can still be centered instead of being pinned to a side.
    final extra = math.min(viewportExtent * 0.45, contentExtent * 0.35);
    final min = viewportExtent - contentExtent - extra;
    final max = extra;
    return value.clamp(min, max).toDouble();
  }

  Offset _clampManualOffset(Offset value, Size viewport, Size content) {
    double axis(double offset, double viewportExtent, double contentExtent) {
      final visibleEdge = math.min(80.0, viewportExtent * 0.22);
      final min = visibleEdge - contentExtent;
      final max = viewportExtent - visibleEdge;
      if (contentExtent <= viewportExtent) {
        final centered = (viewportExtent - contentExtent) / 2;
        final travel = math.max(24.0, viewportExtent * 0.18);
        return offset.clamp(centered - travel, centered + travel).toDouble();
      }
      return offset.clamp(min, max).toDouble();
    }

    return Offset(
      axis(value.dx, viewport.width, content.width),
      axis(value.dy, viewport.height, content.height),
    );
  }

  bool get _hasFocusTarget =>
      widget.userLocation != null ||
      widget.userLocations.isNotEmpty ||
      widget.routePoints.isNotEmpty;

  Offset? _cadPointFromViewport({
    required Offset localPosition,
    required Offset mapOffset,
    required double displayScale,
  }) {
    final bounds = _mapBounds;
    final imageSize = _imageSize;
    final visibleRect = _visibleImageRect();
    if (bounds == null ||
        imageSize == null ||
        displayScale <= 0 ||
        bounds.width == 0 ||
        bounds.height == 0 ||
        visibleRect.width <= 0 ||
        visibleRect.height <= 0) {
      return null;
    }

    final visiblePoint = (localPosition - mapOffset) / displayScale;
    if (visiblePoint.dx < 0 ||
        visiblePoint.dy < 0 ||
        visiblePoint.dx > visibleRect.width ||
        visiblePoint.dy > visibleRect.height) {
      return null;
    }

    final image = widget.cadMap.image;
    final coordinateWidth = (image?.coordinateWidth ?? imageSize.width)
        .toDouble();
    final coordinateHeight = (image?.coordinateHeight ?? imageSize.height)
        .toDouble();
    final filePoint = visiblePoint + visibleRect.topLeft;
    final sourcePoint =
        filePoint +
        Offset(image?.coordinateLeft ?? 0, image?.coordinateTop ?? 0);
    final sx = (sourcePoint.dx / coordinateWidth).clamp(0.0, 1.0).toDouble();
    final sy = 1 - (sourcePoint.dy / coordinateHeight).clamp(0.0, 1.0);

    return Offset(
      bounds.left + sx * bounds.width,
      bounds.top + sy * bounds.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_imageError != null) {
      return _message(
        title: 'Converted CAD image failed to load',
        body: _imageError.toString(),
      );
    }
    if (_imageSize == null || _decodedImage == null) {
      return _message(title: 'Loading converted CAD image');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final image = _decodedImage!;
        final visibleRect = _visibleImageRect();
        final viewportSize = Size(constraints.maxWidth, constraints.maxHeight);
        final widthScale = viewportSize.width / visibleRect.width;
        final heightScale = viewportSize.height / visibleRect.height;
        final fitScale = math.min(widthScale, heightScale);
        final baseScale = _hasFocusTarget
            ? math.max(widthScale, heightScale)
            : fitScale;
        final automaticScale =
            baseScale * (_hasFocusTarget ? _focusZoomFor(viewportSize) : 1.0);
        _minimumScale = fitScale * 0.85;
        _maximumScale = fitScale * 6;
        final scale = (_manualScale ?? automaticScale)
            .clamp(_minimumScale, _maximumScale)
            .toDouble();
        final displaySize = Size(
          visibleRect.width * scale,
          visibleRect.height * scale,
        );
        final automaticOffset = _mapOffsetFor(
          viewport: viewportSize,
          displaySize: displaySize,
          displayScale: scale,
        );
        final mapOffset = _manualOffset == null
            ? automaticOffset
            : _clampManualOffset(_manualOffset!, viewportSize, displaySize);
        _renderedScale = scale;
        _renderedOffset = mapOffset;

        final map = Container(
          color: Colors.white,
          child: ClipRect(
            child: CustomPaint(
              painter: _MapPainter(
                image: image,
                visibleRect: visibleRect,
                mapOffset: mapOffset,
                displaySize: displaySize,
              ),
              foregroundPainter: _OverlayPainter(
                cadMap: widget.cadMap,
                userLocation: widget.userLocation,
                userLocations: widget.userLocations,
                isolatedUserIds: widget.isolatedUserIds,
                fireBeacon: widget.fireBeacon,
                destinationPoint: widget.destinationPoint,
                destinationLabel: widget.destinationLabel,
                routePoints: widget.routePoints,
                toImagePoint: _toImagePoint,
                displayScale: scale,
                mapOffset: mapOffset,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        );
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onScaleStart: _startBrowsing,
          onScaleUpdate: _updateBrowsing,
          onTapUp: widget.onMapTap == null
              ? null
              : (details) {
                  final cadPoint = _cadPointFromViewport(
                    localPosition: details.localPosition,
                    mapOffset: mapOffset,
                    displayScale: scale,
                  );
                  if (cadPoint != null) widget.onMapTap!(cadPoint);
                },
          child: map,
        );
      },
    );
  }

  Widget _message({required String title, String? body}) {
    return Container(
      color: const Color(0xFF101722),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (body != null) ...[
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  double _focusZoomFor(Size viewportSize) {
    if (viewportSize.width <= 600) return 1.25;
    return 1.08;
  }
}

class _MapPainter extends CustomPainter {
  final ui.Image image;
  final Rect visibleRect;
  final Offset mapOffset;
  final Size displaySize;

  _MapPainter({
    required this.image,
    required this.visibleRect,
    required this.mapOffset,
    required this.displaySize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
      image,
      visibleRect,
      mapOffset & displaySize,
      Paint()..filterQuality = FilterQuality.medium,
    );
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.visibleRect != visibleRect ||
        oldDelegate.mapOffset != mapOffset ||
        oldDelegate.displaySize != displaySize;
  }
}

class _OverlayPainter extends CustomPainter {
  final CadMap cadMap;
  final UserLiveLocation? userLocation;
  final List<UserLiveLocation> userLocations;
  final Set<String> isolatedUserIds;
  final CadMapBeacon? fireBeacon;
  final Offset? destinationPoint;
  final String destinationLabel;
  final List<Offset> routePoints;
  final Offset Function(double x, double y) toImagePoint;
  final double displayScale;
  final Offset mapOffset;

  _OverlayPainter({
    required this.cadMap,
    required this.userLocation,
    required this.userLocations,
    required this.isolatedUserIds,
    required this.fireBeacon,
    required this.destinationPoint,
    required this.destinationLabel,
    required this.routePoints,
    required this.toImagePoint,
    required this.displayScale,
    required this.mapOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Offset map(double x, double y) {
      final p = toImagePoint(x, y);
      return mapOffset + Offset(p.dx * displayScale, p.dy * displayScale);
    }

    _drawRoute(canvas, map);
    _drawBeacons(canvas, map);
    _drawDestination(canvas, map);
    _drawFire(canvas, map);
    _drawUsers(canvas, map);
  }

  void _drawRoute(Canvas canvas, Offset Function(double, double) map) {
    if (routePoints.length < 2) return;
    final glow = Paint()
      ..color = const Color(0x6600C896)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final line = Paint()
      ..color = const Color(0xFF00C896)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final first = map(routePoints.first.dx, routePoints.first.dy);
    path.moveTo(first.dx, first.dy);
    for (final point in routePoints.skip(1)) {
      final mapped = map(point.dx, point.dy);
      path.lineTo(mapped.dx, mapped.dy);
    }
    canvas.drawPath(path, glow);
    canvas.drawPath(path, line);
  }

  void _drawBeacons(Canvas canvas, Offset Function(double, double) map) {
    final fill = Paint()..color = const Color(0xDD2563EB);
    final exitFill = Paint()..color = const Color(0xFF16A34A);
    final stroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (final beacon in cadMap.beacons) {
      if (beacon.id == fireBeacon?.id) continue;
      final p = map(beacon.x, beacon.y);
      canvas.drawCircle(
        p,
        beacon.isExit ? 10 : 8,
        beacon.isExit ? exitFill : fill,
      );
      canvas.drawCircle(p, 8, stroke);
      _drawLabel(
        canvas,
        p.translate(0, beacon.isExit ? -20 : -17),
        beacon.displayName,
        background: beacon.isExit
            ? const Color(0xFF166534)
            : const Color(0xFF1E3A8A),
      );
    }
  }

  void _drawDestination(Canvas canvas, Offset Function(double, double) map) {
    final point = destinationPoint;
    if (point == null) return;
    final p = map(point.dx, point.dy);

    canvas.drawCircle(p, 26, Paint()..color = const Color(0x33EF4444));
    canvas.drawCircle(p, 16, Paint()..color = const Color(0xFFEF4444));
    canvas.drawCircle(
      p,
      16,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    _drawLabel(
      canvas,
      p.translate(0, -28),
      destinationLabel.isEmpty ? '출구 비콘' : '$destinationLabel 출구',
      background: const Color(0xFF166534),
    );
  }

  void _drawFire(Canvas canvas, Offset Function(double, double) map) {
    final beacon = fireBeacon;
    if (beacon == null) return;
    final p = map(beacon.x, beacon.y);
    canvas.drawCircle(p, 24, Paint()..color = const Color(0x33EF4444));
    canvas.drawCircle(p, 14, Paint()..color = const Color(0xFFEF4444));
    canvas.drawCircle(
      p,
      14,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    _drawLabel(
      canvas,
      p.translate(0, -27),
      '${beacon.displayName} 화재',
      background: const Color(0xFFB91C1C),
    );
  }

  void _drawUsers(Canvas canvas, Offset Function(double, double) map) {
    final users = userLocations.isNotEmpty
        ? userLocations
        : userLocation == null
        ? const <UserLiveLocation>[]
        : <UserLiveLocation>[userLocation!];
    for (final user in users) {
      final userId = user.userId?.trim().toLowerCase();
      _drawUser(
        canvas,
        map,
        user,
        isolated: userId != null && isolatedUserIds.contains(userId),
      );
    }
  }

  void _drawUser(
    Canvas canvas,
    Offset Function(double, double) map,
    UserLiveLocation user, {
    required bool isolated,
  }) {
    final p = map(user.x, user.y);
    final glowColor = isolated
        ? const Color(0x66EF4444)
        : const Color(0x5524C8FF);
    final fillColor = isolated
        ? const Color(0xFFDC2626)
        : const Color(0xFF0EA5E9);
    final labelColor = isolated
        ? const Color(0xFF991B1B)
        : const Color(0xFF0369A1);
    canvas.drawCircle(p, isolated ? 44 : 38, Paint()..color = glowColor);
    canvas.drawCircle(p, isolated ? 27 : 24, Paint()..color = fillColor);
    canvas.drawCircle(
      p,
      isolated ? 27 : 24,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
    canvas.drawCircle(p, 7, Paint()..color = Colors.white);
    _drawLabel(
      canvas,
      p.translate(0, -38),
      isolated
          ? '고립 위험 · ${user.userId?.isNotEmpty == true ? user.userId! : '사용자'}'
          : user.userId?.isNotEmpty == true
          ? user.userId!
          : '현재 위치',
      background: labelColor,
    );
  }

  void _drawLabel(
    Canvas canvas,
    Offset center,
    String text, {
    required Color background,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(maxWidth: 92);

    final rect = Rect.fromCenter(
      center: center,
      width: painter.width + 12,
      height: painter.height + 6,
    );
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(6));
    canvas.drawRRect(rrect, Paint()..color = background);
    painter.paint(
      canvas,
      Offset(
        rect.left + (rect.width - painter.width) / 2,
        rect.top + (rect.height - painter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _OverlayPainter oldDelegate) {
    return oldDelegate.cadMap != cadMap ||
        oldDelegate.userLocation != userLocation ||
        oldDelegate.userLocations != userLocations ||
        oldDelegate.isolatedUserIds != isolatedUserIds ||
        oldDelegate.fireBeacon?.id != fireBeacon?.id ||
        oldDelegate.destinationPoint != destinationPoint ||
        oldDelegate.destinationLabel != destinationLabel ||
        oldDelegate.routePoints != routePoints ||
        oldDelegate.displayScale != displayScale ||
        oldDelegate.mapOffset != mapOffset;
  }
}
