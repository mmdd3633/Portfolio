import 'dart:ui';

enum DxfEntityType { line, polyline, circle, arc, text }

class DxfEntity {
  final DxfEntityType type;
  final List<Offset> points;
  final double? radius;
  final double? startAngle;
  final double? endAngle;
  final String? text;
  final String layer;

  DxfEntity({
    required this.type,
    required this.points,
    this.radius,
    this.startAngle,
    this.endAngle,
    this.text,
    this.layer = '0',
  });
}

class FloorPlan {
  final String floorId;
  final String name;
  final List<DxfEntity> entities;
  final Rect bounds;

  FloorPlan({
    required this.floorId,
    required this.name,
    required this.entities,
    required this.bounds,
  });

  static Rect computeBounds(List<DxfEntity> entities) {
    if (entities.isEmpty) return const Rect.fromLTWH(0, 0, 100, 100);
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;
    for (final e in entities) {
      for (final p in e.points) {
        if (p.dx < minX) minX = p.dx;
        if (p.dy < minY) minY = p.dy;
        if (p.dx > maxX) maxX = p.dx;
        if (p.dy > maxY) maxY = p.dy;
      }
      if (e.radius != null && e.points.isNotEmpty) {
        final c = e.points.first;
        minX = minX < c.dx - e.radius! ? minX : c.dx - e.radius!;
        minY = minY < c.dy - e.radius! ? minY : c.dy - e.radius!;
        maxX = maxX > c.dx + e.radius! ? maxX : c.dx + e.radius!;
        maxY = maxY > c.dy + e.radius! ? maxY : c.dy + e.radius!;
      }
    }
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }
}
