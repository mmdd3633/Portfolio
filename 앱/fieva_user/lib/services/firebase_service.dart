import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:path_provider/path_provider.dart';
import '../models/beacon_data.dart';
import '../models/route_node.dart';

class FirebaseService {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  FirebaseStorage get _storage => FirebaseStorage.instance;
  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  Stream<List<BeaconData>> watchBeacons(String mapId) {
    return _firestore.collection('beacons').snapshots().map((s) {
      return s.docs
          .map(BeaconData.fromFirestore)
          .where((beacon) => beacon.mapId == mapId || beacon.floorId == mapId)
          .toList();
    });
  }

  Stream<List<BeaconData>> watchFireBeacons() {
    return _firestore.collection('beacons').snapshots().map((s) {
      return s.docs
          .map(BeaconData.fromFirestore)
          .where((beacon) => beacon.onFire)
          .toList();
    });
  }

  Future<Map<String, RouteNode>> loadRouteGraph(String floorId) async {
    final snap = await _firestore
        .collection('routeNodes')
        .where('floorId', isEqualTo: floorId)
        .get();
    return {for (final doc in snap.docs) doc.id: RouteNode.fromFirestore(doc)};
  }

  Future<String> downloadDxf(String storagePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final filename = storagePath.split('/').last;
    final localFile = File('${dir.path}/$filename');
    if (await localFile.exists()) {
      return localFile.readAsString();
    }
    final bytes = await _storage.ref(storagePath).getData(20 * 1024 * 1024);
    if (bytes == null) throw Exception('DXF 다운로드 실패: $storagePath');
    await localFile.writeAsBytes(bytes);
    return localFile.readAsString();
  }

  Future<List<FloorMeta>> listFloors() async {
    final snap = await _firestore.collection('floors').get();
    return snap.docs.map((d) {
      final data = d.data();
      return FloorMeta(
        floorId: d.id,
        name: data['name'] as String? ?? d.id,
        dxfPath: data['dxfPath'] as String? ?? '',
        scale: (data['scale'] as num?)?.toDouble() ?? 1.0,
      );
    }).toList();
  }

  Future<String?> setupMessaging() async {
    await _messaging.requestPermission();
    final token = await _messaging.getToken();
    await _messaging.subscribeToTopic('fire_alerts');
    return token;
  }

  Stream<RemoteMessage> get foregroundMessages => FirebaseMessaging.onMessage;
}

class FloorMeta {
  final String floorId;
  final String name;
  final String dxfPath;
  final double scale;

  FloorMeta({
    required this.floorId,
    required this.name,
    required this.dxfPath,
    required this.scale,
  });
}
