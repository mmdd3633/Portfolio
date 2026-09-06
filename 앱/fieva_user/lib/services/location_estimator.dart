import 'dart:ui';
import '../models/beacon_data.dart';
import 'pdr_motion_service.dart';

class EstimatedPosition {
  final double x;
  final double y;
  final double accuracy;
  final String floorId;
  final DateTime timestamp;
  final PdrMotionMode motionMode;
  final double kalmanProcessNoise;
  final int stepCount;
  final double walkingDistanceMeters;

  EstimatedPosition({
    required this.x,
    required this.y,
    required this.accuracy,
    required this.floorId,
    required this.timestamp,
    this.motionMode = PdrMotionMode.slow,
    this.kalmanProcessNoise = 0.02,
    this.stepCount = 0,
    this.walkingDistanceMeters = 0,
  });

  Offset toOffset() => Offset(x, y);
}

class LocationEstimator {
  final _filters = <String, _AdaptiveRssiFilter>{};
  final _lastFilteredRssi = <String, double>{};
  PdrMotionSnapshot _motion = PdrMotionSnapshot.initial();
  Offset? _lastRssiPosition;
  Offset? _pdrPosition;
  String? _pdrSegmentKey;
  double _lastPdrDistanceMeters = 0;
  static const _emaAlpha = 0.3;
  static const _measurementNoise = 0.2;
  static const _rssiWeight = 0.70;
  static const _pdrWeight = 0.30;
  static const _cadUnitsPerMeter = 1000.0;

  void updateMotion(PdrMotionSnapshot motion) {
    _motion = motion;
    for (final filter in _filters.values) {
      filter.setProcessNoise(motion.kalmanProcessNoise);
    }
  }

  EstimatedPosition? estimate(
    List<DetectedBeacon> detected,
    Map<String, BeaconData> known,
  ) {
    if (detected.isEmpty) return null;

    final weighted = <_WeightedBeacon>[];
    String? floorId;

    for (final d in detected) {
      final matchKey = d.matchKey.toLowerCase();
      final beacon = known[matchKey];
      if (beacon == null) continue;
      final filter = _filters.putIfAbsent(
        matchKey,
        () => _AdaptiveRssiFilter(
          initialMeasurement: d.rssi.toDouble(),
          processNoise: _motion.kalmanProcessNoise,
          measurementNoise: _measurementNoise,
          emaAlpha: _emaAlpha,
        ),
      );
      final filteredRssi = filter.update(d.rssi.toDouble());
      _lastFilteredRssi[matchKey] = filteredRssi;
      final dist = BeaconData.rssiToDistance(
        filteredRssi.round(),
        beacon.txPower,
      );
      if (dist <= 0) continue;
      weighted.add(_WeightedBeacon(beacon, dist));
      floorId ??= beacon.mapId.isNotEmpty ? beacon.mapId : beacon.floorId;
    }

    if (weighted.isEmpty) return null;

    weighted.sort((a, b) => a.distance.compareTo(b.distance));
    final primary = weighted.first;
    var x = primary.beacon.x;
    var y = primary.beacon.y;
    var accuracy = primary.distance;

    // Model the corridor as invisible line segments between nearby beacons.
    if (weighted.length >= 2) {
      final secondary = weighted[1];
      final distanceSum = primary.distance + secondary.distance;
      final t = distanceSum <= 0
          ? 0.0
          : (primary.distance / distanceSum).clamp(0.0, 1.0).toDouble();
      x = primary.beacon.x + (secondary.beacon.x - primary.beacon.x) * t;
      y = primary.beacon.y + (secondary.beacon.y - primary.beacon.y) * t;
      accuracy = (primary.distance + secondary.distance) / 2;
    }

    final rssiPosition = Offset(x, y);
    final fusedPosition = weighted.length >= 2
        ? _fuseWithPdr(rssiPosition, primary.beacon, weighted[1].beacon)
        : rssiPosition;
    x = fusedPosition.dx;
    y = fusedPosition.dy;
    _lastRssiPosition = rssiPosition;

    return EstimatedPosition(
      x: x,
      y: y,
      accuracy: accuracy,
      floorId: floorId ?? 'default',
      timestamp: DateTime.now(),
      motionMode: _motion.mode,
      kalmanProcessNoise: _motion.kalmanProcessNoise,
      stepCount: _motion.stepCount,
      walkingDistanceMeters: _motion.distanceMeters,
    );
  }

