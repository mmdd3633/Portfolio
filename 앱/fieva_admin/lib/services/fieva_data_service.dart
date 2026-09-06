import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/admin_test_status.dart';
import '../models/beacon_data.dart';
import '../models/cad_map.dart';

class FievaDataService {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  FirebaseStorage get _storage => FirebaseStorage.instance;

  Future<List<CadMap>> listCadMaps() async {
    final mapSnap = await _firestore.collection('cad_maps').get();
    final beaconSnap = await _firestore.collection('beacons').get();
    final beaconMetadata = beaconSnap.docs
        .map(BeaconData.fromFirestore)
        .toList();
    final maps = mapSnap.docs
        .map(CadMap.fromFirestore)
        .map((map) => _enrichMap(map, beaconMetadata))
        .toList();
    maps.sort((a, b) {
      final finalCompare = (b.isFinalMap ? 1 : 0).compareTo(
        a.isFinalMap ? 1 : 0,
      );
      if (finalCompare != 0) return finalCompare;
      final dateCompare =
          (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)).compareTo(
            a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
          );
      if (dateCompare != 0) return dateCompare;
      return b.beacons.length.compareTo(a.beacons.length);
    });
    return maps;
  }

  Stream<CadMap?> watchCadMap(String mapId) {
    return _firestore.collection('cad_maps').doc(mapId).snapshots().asyncMap((
      doc,
    ) async {
      if (!doc.exists) return null;
      final beaconSnap = await _firestore.collection('beacons').get();
      return _enrichMap(
        CadMap.fromFirestore(doc),
        beaconSnap.docs.map(BeaconData.fromFirestore).toList(),
      );
    });
  }

  CadMap _enrichMap(CadMap map, List<BeaconData> metadata) {
    final relevant = metadata
        .where(
          (beacon) =>
              beacon.mapId == map.id ||
              (beacon.mapId.isEmpty && beacon.floorId == map.id),
        )
        .toList();
    if (relevant.isEmpty) return map;

    final byName = <String, BeaconData>{};
    for (final beacon in relevant) {
      byName[beacon.id.toLowerCase()] = beacon;
      byName[beacon.name.toLowerCase()] = beacon;
    }

    final merged = <CadMapBeacon>[];
    for (final beacon in map.beacons) {
      final meta =
          byName[beacon.id.toLowerCase()] ?? byName[beacon.name.toLowerCase()];
      if (meta == null) {
        merged.add(beacon);
        continue;
      }
      merged.add(
        beacon.copyWith(
          id: meta.name,
          name: meta.name,
          label: meta.label,
          displayLabel: meta.displayLabel,
          type: meta.type,
          isExit: meta.isExit,
          x: meta.x,
          y: meta.y,
        ),
      );
    }

    final existing = merged.map((beacon) => beacon.id.toLowerCase()).toSet();
    for (final meta in relevant) {
      if (existing.contains(meta.name.toLowerCase())) continue;
      merged.add(
        CadMapBeacon(
          id: meta.name,
          name: meta.name,
          label: meta.label,
          displayLabel: meta.displayLabel,
          type: meta.type,
          isExit: meta.isExit,
          x: meta.x,
          y: meta.y,
        ),
      );
    }
    return map.copyWith(beacons: merged);
  }

  Future<void> updateCadMapBeacons(String mapId, List<CadMapBeacon> beacons) {
    return _firestore.collection('cad_maps').doc(mapId).set({
      'beacons': beacons.map((beacon) => beacon.toMap()).toList(),
      'beacon_count': beacons.length,
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<Uint8List> downloadImageBytes(String imageUrlOrPath) async {
    final ref = _refFor(imageUrlOrPath);
    final bytes = await ref.getData(20 * 1024 * 1024);
    if (bytes == null) {
      throw Exception('Converted CAD image download failed: $imageUrlOrPath');
    }
    return bytes;
  }

  Future<String> getImageHttpUrl(String imageUrlOrPath) async {
    final value = imageUrlOrPath.trim();
    if (value.isEmpty) {
      throw Exception('Converted CAD image path is empty.');
    }
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }
    return _refFor(value).getDownloadURL();
  }

  Future<String> getCadMapImageHttpUrl(CadMap map) {
    final source = map.imageUrl.trim().isNotEmpty
        ? map.imageUrl
        : map.imagePath;
    return getImageHttpUrl(source);
  }

  Reference _refFor(String imageUrlOrPath) {
    final value = imageUrlOrPath.trim();
    if (value.isEmpty) {
      throw Exception('Converted CAD image path is empty.');
    }
    if (value.startsWith('gs://')) {
      final withoutScheme = value.substring(5);
      final slashIdx = withoutScheme.indexOf('/');
      if (slashIdx < 0 || slashIdx == withoutScheme.length - 1) {
        throw Exception('Invalid Firebase Storage URL: $value');
      }
      return _storage.ref(withoutScheme.substring(slashIdx + 1));
    }
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return _storage.refFromURL(value);
    }
    return _storage.ref(value);
  }

  Stream<FireSystemStatus> watchFireStatus() {
    return _firestore
        .collection('status')
        .doc('fire_system')
        .snapshots()
        .map(FireSystemStatus.fromFirestore);
  }

  Stream<UserLiveLocation?> watchUserLocation({
    String userId = 'unknown_user',
  }) {
    return _firestore
        .collection('user_location')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? UserLiveLocation.fromFirestore(doc) : null);
  }

  Stream<List<UserLiveLocation>> watchUserLocations({Set<String>? userIds}) {
    final allowed = userIds
        ?.map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet();
    return _firestore.collection('user_location').snapshots().map((snap) {
      final locations = snap.docs
          .where((doc) => allowed == null || allowed.contains(doc.id))
          .map(UserLiveLocation.fromFirestore)
          .where((location) => location.status != 'inactive')
          .toList();
      locations.sort((a, b) => (a.userId ?? '').compareTo(b.userId ?? ''));
      return locations;
    });
  }

  Stream<AdminTestStatus> watchAdminTestStatus() {
    return _firestore
        .collection('admin')
        .doc('test')
        .snapshots()
        .map(
          (doc) => AdminTestStatus.fromMap(
            doc.data() as Map<String, dynamic>? ?? {},
          ),
        );
  }

  Future<AdminTestStatus> fetchAdminTestStatus() async {
    final doc = await _firestore
        .collection('admin')
        .doc('test')
        .get(const GetOptions(source: Source.server));
    return AdminTestStatus.fromMap(doc.data() ?? {});
  }

  Future<void> updateAdminTest({String? selectedBeaconId, bool? testActive}) {
    final data = <String, dynamic>{'updatedAt': FieldValue.serverTimestamp()};
    if (selectedBeaconId != null) {
      data['selectedBeaconId'] = selectedBeaconId.trim();
    }
    if (testActive != null) {
      data['testActive'] = testActive;
    }
    return _firestore
        .collection('admin')
        .doc('test')
        .set(data, SetOptions(merge: true));
  }

  Future<void> updateUserLocation(
    double x,
    double y, {
    String userId = 'unknown_user',
    String? mapId,
    String? floorId,
    String? beaconId,
    bool clearBeaconId = false,
  }) {
    final normalizedUserId = userId.trim().isEmpty
        ? 'unknown_user'
        : userId.trim();
    final data = <String, dynamic>{
      'user_id': normalizedUserId,
      'x': x,
      'y': y,
      'last_updated': FieldValue.serverTimestamp(),
      'status': 'active',
    };
    if (mapId != null && mapId.trim().isNotEmpty) {
      data['map_id'] = mapId.trim();
    }
    if (floorId != null && floorId.trim().isNotEmpty) {
      data['floor_id'] = floorId.trim();
    }
    if (beaconId != null && beaconId.trim().isNotEmpty) {
      data['beacon_id'] = beaconId.trim();
    } else if (clearBeaconId) {
      data['beacon_id'] = FieldValue.delete();
    }
    return _firestore
        .collection('user_location')
        .doc(normalizedUserId)
        .set(data, SetOptions(merge: true));
  }

  Future<void> setFire(bool isFire, {String location = 'FIRE_705'}) {
    return _firestore.collection('status').doc('fire_system').set({
      'is_fire': isFire,
      'location': isFire ? location : '',
      'description': isFire
          ? '$location fire signal received.'
          : 'Fire status cleared.',
      'last_incident_time': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }
}
