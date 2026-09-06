import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';

class BeaconData {
  final String id;
  final String name;
  final String label;
  final String displayLabel;
  final String type;
  final String mapId;
  final bool isExit;
  final String uuid;
  final int major;
  final int minor;
  final double x;
  final double y;
  final String floorId;
  final int txPower;
  final bool onFire;
  final DateTime? fireDetectedAt;

  BeaconData({
    required this.id,
    String? name,
    this.label = '',
    this.displayLabel = '',
    this.type = 'normal',
    this.mapId = '',
    this.isExit = false,
    required this.uuid,
    required this.major,
    required this.minor,
    required this.x,
    required this.y,
    required this.floorId,
    this.txPower = -59,
    this.onFire = false,
    this.fireDetectedAt,
  }) : name = name ?? id;

  String get displayName {
    if (displayLabel.trim().isNotEmpty) return displayLabel.trim();
    if (name.trim().isNotEmpty) return name.trim();
    return id;
  }

  factory BeaconData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final name = data['name'] as String? ?? doc.id;
    final label = data['label'] as String? ?? '';
    final displayLabel =
        data['displayLabel'] as String? ??
        data['display_label'] as String? ??
        '';
    final type = data['type'] as String? ?? 'normal';
    return BeaconData(
      id: doc.id,
      name: name,
      label: label,
      displayLabel: displayLabel,
      type: type,
      mapId: data['mapId'] as String? ?? data['map_id'] as String? ?? '',
      isExit:
          data['isExit'] as bool? ??
          data['is_exit'] as bool? ??
          type.toLowerCase() == 'exit' ||
              label.contains('출구') ||
              displayLabel.toLowerCase().contains('exit'),
      uuid: data['uuid'] as String? ?? '',
      major: (data['major'] as num?)?.toInt() ?? 0,
      minor: (data['minor'] as num?)?.toInt() ?? 0,
      x: (data['x'] as num?)?.toDouble() ?? 0,
      y: (data['y'] as num?)?.toDouble() ?? 0,
      floorId: data['floorId'] as String? ?? 'default',
      txPower: (data['txPower'] as num?)?.toInt() ?? -59,
      onFire: (data['onFire'] as bool?) ?? (data['onfire'] as bool?) ?? false,
      fireDetectedAt: (data['fireDetectedAt'] as Timestamp?)?.toDate(),
    );
  }

  String get matchKey => '${uuid.toLowerCase()}:$major:$minor';

  static double rssiToDistance(int rssi, int txPower) {
    if (rssi == 0) return -1;
    final ratio = rssi / txPower;
    if (ratio < 1.0) {
      return math.pow(ratio, 10).toDouble();
    }
    return 0.89976 * math.pow(ratio, 7.7095) + 0.111;
  }
}

class DetectedBeacon {
  final String matchKey;
  final int rssi;
  final DateTime detectedAt;

  DetectedBeacon({
    required this.matchKey,
    required this.rssi,
    required this.detectedAt,
  });
}
