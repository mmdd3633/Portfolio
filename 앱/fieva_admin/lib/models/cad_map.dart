import 'package:cloud_firestore/cloud_firestore.dart';

class CadMapBeacon {
  final String id;
  final String name;
  final String label;
  final String displayLabel;
  final String type;
  final bool isExit;
  final double x;
  final double y;

  CadMapBeacon({
    required this.id,
    required this.x,
    required this.y,
    String? name,
    this.label = '',
    this.displayLabel = '',
    this.type = 'normal',
    this.isExit = false,
  }) : name = name ?? id;

  String get displayName {
    if (displayLabel.trim().isNotEmpty) return displayLabel.trim();
    if (name.trim().isNotEmpty) return name.trim();
    return id;
  }

  CadMapBeacon copyWith({
    String? id,
    String? name,
    String? label,
    String? displayLabel,
    String? type,
    bool? isExit,
    double? x,
    double? y,
  }) {
    return CadMapBeacon(
      id: id ?? this.id,
      name: name ?? this.name,
      label: label ?? this.label,
      displayLabel: displayLabel ?? this.displayLabel,
      type: type ?? this.type,
      isExit: isExit ?? this.isExit,
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'label': label,
      'displayLabel': displayLabel,
      'type': type,
      'isExit': isExit,
      'x': x,
      'y': y,
    };
  }

  factory CadMapBeacon.fromMap(Map<String, dynamic> m) {
    String firstString(List<String> keys) {
      for (final key in keys) {
        final value = m[key];
        if (value is String && value.trim().isNotEmpty) return value.trim();
      }
      return '';
    }

    final id = firstString(const ['id', 'name', 'instance_id']);
    final name = firstString(const ['name', 'id', 'instance_id']);
    final label = firstString(const ['label']);
    final displayLabel = firstString(const ['displayLabel', 'display_label']);
    final type = firstString(const ['type']).toLowerCase();
    final isExit =
        (m['isExit'] as bool?) ??
        (m['is_exit'] as bool?) ??
        type == 'exit' ||
            label.contains('출구') ||
            displayLabel.toLowerCase().contains('exit');
    return CadMapBeacon(
      id: id,
      name: name,
      label: label,
      displayLabel: displayLabel,
      type: type.isEmpty ? 'normal' : type,
      isExit: isExit,
      x: (m['x'] as num?)?.toDouble() ?? 0,
      y: (m['y'] as num?)?.toDouble() ?? 0,
    );
  }
}

class CadMapBounds {
  final double minX;
  final double minY;
  final double maxX;
  final double maxY;

  CadMapBounds({
    required this.minX,
    required this.minY,
    required this.maxX,
    required this.maxY,
  });

  double get width => maxX - minX;
  double get height => maxY - minY;
  bool get isValid => width > 0 && height > 0;

  factory CadMapBounds.fromMap(Map<String, dynamic> m) {
    return CadMapBounds(
      minX:
          (m['minX'] as num?)?.toDouble() ??
          (m['min_x'] as num?)?.toDouble() ??
          0,
      minY:
          (m['minY'] as num?)?.toDouble() ??
          (m['min_y'] as num?)?.toDouble() ??
          0,
      maxX:
          (m['maxX'] as num?)?.toDouble() ??
          (m['max_x'] as num?)?.toDouble() ??
          0,
      maxY:
          (m['maxY'] as num?)?.toDouble() ??
          (m['max_y'] as num?)?.toDouble() ??
          0,
    );
  }
}

class CadMapImageInfo {
  final int width;
  final int height;
  final String coordinateSystem;
  final String origin;
  final int? sourceWidth;
  final int? sourceHeight;
  final double? sourceLeft;
  final double? sourceTop;
  final double? cropLeft;
  final double? cropTop;
  final double? cropRight;
  final double? cropBottom;

  CadMapImageInfo({
    required this.width,
    required this.height,
    this.coordinateSystem = 'cad',
    this.origin = 'bottom-left',
    this.sourceWidth,
    this.sourceHeight,
    this.sourceLeft,
    this.sourceTop,
    this.cropLeft,
    this.cropTop,
    this.cropRight,
    this.cropBottom,
  });

  bool get isValid => width > 0 && height > 0;

  bool get hasCrop =>
      cropLeft != null &&
      cropTop != null &&
      cropRight != null &&
      cropBottom != null &&
      cropRight! > cropLeft! &&
      cropBottom! > cropTop!;

  double get visibleLeft => hasCrop ? cropLeft! : 0;
  double get visibleTop => hasCrop ? cropTop! : 0;
  double get visibleRight => hasCrop ? cropRight! : width.toDouble();
  double get visibleBottom => hasCrop ? cropBottom! : height.toDouble();
  double get visibleWidth => visibleRight - visibleLeft;
  double get visibleHeight => visibleBottom - visibleTop;
  int get coordinateWidth => sourceWidth ?? width;
  int get coordinateHeight => sourceHeight ?? height;
  double get coordinateLeft => sourceLeft ?? 0;
  double get coordinateTop => sourceTop ?? 0;

