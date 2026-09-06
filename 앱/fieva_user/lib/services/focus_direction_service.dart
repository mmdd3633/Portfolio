import '../models/beacon_data.dart';

enum FocusDirectionDecision {
  searching,
  correct,
  wrongCandidate,
  wrong,
  uncertain,
}

class FocusDirectionSnapshot {
  const FocusDirectionSnapshot({
    required this.decision,
    this.delta,
    this.targetBeaconId,
  });

  final FocusDirectionDecision decision;
  final double? delta;
  final String? targetBeaconId;
}

class FocusDirectionService {
  static const _burstGap = Duration(milliseconds: 800);
  static const _holdDuration = Duration(seconds: 3);
  static const _threshold = 1.0;
  static const _strongThreshold = 3.0;

  _BurstAccumulator? _activeBurst;
  _BurstSummary? _lastCompletedBurst;
  _BurstSummary? _previousCompletedBurst;
  String? _targetKey;
  int _candidateDirection = 0;
  int _candidateCount = 0;
  int _confirmedDirection = 0;
  DateTime? _confirmedUntil;
  FocusDirectionSnapshot _lastSnapshot = const FocusDirectionSnapshot(
    decision: FocusDirectionDecision.searching,
  );

  FocusDirectionSnapshot get lastSnapshot => _lastSnapshot;

  void reset() {
    _activeBurst = null;
    _lastCompletedBurst = null;
    _previousCompletedBurst = null;
    _targetKey = null;
    _candidateDirection = 0;
    _candidateCount = 0;
    _confirmedDirection = 0;
    _confirmedUntil = null;
    _lastSnapshot = const FocusDirectionSnapshot(
      decision: FocusDirectionDecision.searching,
    );
  }

  FocusDirectionSnapshot update({
    required BeaconData targetBeacon,
    required List<DetectedBeacon> detected,
    required double? Function(String matchKey) filteredRssiFor,
    DateTime? now,
  }) {
    final currentTime = now ?? DateTime.now();
    final targetKey = targetBeacon.matchKey.toLowerCase();
    if (_targetKey != targetKey) {
      reset();
      _targetKey = targetKey;
    }

    DetectedBeacon? detectedTarget;
    for (final beacon in detected) {
      if (beacon.matchKey.toLowerCase() == targetKey) {
        detectedTarget = beacon;
      }
    }
    if (detectedTarget == null) {
      _finishBurstIfGapElapsed(currentTime);
      _lastSnapshot = FocusDirectionSnapshot(
        decision: _decisionFromHold(currentTime),
        targetBeaconId: targetBeacon.id,
      );
      return _lastSnapshot;
    }

    final filtered = filteredRssiFor(targetKey);
    if (filtered == null) {
      _lastSnapshot = FocusDirectionSnapshot(
        decision: FocusDirectionDecision.searching,
        targetBeaconId: targetBeacon.id,
      );
      return _lastSnapshot;
    }

    final active = _activeBurst;
    if (active != null &&
        detectedTarget.detectedAt.difference(active.lastAt) > _burstGap) {
      _finishActiveBurst(evaluate: true, now: currentTime);
    }

    _activeBurst ??= _BurstAccumulator(startedAt: detectedTarget.detectedAt);
    _activeBurst!.add(detectedTarget.detectedAt, filtered);
    _finishBurstIfGapElapsed(currentTime);

    _lastSnapshot = FocusDirectionSnapshot(
      decision: _decisionFromHold(currentTime),
      delta: _lastSnapshot.delta,
      targetBeaconId: targetBeacon.id,
    );
    return _lastSnapshot;
  }

  void _finishBurstIfGapElapsed(DateTime now) {
    final active = _activeBurst;
    if (active == null) return;
    if (now.difference(active.lastAt) >= _burstGap) {
      _finishActiveBurst(evaluate: true, now: now);
    }
  }

  void _finishActiveBurst({required bool evaluate, required DateTime now}) {
    final active = _activeBurst;
    if (active == null) return;
    final summary = active.summary();
    _previousCompletedBurst = _lastCompletedBurst;
    _lastCompletedBurst = summary;
    _activeBurst = null;
    if (evaluate) _evaluateBurst(summary, now);
  }

  void _evaluateBurst(_BurstSummary current, DateTime now) {
    final previous = _previousCompletedBurst;
    if (previous == null) {
      _lastSnapshot = FocusDirectionSnapshot(
        decision: _decisionFromHold(now),
        targetBeaconId: null,
      );
      return;
    }

    final delta = current.averageFilteredRssi - previous.averageFilteredRssi;
    final holdActive = _holdActive(now);
    if (delta >= _strongThreshold) {
      _confirm(1, now, delta);
      return;
    }
    if (delta <= -_strongThreshold) {
      _confirm(-1, now, delta);
      return;
    }

    var candidate = 0;
    if (delta >= _threshold) candidate = 1;
    if (delta <= -_threshold) candidate = -1;

    if (candidate == 0) {
      _candidateDirection = 0;
      _candidateCount = 0;
      if (!holdActive) {
        _confirmedDirection = 0;
        _confirmedUntil = null;
      }
      _lastSnapshot = FocusDirectionSnapshot(
        decision: _decisionFromHold(
          now,
          fallback: FocusDirectionDecision.uncertain,
        ),
        delta: delta,
        targetBeaconId: null,
      );
      return;
    }

    if (_candidateDirection == candidate) {
      _candidateCount += 1;
    } else {
      _candidateDirection = candidate;
      _candidateCount = 1;
    }

    if (!holdActive && _candidateCount >= 2) {
      _confirm(candidate, now, delta);
      return;
    }

    _lastSnapshot = FocusDirectionSnapshot(
      decision: holdActive
          ? _decisionFromHold(now)
          : candidate > 0
          ? FocusDirectionDecision.searching
          : FocusDirectionDecision.wrongCandidate,
      delta: delta,
      targetBeaconId: null,
    );
  }

  void _confirm(int direction, DateTime now, double delta) {
    _confirmedDirection = direction;
    _confirmedUntil = now.add(_holdDuration);
    _candidateDirection = direction;
    _candidateCount = 0;
    _lastSnapshot = FocusDirectionSnapshot(
      decision: direction > 0
          ? FocusDirectionDecision.correct
          : FocusDirectionDecision.wrong,
      delta: delta,
      targetBeaconId: null,
    );
  }

  bool _holdActive(DateTime now) {
    final until = _confirmedUntil;
    return until != null && now.isBefore(until);
  }

  FocusDirectionDecision _decisionFromHold(
    DateTime now, {
    FocusDirectionDecision fallback = FocusDirectionDecision.searching,
  }) {
    if (!_holdActive(now)) return fallback;
    if (_confirmedDirection > 0) return FocusDirectionDecision.correct;
    if (_confirmedDirection < 0) return FocusDirectionDecision.wrong;
    return fallback;
  }
}

class _BurstSummary {
  const _BurstSummary({required this.averageFilteredRssi});

  final double averageFilteredRssi;
}

class _BurstAccumulator {
  _BurstAccumulator({required this.startedAt}) : lastAt = startedAt;

  final DateTime startedAt;
  DateTime lastAt;
  var _count = 0;
  var _sum = 0.0;

  void add(DateTime detectedAt, double filteredRssi) {
    lastAt = detectedAt;
    _count += 1;
    _sum += filteredRssi;
  }

  _BurstSummary summary() {
    final count = _count == 0 ? 1 : _count;
    return _BurstSummary(averageFilteredRssi: _sum / count);
  }
}
