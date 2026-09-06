import 'dart:math' as math;
import 'dart:ui';

import '../models/cad_map.dart';

class EvacuationRouteResult {
  final List<Offset> points;
  final List<String> nodeIds;
  final double distanceCad;
  final String destinationId;

  const EvacuationRouteResult({
    this.points = const [],
    this.nodeIds = const [],
    this.distanceCad = 0,
    this.destinationId = '',
  });

  bool get hasRoute => points.length >= 2;
  double get distanceMeters => distanceCad / 1000;
}

class EvacuationRouteService {
  static const _h708DoorPoint = Offset(1195, 622.5);
  static const _corridorEdgeKeys = <(String, String)>[
    ('b01', 'b02'),
    ('b02', 'b03'),
    ('b03', 'b04'),
    ('b04', 'b05'),
    ('b05', 'b06'),
    ('b06', 'b07'),
    ('b07', 'b09'),
    ('b09', 'b08'),
    ('b09', 'b10'),
    ('b10', 'b11'),
    ('b11', 'b12'),
  ];

  List<CadMapBeacon> defaultCorridorBeacons(CadMap map) => map.beacons;

  bool isExitBeacon(CadMapBeacon beacon) => beacon.isExit;

  CadMapBeacon? nearestBeacon(CadMap? map, Offset point) {
    if (map == null || map.beacons.isEmpty) return null;
    CadMapBeacon? nearest;
    var bestDistance = double.infinity;
    for (final beacon in map.beacons) {
      final distance = _offsetDistance(point, Offset(beacon.x, beacon.y));
      if (distance < bestDistance) {
        nearest = beacon;
        bestDistance = distance;
      }
    }
    return nearest;
  }

  CadMapBeacon? resolveFireBeacon(CadMap? map, FireSystemStatus? fire) {
    if (map == null || fire == null || !fire.isFire || map.beacons.isEmpty) {
      return null;
    }

    final location = fire.location.toLowerCase().trim();
    for (final beacon in map.beacons) {
      if (beacon.id.toLowerCase() == location ||
          beacon.name.toLowerCase() == location ||
          beacon.displayName.toLowerCase() == location) {
        return beacon;
      }
    }
    return null;
  }

  EvacuationRouteResult evaluate({
    required CadMap? map,
    required UserLiveLocation? user,
    CadMapBeacon? fireBeacon,
  }) {
    if (map == null || user == null) return const EvacuationRouteResult();
    final graph = _routeGraphFor(map, startBeaconId: user.beaconId);
    if (graph.isEmpty || !graph.values.any((node) => node.isExit)) {
      return const EvacuationRouteResult();
    }
    return _shortestEvacRoute(graph, user, Offset(user.x, user.y), fireBeacon);
  }

  List<Offset> routeFor({
    required CadMap? map,
    required UserLiveLocation? user,
    CadMapBeacon? fireBeacon,
  }) {
    return evaluate(map: map, user: user, fireBeacon: fireBeacon).points;
  }

  bool isPointInsideMap(CadMap map, double x, double y) {
    final bounds = map.bounds;
    if (bounds == null || !bounds.isValid) return true;

    final padX = bounds.width * 0.02;
    final padY = bounds.height * 0.02;
    return x >= bounds.minX - padX &&
        x <= bounds.maxX + padX &&
        y >= bounds.minY - padY &&
        y <= bounds.maxY + padY;
  }

  double routeDistanceCad(List<Offset> route) {
    if (route.length < 2) return 0;
    var distance = 0.0;
    for (var i = 1; i < route.length; i++) {
      distance += _offsetDistance(route[i - 1], route[i]);
    }
    return distance;
  }

  Map<String, _EvacNode> _routeGraphFor(CadMap map, {String? startBeaconId}) {
    final graph = <String, _EvacNode>{
      for (final beacon in map.beacons.where(
        (beacon) =>
            beacon.id.isNotEmpty &&
            _isAllowedRouteBeacon(beacon) &&
            (!_isRoomOnlyBeacon(beacon) ||
                _beaconMatchesId(beacon, startBeaconId)),
      ))
        beacon.id: _EvacNode(
          id: beacon.id,
          point: _isRoomOnlyBeacon(beacon)
              ? _h708DoorPoint
              : Offset(beacon.x, beacon.y),
          isExit: beacon.isExit,
          isRoomOnly: _isRoomOnlyBeacon(beacon),
        ),
    };
    if (graph.length < 2) return graph;

    _connectKnownCorridorEdges(graph);
    _connectRoomOnlyNodes(graph);
    return graph;
  }

  void _connectKnownCorridorEdges(Map<String, _EvacNode> graph) {
    for (final (fromKey, toKey) in _corridorEdgeKeys) {
      final from = _nodeIdForKey(graph, fromKey);
      final to = _nodeIdForKey(graph, toKey);
      if (from != null && to != null) _connect(graph, from, to);
    }
  }

  void _connectRoomOnlyNodes(Map<String, _EvacNode> graph) {
    for (final room in graph.values.where((node) => node.isRoomOnly)) {
      final b04 = _nodeIdForKey(graph, 'b04');
      if (b04 != null) _connect(graph, room.id, b04);
    }
  }

  bool _isAllowedRouteBeacon(CadMapBeacon beacon) {
    if (_isRoomOnlyBeacon(beacon)) return true;
    final keys = [
      beacon.id,
      beacon.name,
      beacon.label,
      beacon.displayName,
      beacon.displayLabel,
    ].map(_normalizeBeaconKey);
    return keys.any((key) => RegExp(r'^b\d+$').hasMatch(key));
  }