  static double? _cropValue(Map<String, dynamic> m, String key) {
    final crop = m['crop'];
    if (crop is Map && crop[key] is num) {
      return (crop[key] as num).toDouble();
    }
    final contentRect = m['content_rect'];
    if (contentRect is Map && contentRect[key] is num) {
      return (contentRect[key] as num).toDouble();
    }
    return null;
  }

  static double? _sourceCropValue(Map<String, dynamic> m, String key) {
    final crop = m['source_crop'];
    if (crop is Map && crop[key] is num) {
      return (crop[key] as num).toDouble();
    }
    final flatKey = 'source_$key';
    return m[flatKey] is num ? (m[flatKey] as num).toDouble() : null;
  }

  factory CadMapImageInfo.fromMap(Map<String, dynamic> m) {
    final sourceLeft = _sourceCropValue(m, 'left');
    final sourceTop = _sourceCropValue(m, 'top');
    final sourceRight = _sourceCropValue(m, 'right');
    final sourceBottom = _sourceCropValue(m, 'bottom');
    final width = (m['width'] as num?)?.toInt() ?? 0;
    final height = (m['height'] as num?)?.toInt() ?? 0;
    final sourceCropWidth = sourceLeft != null && sourceRight != null
        ? sourceRight - sourceLeft
        : null;
    final sourceCropHeight = sourceTop != null && sourceBottom != null
        ? sourceBottom - sourceTop
        : null;
    final sourceCropMatchesImage =
        sourceCropWidth != null &&
        sourceCropHeight != null &&
        (width - sourceCropWidth).abs() <= 1 &&
        (height - sourceCropHeight).abs() <= 1;

    return CadMapImageInfo(
      width: width,
      height: height,
      coordinateSystem: m['coordinate_system'] as String? ?? 'cad',
      origin: m['origin'] as String? ?? 'bottom-left',
      sourceWidth: (m['source_width'] as num?)?.toInt(),
      sourceHeight: (m['source_height'] as num?)?.toInt(),
      sourceLeft: sourceCropMatchesImage ? sourceLeft : null,
      sourceTop: sourceCropMatchesImage ? sourceTop : null,
      cropLeft: _cropValue(m, 'left'),
      cropTop: _cropValue(m, 'top'),
      cropRight: _cropValue(m, 'right'),
      cropBottom: _cropValue(m, 'bottom'),
    );
  }
}

class CadMap {
  final String id;
  final String originalFile;
  final String imageUrl;
  final String imagePath;
  final int roomCount;
  final int exitCount;
  final List<CadMapBeacon> beacons;
  final CadMapBounds? bounds;
  final CadMapImageInfo? image;
  final DateTime? createdAt;
  final String validationStatus;

  CadMap({
    required this.id,
    required this.originalFile,
    required this.imageUrl,
    required this.imagePath,
    required this.roomCount,
    required this.exitCount,
    required this.beacons,
    this.bounds,
    this.image,
    this.createdAt,
    this.validationStatus = '',
  });

  factory CadMap.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final beaconList = (data['beacons'] as List? ?? [])
        .whereType<Map>()
        .map((b) => CadMapBeacon.fromMap(Map<String, dynamic>.from(b)))
        .toList();

    final coordinateSpace = data['coordinate_space'];
    final coordinateMap = coordinateSpace is Map
        ? Map<String, dynamic>.from(coordinateSpace)
        : const <String, dynamic>{};
    final rawBounds = data['bounds'] ?? coordinateMap['bounds'];
    final rawImage = data['image'];
    final rawCreatedAt = data['created_at'];
    final generatedAt = data['generated_at'];
    final storagePaths = data['storage_paths'];
    final storageMap = storagePaths is Map
        ? Map<String, dynamic>.from(storagePaths)
        : const <String, dynamic>{};
    final validation = data['validation'];
    final validationMap = validation is Map
        ? Map<String, dynamic>.from(validation)
        : const <String, dynamic>{};
    final mapAnalysis = data['map_analysis'];
    final analysisMap = mapAnalysis is Map
        ? Map<String, dynamic>.from(mapAnalysis)
        : const <String, dynamic>{};
    var imageInfo = rawImage is Map
        ? CadMapImageInfo.fromMap(Map<String, dynamic>.from(rawImage))
        : coordinateMap.isNotEmpty
        ? CadMapImageInfo.fromMap({
            'width': coordinateMap['image_width'],
            'height': coordinateMap['image_height'],
            'coordinate_system': 'cad',
            'origin': 'bottom-left',
          })
        : null;
    if (_needsTuk7fCropFallback(doc.id, data, imageInfo)) {
      imageInfo = CadMapImageInfo(
        width: imageInfo!.width,
        height: imageInfo.height,
        coordinateSystem: imageInfo.coordinateSystem,
        origin: imageInfo.origin,
        sourceWidth: imageInfo.sourceWidth,
        sourceHeight: imageInfo.sourceHeight,
        sourceLeft: imageInfo.sourceLeft,
        sourceTop: imageInfo.sourceTop,
        cropLeft: 455,
        cropTop: 420,
        cropRight: 3060,
        cropBottom: 2325,
      );
    }

