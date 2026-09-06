import 'package:flutter_test/flutter_test.dart';

import 'package:fieva_admin/services/admin_evacuation_test_flow.dart';

void main() {
  test(
    'starts the beacon broadcast and then waits when BLE location is missing',
    () {
      final decision = AdminEvacuationTestFlow.decide(
        hasMap: true,
        adminModeEnabled: true,
        hasUserLocation: false,
      );

      expect(decision, AdminEvacuationTestDecision.startAndWaitForBleLocation);
    },
  );

  test('starts only when map, admin mode, and BLE location are all ready', () {
    final decision = AdminEvacuationTestFlow.decide(
      hasMap: true,
      adminModeEnabled: true,
      hasUserLocation: true,
    );

    expect(decision, AdminEvacuationTestDecision.start);
  });
}