  bool _isRoomOnlyBeacon(CadMapBeacon beacon) {
    return [
      beacon.id,
      beacon.name,
      beacon.label,
      beacon.displayName,
      beacon.displayLabel,
    ].map(_normalizeBeaconKey).any((key) => key == 'h' || key == 'h708');
  }

  bool _beaconMatchesId(CadMapBeacon beacon, String? id) {
    final target = _normalizeBeaconKey(id ?? '');
    if (target.isEmpty) return false;
    return [
      beacon.id,
      beacon.name,
      beacon.label,
      beacon.displayName,
      beacon.displayLabel,
    ].map(_normalizeBeaconKey).contains(target);
  }

  String _normalizeBeaconKey(String value) {
    final lower = value.toLowerCase().replaceAll(RegExp(r'[\s_-]+'), '').trim();
    final match = RegExp(r'^[a-z]+0*(\d+)$').firstMatch(lower);
    if (match == null) return lower;
    final letters = RegExp(r'^[a-z]+').stringMatch(lower) ?? '';
    return '$letters${int.parse(match.group(1)!)}';
  }

  void _connect(Map<String, _EvacNode> graph, String a, String b) {
    graph[a]?.neighbors.add(b);
    graph[b]?.neighbors.add(a);
  }

  String? _nodeIdForKey(Map<String, _EvacNode> graph, String key) {
    final normalized = _normalizeBeaconKey(key);
    for (final nodeId in graph.keys) {
      if (_normalizeBeaconKey(nodeId) == normalized) return nodeId;
    }
    return null;
  }

  EvacuationRouteResult _shortestEvacRoute(
    Map<String, _EvacNode> graph,
    UserLiveLocation user,
    Offset userPoint,
    CadMapBeacon? fireBeacon,
  ) {
    final fireId = fireBeacon == null
        ? null
        : _matchingNodeId(graph, fireBeacon.id) ??
              _nearestNodeId(
                graph,
                Offset(fireBeacon.x, fireBeacon.y),
                includeExits: true,
              );
    final blocked = <String>{?fireId};
    final matchedStart = _matchingNodeId(graph, user.beaconId);
    final startId = matchedStart != null && !blocked.contains(matchedStart)
        ? matchedStart
        : _nearestNodeId(
            graph,
            userPoint,
            includeExits: true,
            excludedIds: blocked,
          );
    if (startId == null || blocked.contains(startId)) {
      return const EvacuationRouteResult();
    }
    final distances = <String, double>{startId: 0};
    final previous = <String, String?>{startId: null};
    final pending = graph.keys.toSet()..removeAll(blocked);
    String? destinationId;

    while (pending.isNotEmpty) {
      String? currentId;
      var currentDistance = double.infinity;
      for (final id in pending) {
        final distance = distances[id] ?? double.infinity;
        if (distance < currentDistance) {
          currentId = id;
          currentDistance = distance;
        }
      }
      if (currentId == null || currentDistance.isInfinite) break;
      pending.remove(currentId);

      final current = graph[currentId]!;
      if (current.isExit) {
        destinationId = currentId;
        break;
      }

      for (final nextId in current.neighbors) {
        if (!pending.contains(nextId) || blocked.contains(nextId)) continue;
        final next = graph[nextId]!;
        final candidate =
            currentDistance + _offsetDistance(current.point, next.point);
        if (candidate < (distances[nextId] ?? double.infinity)) {
          distances[nextId] = candidate;
          previous[nextId] = currentId;
        }
      }
    }

    if (destinationId == null) return const EvacuationRouteResult();

    final reversedIds = <String>[];
    String? cursor = destinationId;
    while (cursor != null) {
      reversedIds.add(cursor);
      cursor = previous[cursor];
    }
    final ids = reversedIds.reversed.toList();
    final points = <Offset>[userPoint];
    for (final id in ids) {
      final point = graph[id]!.point;
      if (_offsetDistance(points.last, point) > 1) points.add(point);
    }
    if (points.length == 1) points.add(points.first);

    return EvacuationRouteResult(
      points: points,
      nodeIds: ids,
      distanceCad: routeDistanceCad(points),
      destinationId: destinationId,
    );
  }

  String? _matchingNodeId(Map<String, _EvacNode> graph, String? id) {
    if (id == null || id.trim().isEmpty) return null;
    final normalized = _normalizeBeaconKey(id);
    for (final nodeId in graph.keys) {
      if (_normalizeBeaconKey(nodeId) == normalized) return nodeId;
    }
    return null;
  }

  String? _nearestNodeId(
    Map<String, _EvacNode> graph,
    Offset point, {
    required bool includeExits,
    Set<String> excludedIds = const {},
  }) {
    String? bestId;
    var bestDistance = double.infinity;
    for (final node in graph.values) {
      if (excludedIds.contains(node.id) || (!includeExits && node.isExit)) {
        continue;
      }
      final distance = _offsetDistance(point, node.point);
      if (distance < bestDistance) {
        bestId = node.id;
        bestDistance = distance;
      }
    }
    return bestId;
  }

  double _offsetDistance(Offset a, Offset b) {
    final dx = a.dx - b.dx;
    final dy = a.dy - b.dy;
    return math.sqrt(dx * dx + dy * dy);
  }
}

class _EvacNode {
  final String id;
  final Offset point;
  final bool isExit;
  final bool isRoomOnly;
  final Set<String> neighbors = {};

  _EvacNode({
    required this.id,
    required this.point,
    required this.isExit,
    this.isRoomOnly = false,
  });
}
