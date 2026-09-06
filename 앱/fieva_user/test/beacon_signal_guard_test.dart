import 'package:flutter_test/flutter_test.dart';

import 'package:fieva_user/models/beacon_data.dart';
import 'package:fieva_user/services/beacon_signal_guard.dart';

void main() {
  final beacon = BeaconData(
    id: 'B01',
    uuid: 'f7826da6-4fa2-4e98-8024-bc5b71e0893e',
    major: 1,
    minor: 100,
    x: 10,
    y: 20,
    floorId: '7F',
  );

  test('requires sustained real beacon callbacks before confirming', () {
    final guard = BeaconSignalGuard();
    final known = {beacon.matchKey: beacon};
    final started = DateTime(2026, 6, 13, 10);

    List<DetectedBeacon> batch(DateTime at) => [
      DetectedBeacon(matchKey: beacon.matchKey, rssi: -60, detectedAt: at),
    ];

    expect(guard.confirm(batch(started), known, now: started), isEmpty);
    expect(
      guard.confirm(
        batch(started.add(const Duration(seconds: 1))),
        known,
        now: started.add(const Duration(seconds: 1)),
      ),
      isEmpty,
    );
    expect(
      guard.confirm(
        batch(started.add(const Duration(seconds: 2))),
        known,
        now: started.add(const Duration(seconds: 2)),
      ),
      hasLength(1),
    );
  });

  test('rejects invalid RSSI and expires a lost signal', () {
    final guard = BeaconSignalGuard(
      requiredConfirmations: 1,
      minimumConfirmationSpan: Duration.zero,
    );
    final known = {beacon.matchKey: beacon};
    final now = DateTime(2026, 6, 13, 10);

    expect(
      guard.confirm(
        [DetectedBeacon(matchKey: beacon.matchKey, rssi: 0, detectedAt: now)],
        known,
        now: now,
      ),
      isEmpty,
    );
    expect(
      guard.confirm(
        [DetectedBeacon(matchKey: beacon.matchKey, rssi: -60, detectedAt: now)],
        known,
        now: now,
      ),
      hasLength(1),
    );
    expect(
      guard.isSignalAlive(now: now.add(const Duration(seconds: 7))),
      isFalse,
    );
  });
}