    return CadMap(
      id: doc.id,
      originalFile:
          data['original_file'] as String? ??
          data['source_file'] as String? ??
          doc.id,
      imageUrl:
          data['image_url'] as String? ??
          storageMap['map.png'] as String? ??
          '',
      imagePath:
          data['image_path'] as String? ??
          storageMap['map.png'] as String? ??
          '',
      roomCount:
          (data['room_count'] as num?)?.toInt() ??
          (analysisMap['room_count'] as num?)?.toInt() ??
          0,
      exitCount:
          (data['exit_count'] as num?)?.toInt() ??
          (analysisMap['exit_count'] as num?)?.toInt() ??
          0,
      beacons: beaconList,
      bounds: rawBounds is Map
          ? CadMapBounds.fromMap(Map<String, dynamic>.from(rawBounds))
          : null,
      image: imageInfo,
      createdAt: rawCreatedAt is Timestamp
          ? rawCreatedAt.toDate()
          : rawCreatedAt is String
          ? DateTime.tryParse(rawCreatedAt)
          : generatedAt is String
          ? DateTime.tryParse(generatedAt)
          : null,
      validationStatus: validationMap['status'] as String? ?? '',
    );
  }

  CadMap copyWith({List<CadMapBeacon>? beacons}) {
    return CadMap(
      id: id,
      originalFile: originalFile,
      imageUrl: imageUrl,
      imagePath: imagePath,
      roomCount: roomCount,
      exitCount: beacons?.where((beacon) => beacon.isExit).length ?? exitCount,
      beacons: beacons ?? this.beacons,
      bounds: bounds,
      image: image,
      createdAt: createdAt,
      validationStatus: validationStatus,
    );
  }

  bool get isFinalMap =>
      validationStatus.toLowerCase() == 'valid' ||
      storagePath.toLowerCase().contains('map_results/');

  static bool _needsTuk7fCropFallback(
    String docId,
    Map<String, dynamic> data,
    CadMapImageInfo? image,
  ) {
    if (image == null || image.hasCrop) return false;
    final name = '$docId ${data['original_file'] ?? ''}'.toLowerCase();
    return name.contains('tuk_7f') &&
        image.width == 3547 &&
        image.height == 2616;
  }

  bool get hasCoordinateMetadata =>
      bounds != null && bounds!.isValid && image != null && image!.isValid;

  String get storagePath {
    if (imagePath.isNotEmpty) return imagePath;
    if (imageUrl.startsWith('gs://')) {
      final withoutScheme = imageUrl.substring(5);
      final slashIdx = withoutScheme.indexOf('/');
      if (slashIdx >= 0) return withoutScheme.substring(slashIdx + 1);
    }
    return imageUrl;
  }
}

class FireSystemStatus {
  final bool isFire;
  final String location;
  final String description;
  final String? lastIncidentTime;

  FireSystemStatus({
    required this.isFire,
    required this.location,
    required this.description,
    this.lastIncidentTime,
  });

  factory FireSystemStatus.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return FireSystemStatus(
      isFire: data['is_fire'] as bool? ?? false,
      location: data['location'] as String? ?? '',
      description: data['description'] as String? ?? '',
      lastIncidentTime: data['last_incident_time'] as String?,
    );
  }
}

class UserLiveLocation {
  final String? userId;
  final double x;
  final double y;
  final DateTime? lastUpdated;
  final String status;
  final String? mapId;
  final String? floorId;
  final String? beaconId;

  UserLiveLocation({
    this.userId,
    required this.x,
    required this.y,
    this.lastUpdated,
    this.status = 'active',
    this.mapId,
    this.floorId,
    this.beaconId,
  });

  static String? _stringField(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return null;
  }

  factory UserLiveLocation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserLiveLocation(
      userId: _stringField(data, const ['user_id', 'userId']) ?? doc.id,
      x: (data['x'] as num?)?.toDouble() ?? 0,
      y: (data['y'] as num?)?.toDouble() ?? 0,
      lastUpdated: (data['last_updated'] as Timestamp?)?.toDate(),
      status: data['status'] as String? ?? 'active',
      mapId: _stringField(data, const ['map_id', 'mapId', 'cad_map_id']),
      floorId: _stringField(data, const ['floor_id', 'floorId']),
      beaconId: _stringField(data, const ['beacon_id', 'beaconId']),
    );
  }
}
