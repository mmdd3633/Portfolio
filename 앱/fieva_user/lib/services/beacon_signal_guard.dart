import '../models/beacon_data.dart';

class BeaconSignalGuard {
  BeaconSignalGuard({
    this.requiredConfirmations = 3,
    this.minimumConfirmationSpan = const Duration(seconds: 2),
    this.signalTimeout = const Duration(seconds: 6),
    this.minimumRssi = -100,
    this.maximumRssi = -20,
  });

  final int requiredConfirmations;
  final Duration minimumConfirmationSpan;
  final Duration signalTimeout;
  final int minimumRssi;
  final int maximumRssi;

  String? _candidateKey;
  int _confirmationCount = 0;
  DateTime? _candidateStartedAt;
  DateTime? _lastValidSignalAt;

  List<DetectedBeacon> confirm(
    List<DetectedBeacon> detected,
    Map<String, BeaconData> known, {
    DateTime? now,
  }) {
    final checkedAt = now ?? DateTime.now();
    final valid = detected.where((item) {
      final key = item.matchKey.toLowerCase();
      final age = checkedAt.difference(item.detectedAt);
      return known.containsKey(key) &&
          item.rssi >= minimumRssi &&
          item.rssi <= maximumRssi &&
          !age.isNegative &&
          age <= signalTimeout;
    }).toList()..sort((a, b) => b.rssi.compareTo(a.rssi));

    if (valid.isEmpty) {
      _resetCandidate();
      return const [];
    }

    _lastValidSignalAt = checkedAt;
    final strongestKey = valid.first.matchKey.toLowerCase();
    if (_candidateKey == strongestKey) {
      _confirmationCount++;
    } else {
      _candidateKey = strongestKey;
      _confirmationCount = 1;
      _candidateStartedAt = checkedAt;
    }

    final confirmationSpan = checkedAt.difference(
      _candidateStartedAt ?? checkedAt,
    );
    if (_confirmationCount < requiredConfirmations ||
        confirmationSpan < minimumConfirmationSpan) {
      return const [];
    }
    return valid;
  }

  bool isSignalAlive({DateTime? now}) {
    final last = _lastValidSignalAt;
    if (last == null) return false;
    return (now ?? DateTime.now()).difference(last) <= signalTimeout;
  }

  void reset() {
    _lastValidSignalAt = null;
    _resetCandidate();
  }

  void _resetCandidate() {
    _candidateKey = null;
    _confirmationCount = 0;
    _candidateStartedAt = null;
  }
}
