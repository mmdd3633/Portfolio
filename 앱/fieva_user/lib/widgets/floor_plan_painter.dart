import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/floor_plan.dart';
import '../models/beacon_data.dart';
import '../models/route_node.dart';
import '../services/location_estimator.dart';

class FloorPlanPainter extends CustomPainter {
  final FloorPlan floorPlan;
  final List<BeaconData> beacons;
  final List<BeaconData> fireBeacons;
  final EstimatedPosition? userPosition;
  final List<RouteNode> routePath;
  final double headingDeg;

  FloorPlanPainter({
    required this.floorPlan,
    required this.beacons,
    required this.fireBeacons,
    required this.userPosition,
    required this.routePath,
    this.headingDeg = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF1A1D24),
    );

    final bounds = floorPlan.bounds;
    if (bounds.width <= 0 || bounds.height <= 0) return;

    final padding = 24.0;
    final scaleX = (size.width - padding * 2) / bounds.width;
    final scaleY = (size.height - padding * 2) / bounds.height;
    final scale = math.min(scaleX, scaleY);

    final offsetX =
        padding + (size.width - padding * 2 - bounds.width * scale) / 2;
    final offsetY =
        padding + (size.height - padding * 2 - bounds.height * scale) / 2;

    Offset tx(double x, double y) => Offset(
      offsetX + (x - bounds.left) * scale,
      size.height - offsetY - (y - bounds.top) * scale,
    );

    _drawWalls(canvas, tx);
    _drawRoute(canvas, tx, scale);
    _drawBeacons(canvas, tx);
    _drawFires(canvas, tx);
    _drawUser(canvas, tx);
  }

  void _drawWalls(Canvas canvas, Offset Function(double, double) tx) {
    final wallPaint = Paint()
      ..color = const Color(0xFFE0E6F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    for (final e in floorPlan.entities) {
      switch (e.type) {
        case DxfEntityType.line:
          if (e.points.length >= 2) {
            canvas.drawLine(
              tx(e.points[0].dx, e.points[0].dy),
              tx(e.points[1].dx, e.points[1].dy),
              wallPaint,
            );
          }
          break;
        case DxfEntityType.polyline:
          if (e.points.length >= 2) {
            final path = Path()
              ..moveTo(
                tx(e.points[0].dx, e.points[0].dy).dx,
                tx(e.points[0].dx, e.points[0].dy).dy,
              );
            for (int i = 1; i < e.points.length; i++) {
              final p = tx(e.points[i].dx, e.points[i].dy);
              path.lineTo(p.dx, p.dy);
            }
            canvas.drawPath(path, wallPaint);
          }
          break;
        case DxfEntityType.circle:
          if (e.radius != null && e.points.isNotEmpty) {
            final c = tx(e.points.first.dx, e.points.first.dy);
            canvas.drawCircle(c, e.radius! * _approxScale(tx), wallPaint);
          }
          break;
        case DxfEntityType.arc:
        case DxfEntityType.text:
          break;
      }
    }
  }

  double _approxScale(Offset Function(double, double) tx) {
    final a = tx(0, 0);
    final b = tx(1, 0);
    return (b - a).distance;
  }

  void _drawRoute(
    Canvas canvas,
    Offset Function(double, double) tx,
    double scale,
  ) {
    if (routePath.length < 2) return;
    final paint = Paint()
      ..color = const Color(0xFF00E5A0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final first = tx(routePath.first.x, routePath.first.y);
    path.moveTo(first.dx, first.dy);
    for (int i = 1; i < routePath.length; i++) {
      final p = tx(routePath[i].x, routePath[i].y);
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, paint);

    final glow = Paint()
      ..color = const Color(0x4400E5A0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(path, glow);
  }

  void _drawBeacons(Canvas canvas, Offset Function(double, double) tx) {
    final paint = Paint()..color = const Color(0xFF4C8DFF);
    for (final b in beacons) {
      if (b.onFire) continue;
      canvas.drawCircle(tx(b.x, b.y), 5, paint);
    }
  }

  void _drawFires(Canvas canvas, Offset Function(double, double) tx) {
    for (final f in fireBeacons) {
      final c = tx(f.x, f.y);
      canvas.drawCircle(c, 18, Paint()..color = const Color(0x55FF3344));
      canvas.drawCircle(c, 10, Paint()..color = const Color(0xFFFF3344));
      final tp = TextPainter(
        text: const TextSpan(text: '🔥', style: TextStyle(fontSize: 18)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2));
    }
  }

  void _drawUser(Canvas canvas, Offset Function(double, double) tx) {
    if (userPosition == null) return;
    final c = tx(userPosition!.x, userPosition!.y);
    canvas.drawCircle(
      c,
      userPosition!.accuracy * _approxScale(tx),
      Paint()..color = const Color(0x224C8DFF),
    );
    canvas.drawCircle(c, 12, Paint()..color = Colors.white);
    canvas.drawCircle(c, 8, Paint()..color = const Color(0xFF4C8DFF));

    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(headingDeg * math.pi / 180);
    final triangle = Path()
      ..moveTo(0, -22)
      ..lineTo(-7, -10)
      ..lineTo(7, -10)
      ..close();
    canvas.drawPath(triangle, Paint()..color = const Color(0xFF4C8DFF));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant FloorPlanPainter old) =>
      old.userPosition != userPosition ||
      old.fireBeacons.length != fireBeacons.length ||
      old.routePath.length != routePath.length ||
      old.headingDeg != headingDeg;
}