  void reset() {
    _filters.clear();
    _lastFilteredRssi.clear();
    _motion = PdrMotionSnapshot.initial();
    _lastRssiPosition = null;
    _pdrPosition = null;
    _pdrSegmentKey = null;
    _lastPdrDistanceMeters = 0;
  }

  double? filteredRssiFor(String matchKey) {
    return _lastFilteredRssi[matchKey.toLowerCase()];
  }

  Offset _fuseWithPdr(
    Offset rssiPosition,
    BeaconData primary,
    BeaconData secondary,
  ) {
    final segmentKey = _segmentKey(primary, secondary);
    if (_pdrPosition == null || _pdrSegmentKey != segmentKey) {
      _pdrPosition = rssiPosition;
      _pdrSegmentKey = segmentKey;
      _lastPdrDistanceMeters = _motion.distanceMeters;
      return rssiPosition;
    }

    final distanceDeltaMeters =
        (_motion.distanceMeters - _lastPdrDistanceMeters).clamp(0.0, 20.0);
    _lastPdrDistanceMeters = _motion.distanceMeters;

    final start = Offset(primary.x, primary.y);
    final end = Offset(secondary.x, secondary.y);
    final direction = _pdrDirection(rssiPosition, start, end);
    final pdrStep = direction * (distanceDeltaMeters * _cadUnitsPerMeter);
    final nextPdrPosition = _clampToSegment(
      _pdrPosition! + pdrStep,
      start,
      end,
    );
    _pdrPosition = nextPdrPosition;

    return Offset(
      rssiPosition.dx * _rssiWeight + nextPdrPosition.dx * _pdrWeight,
      rssiPosition.dy * _rssiWeight + nextPdrPosition.dy * _pdrWeight,
    );
  }

  String _segmentKey(BeaconData a, BeaconData b) {
    final keys = [a.matchKey.toLowerCase(), b.matchKey.toLowerCase()]..sort();
    return '${keys[0]}|${keys[1]}';
  }

  Offset _pdrDirection(Offset rssiPosition, Offset start, Offset end) {
    final previousRssi = _lastRssiPosition;
    if (previousRssi != null) {
      final rssiDelta = rssiPosition - previousRssi;
      if (rssiDelta.distance > 1) return _unit(rssiDelta);
    }
    return _unit(end - start);
  }

  Offset _clampToSegment(Offset point, Offset start, Offset end) {
    final segment = end - start;
    final lengthSquared = segment.dx * segment.dx + segment.dy * segment.dy;
    if (lengthSquared <= 0) return start;

    final relative = point - start;
    final t =
        ((relative.dx * segment.dx + relative.dy * segment.dy) / lengthSquared)
            .clamp(0.0, 1.0)
            .toDouble();
    return start + segment * t;
  }

  Offset _unit(Offset value) {
    final distance = value.distance;
    if (distance <= 0.001) return Offset.zero;
    return Offset(value.dx / distance, value.dy / distance);
  }
}

class _WeightedBeacon {
  final BeaconData beacon;
  final double distance;
  _WeightedBeacon(this.beacon, this.distance);
}

class _AdaptiveRssiFilter {
  _AdaptiveRssiFilter({
    required double initialMeasurement,
    required double processNoise,
    required this.measurementNoise,
    required this.emaAlpha,
  }) : _kalman = _ScalarKalmanFilter(
         processNoise: processNoise,
         measurementNoise: measurementNoise,
         initialEstimate: initialMeasurement,
       ),
       _ema = initialMeasurement;

  final double measurementNoise;
  final double emaAlpha;
  final _ScalarKalmanFilter _kalman;
  double _ema;

  void setProcessNoise(double value) {
    _kalman.processNoise = value;
  }

  double update(double measurement) {
    _ema = emaAlpha * measurement + (1 - emaAlpha) * _ema;
    return _kalman.update(_ema);
  }
}

class _ScalarKalmanFilter {
  _ScalarKalmanFilter({
    required this.processNoise,
    required this.measurementNoise,
    required double initialEstimate,
  }) : _estimate = initialEstimate;

  double processNoise;
  final double measurementNoise;
  double _estimate;
  double _errorCovariance = 10;

  double update(double measurement) {
    final predictedCovariance = _errorCovariance + processNoise;
    final gain = predictedCovariance / (predictedCovariance + measurementNoise);
    _estimate = _estimate + gain * (measurement - _estimate);
    _errorCovariance = (1 - gain) * predictedCovariance;
    return _estimate;
  }
}
