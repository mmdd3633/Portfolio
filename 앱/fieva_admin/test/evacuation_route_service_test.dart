import 'package:flutter_test/flutter_test.dart';

import 'package:fieva_admin/models/cad_map.dart';
import 'package:fieva_admin/services/evacuation_route_service.dart';

void main() {
  final map = CadMap(
    id: 'final-map',
    originalFile: 'TUK_7F.dxf',
    imageUrl: 'map_results/final-map/map.png',
    imagePath: 'map_results/final-map/map.png',
    roomCount: 0,
    exitCount: 2,
    beacons: [
      CadMapBeacon(id: 'B01', x: 0, y: 0, isExit: true),
      CadMapBeacon(id: 'B02', x: 10000, y: 0),
      CadMapBeacon(id: 'B03', x: 20000, y: 0),
      CadMapBeacon(id: 'B04', x: 30000, y: 0, isExit: true),
    ],
  );

  test('routes to an exit beacon and avoids the fire beacon', () {
    final result = EvacuationRouteService().evaluate(
      map: map,
      user: UserLiveLocation(x: 10000, y: 0, mapId: map.id, beaconId: 'B02'),
      fireBeacon: map.beacons.first,
    );

    expect(result.hasRoute, isTrue);
    expect(result.destinationId, 'B04');
    expect(result.nodeIds, isNot(contains('B01')));
  });

  test('recognizes exit metadata from the confirmed beacon schema', () {
    final beacon = CadMapBeacon.fromMap({
      'name': 'B09',
      'label': '출구 비콘',
      'displayLabel': 'B09 (EXIT)',
      'isExit': true,
      'type': 'exit',
      'x': 1,
      'y': 2,
    });

    expect(beacon.id, 'B09');
    expect(beacon.isExit, isTrue);
    expect(beacon.displayName, 'B09 (EXIT)');
  });

  test('does not route through H708 unless the user starts in H708', () {
    final mapWithRoomBeacon = CadMap(
      id: 'final-map',
      originalFile: 'TUK_7F.dxf',
      imageUrl: 'map_results/final-map/map.png',
      imagePath: 'map_results/final-map/map.png',
      roomCount: 0,
      exitCount: 1,
      beacons: [
        CadMapBeacon(id: 'B02', x: -1000, y: 0),
        CadMapBeacon(id: 'B03', x: 0, y: 0),
        CadMapBeacon(id: 'H', name: 'H708', x: 5000, y: 250),
        CadMapBeacon(id: 'B04', x: 10000, y: 0, isExit: true),
        CadMapBeacon(id: 'B05', x: 10500, y: 0),
      ],
    );
    final service = EvacuationRouteService();

    final corridorRoute = service.evaluate(
      map: mapWithRoomBeacon,
      user: UserLiveLocation(
        x: 0,
        y: 0,
        mapId: mapWithRoomBeacon.id,
        beaconId: 'B03',
      ),
    );

    expect(corridorRoute.hasRoute, isTrue);
    expect(corridorRoute.nodeIds, isNot(contains('H')));

    final roomRoute = service.evaluate(
      map: mapWithRoomBeacon,
      user: UserLiveLocation(
        x: 5000,
        y: 250,
        mapId: mapWithRoomBeacon.id,
        beaconId: 'H',
      ),
    );

    expect(roomRoute.hasRoute, isTrue);
    expect(roomRoute.nodeIds.first, 'H');
  });
}
