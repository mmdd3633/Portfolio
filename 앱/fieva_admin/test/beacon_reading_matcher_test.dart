import 'package:flutter_test/flutter_test.dart';

import 'package:fieva_admin/models/beacon_data.dart';
import 'package:fieva_admin/models/cad_map.dart';
import 'package:fieva_admin/services/beacon_reading_matcher.dart';

void main() {
  final b02Meta = BeaconData(
    id: 'B02',
    uuid: 'f7826da6-4fa2-4e98-8024-bc5b71e0893e',
    major: 1,
    minor: 102,
    x: 20,
    y: 30,
    floorId: 'TUK_7F',
  );

  final b02Cad = CadMapBeacon(id: 'B02', x: 20, y: 30);
  final b04Cad = CadMapBeacon(id: 'B04', x: 40, y: 50);

  test(
    'returns a reading match key only for the exact CAD beacon metadata',
    () {
      expect(
        BeaconReadingMatcher.matchKeyForCadBeacon(b02Cad, [b02Meta]),
        b02Meta.matchKey,
      );

      expect(
        BeaconReadingMatcher.matchKeyForCadBeacon(b04Cad, [b02Meta]),
        isNull,
      );
    },
  );

  test(
    'does not map an unknown BLE reading to a CAD beacon by display name',
    () {
      expect(
        BeaconReadingMatcher.cadBeaconForMatchKey(
          'unknown:1:999',
          [b02Meta],
          [b02Cad, b04Cad],
        ),
        isNull,
      );
    },
  );
}
