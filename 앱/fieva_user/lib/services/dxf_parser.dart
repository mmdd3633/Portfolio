import 'dart:ui';
import '../models/floor_plan.dart';

class DxfParser {
  static FloorPlan parse(
    String content, {
    required String floorId,
    String name = '',
  }) {
    final lines = content.split(RegExp(r'\r?\n'));
    final entities = <DxfEntity>[];

    int i = 0;
    String? section;

    while (i < lines.length - 1) {
      final code = lines[i].trim();
      final value = lines[i + 1].trim();
      i += 2;

      if (code == '0' && value == 'SECTION') {
        continue;
      }
      if (code == '2' && (value == 'ENTITIES' || value == 'BLOCKS')) {
        section = value;
        continue;
      }
      if (code == '0' && value == 'ENDSEC') {
        section = null;
        continue;
      }
      if (section != 'ENTITIES') continue;

      if (code == '0') {
        final entity = _parseEntity(value, lines, i);
        if (entity.entity != null) entities.add(entity.entity!);
        i = entity.nextIndex;
      }
    }

    final bounds = FloorPlan.computeBounds(entities);
    return FloorPlan(
      floorId: floorId,
      name: name.isEmpty ? floorId : name,
      entities: entities,
      bounds: bounds,
    );
  }

  static _EntityResult _parseEntity(
    String type,
    List<String> lines,
    int startIdx,
  ) {
    int i = startIdx;
    final attrs = <int, String>{};
    final polyPoints = <Offset>[];

    while (i < lines.length - 1) {
      final code = int.tryParse(lines[i].trim());
      final value = lines[i + 1].trim();
      if (code == null) {
        i += 2;
        continue;
      }
      if (code == 0) break;

      if ((type == 'LWPOLYLINE' || type == 'POLYLINE') &&
          (code == 10 || code == 20)) {
        if (code == 10) {
          final x = double.tryParse(value) ?? 0;
          attrs[10] = value;
          if (attrs.containsKey(20)) {
            polyPoints.add(Offset(x, double.tryParse(attrs[20]!) ?? 0));
            attrs.remove(20);
          }
        } else if (code == 20) {
          final y = double.tryParse(value) ?? 0;
          if (attrs.containsKey(10)) {
            polyPoints.add(Offset(double.tryParse(attrs[10]!) ?? 0, y));
            attrs.remove(10);
          } else {
            attrs[20] = value;
          }
        }
      } else {
        attrs[code] = value;
      }
      i += 2;
    }

    DxfEntity? entity;
    final layer = attrs[8] ?? '0';

    switch (type) {
      case 'LINE':
        final x1 = double.tryParse(attrs[10] ?? '') ?? 0;
        final y1 = double.tryParse(attrs[20] ?? '') ?? 0;
        final x2 = double.tryParse(attrs[11] ?? '') ?? 0;
        final y2 = double.tryParse(attrs[21] ?? '') ?? 0;
        entity = DxfEntity(
          type: DxfEntityType.line,
          points: [Offset(x1, y1), Offset(x2, y2)],
          layer: layer,
        );
        break;
      case 'CIRCLE':
        final cx = double.tryParse(attrs[10] ?? '') ?? 0;
        final cy = double.tryParse(attrs[20] ?? '') ?? 0;
        final r = double.tryParse(attrs[40] ?? '') ?? 0;
        entity = DxfEntity(
          type: DxfEntityType.circle,
          points: [Offset(cx, cy)],
          radius: r,
          layer: layer,
        );
        break;
      case 'ARC':
        final cx = double.tryParse(attrs[10] ?? '') ?? 0;
        final cy = double.tryParse(attrs[20] ?? '') ?? 0;
        final r = double.tryParse(attrs[40] ?? '') ?? 0;
        final sa = double.tryParse(attrs[50] ?? '') ?? 0;
        final ea = double.tryParse(attrs[51] ?? '') ?? 0;
        entity = DxfEntity(
          type: DxfEntityType.arc,
          points: [Offset(cx, cy)],
          radius: r,
          startAngle: sa,
          endAngle: ea,
          layer: layer,
        );
        break;
      case 'LWPOLYLINE':
      case 'POLYLINE':
        if (polyPoints.isNotEmpty) {
          entity = DxfEntity(
            type: DxfEntityType.polyline,
            points: polyPoints,
            layer: layer,
          );
        }
        break;
      case 'TEXT':
      case 'MTEXT':
        final x = double.tryParse(attrs[10] ?? '') ?? 0;
        final y = double.tryParse(attrs[20] ?? '') ?? 0;
        entity = DxfEntity(
          type: DxfEntityType.text,
          points: [Offset(x, y)],
          text: attrs[1],
          layer: layer,
        );
        break;
    }

    return _EntityResult(entity, i);
  }
}

class _EntityResult {
  final DxfEntity? entity;
  final int nextIndex;
  _EntityResult(this.entity, this.nextIndex);
}
