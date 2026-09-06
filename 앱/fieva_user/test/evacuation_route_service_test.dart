import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:fieva_user/models/cad_map.dart';
import 'package:fieva_user/services/evacuation_route_service.dart';

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

  test('uses the H708 door point only when the user starts in H708', () {
    final mapWithRoomBeacon = CadMap(
      id: 'final-map',
      originalFile: 'TUK_7F.dxf',
      imageUrl: 'map_results/final-map/map.png',
      imagePath: 'map_results/final-map/map.png',
      roomCount: 0,
      exitCount: 1,
      beacons: [
        CadMapBeacon(id: 'B02', x: 900, y: 622),
        CadMapBeacon(id: 'B03', x: 1050, y: 622),
        CadMapBeacon(id: 'H', name: 'H708', x: 1195, y: 500),
        CadMapBeacon(id: 'B04', x: 1300, y: 622, isExit: true),
        CadMapBeacon(id: 'B05', x: 1450, y: 622),
      ],
    );
    final service = EvacuationRouteService();

    final corridorRoute = service.evaluate(
      map: mapWithRoomBeacon,
      user: UserLiveLocation(
        x: 1050,
        y: 622,
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
        y: 500,
        mapId: mapWithRoomBeacon.id,
        beaconId: 'H',
      ),
    );

    expect(roomRoute.hasRoute, isTrue);
    expect(roomRoute.nodeIds.first, 'H');
    expect(roomRoute.nodeIds[1], 'B04');
    expect(roomRoute.points, contains(const Offset(1195, 622.5)));
  });

  test('connects H708 only to the door-adjacent corridor beacons', () {
    final mapWithB12NearDoor = CadMap(
      id: 'final-map',
      originalFile: 'TUK_7F.dxf',
      imageUrl: 'map_results/final-map/map.png',
      imagePath: 'map_results/final-map/map.png',
      roomCount: 0,
      exitCount: 1,
      beacons: [
        CadMapBeacon(id: 'B03', x: 1050, y: 622, isExit: true),
        CadMapBeacon(id: 'H', name: 'H708', x: 1195, y: 500),
        CadMapBeacon(id: 'B12', x: 1196, y: 623),
        CadMapBeacon(id: 'B04', x: 1300, y: 622),
        CadMapBeacon(id: 'B05', x: 9000, y: 622),
      ],
    );

    final result = EvacuationRouteService().evaluate(
      map: mapWithB12NearDoor,
      user: UserLiveLocation(
        x: 1195,
        y: 500,
        mapId: mapWithB12NearDoor.id,
        beaconId: 'H',
      ),
      fireBeacon: mapWithB12NearDoor.beacons.last,
    );

    expect(result.hasRoute, isTrue);
    expect(result.nodeIds.take(2), isNot(contains('B12')));
  });

  test('starts corridor route at the current user position', () {
    final corridorMap = CadMap(
      id: 'final-map',
      originalFile: 'TUK_7F.dxf',
      imageUrl: 'map_results/final-map/map.png',
      imagePath: 'map_results/final-map/map.png',
      roomCount: 0,
      exitCount: 1,
      beacons: [
        CadMapBeacon(id: 'B01', x: 1000, y: 1000, isExit: true),
        CadMapBeacon(id: 'B02', x: 1000, y: 2000),
        CadMapBeacon(id: 'B03', x: 1000, y: 3000),
        CadMapBeacon(id: 'B04', x: 1000, y: 4000),
      ],
    );

    final result = EvacuationRouteService().evaluate(
      map: corridorMap,
      user: UserLiveLocation(
        x: 1300,
        y: 3500,
        mapId: corridorMap.id,
        beaconId: 'B03',
      ),
    );

    expect(result.hasRoute, isTrue);
    expect(result.points.first, const Offset(1300, 3500));
  });

  test('routes H708 to B01 through B04 first when B05 is on fire', () {
    final h708Map = CadMap(
      id: 'final-map',
      originalFile: 'TUK_7F.dxf',
      imageUrl: 'map_results/final-map/map.png',
      imagePath: 'map_results/final-map/map.png',
      roomCount: 0,
      exitCount: 2,
      beacons: [
        CadMapBeacon(id: 'B01', x: 1000, y: 1000, isExit: true),
        CadMapBeacon(id: 'B02', x: 1000, y: 2000),
        CadMapBeacon(id: 'B03', x: 1000, y: 3000),
        CadMapBeacon(id: 'H', name: 'H708', x: 800, y: 3600),
        CadMapBeacon(id: 'B04', x: 1000, y: 4000),
        CadMapBeacon(id: 'B05', x: 1000, y: 5000, isExit: true),
        CadMapBeacon(id: 'B08', x: 5000, y: 5000),
        CadMapBeacon(id: 'B12', x: 7000, y: 5000, isExit: true),
      ],
    );

    final result = EvacuationRouteService().evaluate(
      map: h708Map,
      user: UserLiveLocation(x: 800, y: 3600, mapId: h708Map.id, beaconId: 'H'),
      fireBeacon: h708Map.beacons.firstWhere((beacon) => beacon.id == 'B05'),
    );

    expect(result.hasRoute, isTrue);
    expect(result.destinationId, 'B01');
    expect(result.nodeIds, ['H', 'B04', 'B03', 'B02', 'B01']);
  });
}
