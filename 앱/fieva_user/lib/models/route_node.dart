import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';

class RouteNode {
  final String id;
  final double x;
  final double y;
  final String floorId;
  final bool isExit;
  final List<String> neighborIds;

  RouteNode({
    required this.id,
    required this.x,
    required this.y,
    required this.floorId,
    this.isExit = false,
    this.neighborIds = const [],
  });

  factory RouteNode.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RouteNode(
      id: doc.id,
      x: (data['x'] as num).toDouble(),
      y: (data['y'] as num).toDouble(),
      floorId: data['floorId'] as String? ?? 'default',
      isExit: data['isExit'] as bool? ?? false,
      neighborIds: List<String>.from(data['neighbors'] as List? ?? []),
    );
  }

  double distanceTo(RouteNode other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return math.sqrt(dx * dx + dy * dy);
  }
}

class NavStep {
  final RouteNode from;
  final RouteNode to;
  final double distance;
  final double bearing;
  final TurnDirection turn;

  NavStep({
    required this.from,
    required this.to,
    required this.distance,
    required this.bearing,
    required this.turn,
  });
}

enum TurnDirection {
  straight,
  left,
  right,
  slightLeft,
  slightRight,
  uTurn,
  arrive,
}

TurnDirection computeTurn(double prevBearing, double nextBearing) {
  double diff = (nextBearing - prevBearing + 540) % 360 - 180;
  if (diff.abs() < 20) return TurnDirection.straight;
  if (diff.abs() > 150) return TurnDirection.uTurn;
  if (diff > 60) return TurnDirection.right;
  if (diff < -60) return TurnDirection.left;
  return diff > 0 ? TurnDirection.slightRight : TurnDirection.slightLeft;
}
