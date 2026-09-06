import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/beacon_data.dart';

class BeaconService {
  final _detectedController =
      StreamController<List<DetectedBeacon>>.broadcast();
  StreamSubscription<RangingResult>? _rangingSub;
  bool _initialized = false;

  Stream<List<DetectedBeacon>> get detectedStream => _detectedController.stream;

  Future<bool> requestPermissions() async {
    if (kIsWeb) return true;
    final results = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();
    return results.values.every((s) => s.isGranted || s.isLimited);
  }

  Future<void> initialize() async {
    if (_initialized) return;
    if (kIsWeb) {
      _initialized = true;
      return;
    }
    try {
      await flutterBeacon.initializeAndCheckScanning;
      _initialized = true;
    } catch (e) {
      throw Exception('비콘 초기화 실패: $e');
    }
  }

  Future<void> startScanning(List<String> uuids) async {
    if (!_initialized) await initialize();

    // User locations must only come from real BLE ranging on a device.
    if (kIsWeb) {
      return;
    }

    final regions = uuids
        .map((u) => Region(identifier: 'fieva_$u', proximityUUID: u))
        .toList();

    await _rangingSub?.cancel();
    _rangingSub = flutterBeacon
        .ranging(regions)
        .listen(
          (result) {
            try {
              final detected = <DetectedBeacon>[];
              for (final beacon in result.beacons) {
                final uuid = beacon.proximityUUID.trim().toLowerCase();
                if (uuid.isEmpty) continue;
                detected.add(
                  DetectedBeacon(
                    matchKey: '$uuid:${beacon.major}:${beacon.minor}',
                    rssi: beacon.rssi,
                    detectedAt: DateTime.now(),
                  ),
                );
              }
              if (!_detectedController.isClosed) {
                _detectedController.add(detected);
              }
            } catch (error, stackTrace) {
              debugPrint('Beacon ranging result ignored: $error\n$stackTrace');
            }
          },
          onError: (Object error, StackTrace stackTrace) {
            debugPrint('Beacon ranging stream error: $error\n$stackTrace');
          },
        );
  }

  Future<void> stopScanning() async {
    await _rangingSub?.cancel();
    _rangingSub = null;
  }

  Future<void> dispose() async {
    await stopScanning();
    await _detectedController.close();
  }
}
