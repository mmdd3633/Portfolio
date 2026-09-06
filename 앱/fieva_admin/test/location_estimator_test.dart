import 'package:flutter_test/flutter_test.dart';

import 'package:fieva_admin/models/beacon_data.dart';
import 'package:fieva_admin/services/location_estimator.dart';
import 'package:fieva_admin/services/pdr_motion_service.dart';

void main() {
  test('RSSI position stays on the line between the strongest beacons', () {
    final estimator = LocationEstimator();
    final first = BeaconData(
      id: 'first',
      uuid: 'test',
      major: 1,
      minor: 1,
      x: 0,
      y: 20,
      floorId: 'floor',
    );
    final second = BeaconData(
      id: 'second',
      uuid: 'test',
      major: 1,
      minor: 2,
      x: 100,
      y: 20,
      floorId: 'floor',
    );

    final result = estimator.estimate(
      [
        DetectedBeacon(
          matchKey: first.matchKey,
          rssi: -59,
          detectedAt: DateTime.now(),
        ),
        DetectedBeacon(
          matchKey: second.matchKey,
          rssi: -59,
          detectedAt: DateTime.now(),
        ),
      ],
      {first.matchKey: first, second.matchKey: second},
    );

    expect(result, isNotNull);
    expect(result!.x, closeTo(50, 0.001));
    expect(result.y, closeTo(20, 0.001));
  });

  test('PDR nudges RSSI position with a 30 to 70 blend', () {
    final estimator = LocationEstimator();
    final first = BeaconData(
      id: 'first',
      uuid: 'test',
      major: 1,
      minor: 1,
      x: 0,
      y: 20,
      floorId: 'floor',
    );
    final second = BeaconData(
      id: 'second',
      uuid: 'test',
      major: 1,
      minor: 2,
      x: 1000,
      y: 20,
      floorId: 'floor',
    );
    final detected = [
      DetectedBeacon(
        matchKey: first.matchKey,
        rssi: -59,
        detectedAt: DateTime.now(),
      ),
      DetectedBeacon(
        matchKey: second.matchKey,
        rssi: -59,
        detectedAt: DateTime.now(),
      ),
    ];
    final known = {first.matchKey: first, second.matchKey: second};

    final initial = estimator.estimate(detected, known);
    expect(initial, isNotNull);
    expect(initial!.x, closeTo(500, 0.001));

    estimator.updateMotion(
      PdrMotionSnapshot(
        mode: PdrMotionMode.slow,
        kalmanProcessNoise: 0.02,
        stepCount: 2,
        distanceMeters: 1,
        timestamp: DateTime.now(),
      ),
    );

    final moved = estimator.estimate(detected, known);

    expect(moved, isNotNull);
    expect(moved!.x, closeTo(650, 0.001));
    expect(moved.y, closeTo(20, 0.001));
    expect(moved.walkingDistanceMeters, 1);
  });
}
