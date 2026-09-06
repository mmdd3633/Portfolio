import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

enum PdrMotionMode { slow, fast }

class PdrMotionSnapshot {
  final PdrMotionMode mode;
  final double kalmanProcessNoise;
  final int stepCount;
  final double distanceMeters;
  final int? stepIntervalMs;
  final DateTime timestamp;

  const PdrMotionSnapshot({
    required this.mode,
    required this.kalmanProcessNoise,
    required this.stepCount,
    required this.distanceMeters,
    required this.timestamp,
    this.stepIntervalMs,
  });

  bool get isFast => mode == PdrMotionMode.fast;

  static PdrMotionSnapshot initial() {
    return PdrMotionSnapshot(
      mode: PdrMotionMode.slow,
      kalmanProcessNoise: 0.02,
      stepCount: 0,
      distanceMeters: 0,
      timestamp: DateTime.now(),
    );
  }
}

class PdrMotionService {
  PdrMotionService({
    this.stepThreshold = 11.7,
    this.stepGap = const Duration(milliseconds: 400),
    this.fastStepThreshold = const Duration(milliseconds: 500),
    this.stepLengthMeters = 0.5,
    this.slowProcessNoise = 0.02,
    this.fastProcessNoise = 0.05,
  });

  final double stepThreshold;
  final Duration stepGap;
  final Duration fastStepThreshold;
  final double stepLengthMeters;
  final double slowProcessNoise;
  final double fastProcessNoise;

  final _controller = StreamController<PdrMotionSnapshot>.broadcast();
  StreamSubscription<AccelerometerEvent>? _accelerometerSub;
  PdrMotionSnapshot _snapshot = PdrMotionSnapshot.initial();
  DateTime? _lastStepAt;

  Stream<PdrMotionSnapshot> get motionStream => _controller.stream;
  PdrMotionSnapshot get current => _snapshot;

  Future<void> start() async {
    if (kIsWeb || _accelerometerSub != null) return;
    try {
      _accelerometerSub = accelerometerEventStream().listen(_onAccelerometer);
    } catch (error) {
      debugPrint('PDR sensor start skipped: $error');
    }
  }

  void _onAccelerometer(AccelerometerEvent event) {
    final magnitude = math.sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z,
    );
    final now = DateTime.now();
    final lastStepAt = _lastStepAt;

    if (magnitude <= stepThreshold) return;
    if (lastStepAt != null && now.difference(lastStepAt) <= stepGap) return;

    final interval = lastStepAt == null ? null : now.difference(lastStepAt);
    _lastStepAt = now;

    final isFast = interval != null && interval < fastStepThreshold;
    _snapshot = PdrMotionSnapshot(
      mode: isFast ? PdrMotionMode.fast : PdrMotionMode.slow,
      kalmanProcessNoise: isFast ? fastProcessNoise : slowProcessNoise,
      stepCount: _snapshot.stepCount + 1,
      distanceMeters: _snapshot.distanceMeters + stepLengthMeters,
      stepIntervalMs: interval?.inMilliseconds,
      timestamp: now,
    );
    _controller.add(_snapshot);
  }

  Future<void> reset() async {
    _lastStepAt = null;
    _snapshot = PdrMotionSnapshot.initial();
    _controller.add(_snapshot);
  }

  Future<void> dispose() async {
    await _accelerometerSub?.cancel();
    await _controller.close();
  }
}
