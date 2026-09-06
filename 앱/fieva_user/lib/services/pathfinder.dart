import 'dart:math' as math;
import '../models/route_node.dart';
import '../models/beacon_data.dart';

class Pathfinder {
  final Map<String, RouteNode> nodes;
  final double fireAvoidRadius;
  final double fireAvoidPenalty;

  Pathfinder({
    required this.nodes,
    this.fireAvoidRadius = 5.0,
    this.fireAvoidPenalty = 1000.0,
  });

  List<RouteNode>? findRouteToNearestExit(
    double startX,
    double startY,
    String floorId,
    List<BeaconData> fireBeacons,
  ) {
    final start = _nearestNode(startX, startY, floorId);
    if (start == null) return null;

    final exits = nodes.values
        .where((n) => n.isExit && n.floorId == floorId)
        .toList();
    if (exits.isEmpty) return null;

    List<RouteNode>? best;
    double bestCost = double.infinity;

    for (final exit in exits) {
      final result = _aStar(start, exit, fireBeacons);
      if (result != null && result.cost < bestCost) {
        bestCost = result.cost;
        best = result.path;
      }
    }
    return best;
  }

  RouteNode? _nearestNode(double x, double y, String floorId) {
    RouteNode? nearest;
    double minDist = double.infinity;
    for (final node in nodes.values) {
      if (node.floorId != floorId) continue;
      final dx = node.x - x;
      final dy = node.y - y;
      final d = dx * dx + dy * dy;
      if (d < minDist) {
        minDist = d;
        nearest = node;
      }
    }
    return nearest;
  }

  _PathResult? _aStar(RouteNode start, RouteNode goal, List<BeaconData> fires) {
    final openSet = HeapPriorityQueue<_PqEntry>((a, b) => a.f.compareTo(b.f));
    final gScore = <String, double>{start.id: 0};
    final cameFrom = <String, RouteNode>{};

    openSet.add(_PqEntry(start, _heuristic(start, goal)));

    while (openSet.isNotEmpty) {
      final current = openSet.removeFirst().node;
      if (current.id == goal.id) {
        return _PathResult(
          _reconstruct(cameFrom, current),
          gScore[current.id]!,
        );
      }

      for (final neighborId in current.neighborIds) {
        final neighbor = nodes[neighborId];
        if (neighbor == null) continue;
        final edgeCost =
            current.distanceTo(neighbor) +
            _firePenalty(current, neighbor, fires);
        final tentative = gScore[current.id]! + edgeCost;
        if (tentative < (gScore[neighborId] ?? double.infinity)) {
          cameFrom[neighborId] = current;
          gScore[neighborId] = tentative;
          openSet.add(
            _PqEntry(neighbor, tentative + _heuristic(neighbor, goal)),
          );
        }
      }
    }
    return null;
  }

  double _heuristic(RouteNode a, RouteNode b) => a.distanceTo(b);

  double _firePenalty(RouteNode a, RouteNode b, List<BeaconData> fires) {
    if (fires.isEmpty) return 0;
    final midX = (a.x + b.x) / 2;
    final midY = (a.y + b.y) / 2;
    double penalty = 0;
    for (final f in fires) {
      final dx = f.x - midX;
      final dy = f.y - midY;
      final d = math.sqrt(dx * dx + dy * dy);
      if (d < fireAvoidRadius) {
        penalty += fireAvoidPenalty * (1.0 - d / fireAvoidRadius);
      }
    }
    return penalty;
  }

  List<RouteNode> _reconstruct(Map<String, RouteNode> cameFrom, RouteNode end) {
    final path = <RouteNode>[end];
    var current = end;
    while (cameFrom.containsKey(current.id)) {
      current = cameFrom[current.id]!;
      path.insert(0, current);
    }
    return path;
  }

  static List<NavStep> toNavSteps(List<RouteNode> path) {
    if (path.length < 2) return [];
    final steps = <NavStep>[];
    double? prevBearing;
    for (int i = 0; i < path.length - 1; i++) {
      final from = path[i];
      final to = path[i + 1];
      final dx = to.x - from.x;
      final dy = to.y - from.y;
      final distance = math.sqrt(dx * dx + dy * dy);
      final bearing = math.atan2(dx, -dy) * 180 / math.pi;
      final normBearing = (bearing + 360) % 360;
      final turn = prevBearing == null
          ? TurnDirection.straight
          : computeTurn(prevBearing, normBearing);
      steps.add(
        NavStep(
          from: from,
          to: to,
          distance: distance,
          bearing: normBearing,
          turn: i == path.length - 2 ? TurnDirection.arrive : turn,
        ),
      );
      prevBearing = normBearing;
    }
    return steps;
  }
}

class _PqEntry {
  final RouteNode node;
  final double f;
  _PqEntry(this.node, this.f);
}

class _PathResult {
  final List<RouteNode> path;
  final double cost;
  _PathResult(this.path, this.cost);
}

class HeapPriorityQueue<T> {
  final List<T> _heap = [];
  final int Function(T, T) _compare;

  HeapPriorityQueue(this._compare);

  bool get isNotEmpty => _heap.isNotEmpty;
  int get length => _heap.length;

  void add(T value) {
    _heap.add(value);
    _bubbleUp(_heap.length - 1);
  }

  T removeFirst() {
    final first = _heap.first;
    final last = _heap.removeLast();
    if (_heap.isNotEmpty) {
      _heap[0] = last;
      _bubbleDown(0);
    }
    return first;
  }

  void _bubbleUp(int i) {
    while (i > 0) {
      final parent = (i - 1) ~/ 2;
      if (_compare(_heap[i], _heap[parent]) < 0) {
        final tmp = _heap[i];
        _heap[i] = _heap[parent];
        _heap[parent] = tmp;
        i = parent;
      } else {
        break;
      }
    }
  }

  void _bubbleDown(int i) {
    final n = _heap.length;
    while (true) {
      final l = 2 * i + 1;
      final r = 2 * i + 2;
      int smallest = i;
      if (l < n && _compare(_heap[l], _heap[smallest]) < 0) smallest = l;
      if (r < n && _compare(_heap[r], _heap[smallest]) < 0) smallest = r;
      if (smallest == i) break;
      final tmp = _heap[i];
      _heap[i] = _heap[smallest];
      _heap[smallest] = tmp;
      i = smallest;
    }
  }
}
