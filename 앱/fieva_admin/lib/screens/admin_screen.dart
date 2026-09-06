import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../models/admin_test_status.dart';
import '../models/beacon_data.dart';
import '../models/cad_map.dart';
import '../services/admin_evacuation_test_flow.dart';
import '../services/beacon_service.dart';
import '../services/beacon_reading_matcher.dart';
import '../services/evacuation_route_service.dart';
import '../services/firebase_service.dart';
import '../services/fieva_data_service.dart';
import '../services/hardware_button_service.dart';
import '../services/location_estimator.dart';
import '../services/pdr_motion_service.dart';
import '../services/user_location_display_selection.dart';
import '../widgets/cad_map_view.dart';

enum _BeaconListFilter { all, live, fire, waiting }

class _BeaconReading {
  final String id;
  final String displayName;
  final String matchKey;
  final int rssi;
  final DateTime detectedAt;

  const _BeaconReading({
    required this.id,
    required this.displayName,
    required this.matchKey,
    required this.rssi,
    required this.detectedAt,
  });
}

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  static const _liveSignalWindow = Duration(seconds: 8);

  final _data = FievaDataService();
  final _firebase = FirebaseService();
  final _beacons = BeaconService();
  final _hardwareButtons = HardwareButtonService();
  final _estimator = LocationEstimator();
  final _pdr = PdrMotionService();
  final _routes = EvacuationRouteService();
  final _mapController = CadMapController();
  final _trackingMapController = CadMapController();
  final _bodyScrollController = ScrollController();

  List<CadMap> _maps = [];
  CadMap? _selected;
  FireSystemStatus? _fire;
  UserLiveLocation? _liveUserLoc;
  List<UserLiveLocation> _remoteUserLocs = [];
  AdminTestStatus _adminTest = const AdminTestStatus();
  EvacuationRouteResult? _lastRouteResult;

  String? _mapImageUrl;
  String? _mapImageMapId;
  String? _fireBeaconId;
  String _log = '화재 감지 점검 앱 준비 완료';
  String _scanStatus = 'BLE 스캔 준비 중';
  bool _modeSelected = false;
  bool _busy = false;
  bool _mapExpanded = false;
  bool _fireTrackingView = false;
  bool _isBrowsingMap = false;
  bool _isBrowsingTrackingMap = false;
  bool _testActive = false;
  bool _endPromptOpen = false;
  bool _pendingEvacuationTest = false;
  bool _locationWaitPromptOpen = false;
  bool _beaconListExpanded = false;
  bool _userVisibilityExpanded = false;
  bool _foregroundFireMessageActive = false;
  _BeaconListFilter _beaconFilter = _BeaconListFilter.all;
  StreamSubscription<List<BeaconData>>? _knownBeaconSub;
  StreamSubscription<List<DetectedBeacon>>? _detectedBeaconSub;
  StreamSubscription<List<BeaconData>>? _fireBeaconSub;
  StreamSubscription<AdminTestStatus>? _adminTestSub;
  StreamSubscription<List<UserLiveLocation>>? _remoteUserLocationSub;
  StreamSubscription<PdrMotionSnapshot>? _motionSub;
  StreamSubscription<RemoteMessage>? _foregroundMessageSub;
  StreamSubscription<RemoteMessage>? _messageOpenedSub;
  Timer? _locationWaitReminderTimer;
  BuildContext? _locationWaitDialogContext;
  Map<String, BeaconData> _knownBeacons = {};
  List<_BeaconReading> _bleReadings = [];
  final Map<String, _BeaconReading> _latestReadingByKey = {};
  final Map<String, List<int>> _rssiHistory = {};
  final Set<String> _hiddenRemoteUserIds = {};
  Set<String> _firebaseFireIds = {};
  Set<String>? _lastFirebaseFireIds;
  String _activeScanUuids = '';

  @override
  void initState() {
    super.initState();
    _detectedBeaconSub = _beacons.detectedStream.listen(
      _onDetectedBeacons,
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('Admin beacon stream error: $error\n$stackTrace');
        _setScanStatus('BLE 스캔 오류: $error');
      },
    );
    _motionSub = _pdr.motionStream.listen(_estimator.updateMotion);
    unawaited(_pdr.start());
    _startMessaging();
    _startRemoteUserLocationWatch();
    _startFirebaseFireWatch();
    _startAdminTestWatch();
    _load();
  }

  void _startMessaging() {
    unawaited(
      _firebase
          .setupMessaging()
          .then((_) {
            _addLog('Firebase 화재 알림 수신 준비 완료');
          })
          .catchError((Object error) {
            debugPrint('Admin messaging setup failed: $error');
            _addLog('Firebase 화재 알림 준비 실패: $error');
          }),
    );
    try {
      _foregroundMessageSub = _firebase.foregroundMessages.listen(
        _onForegroundFireMessage,
        onError: (Object error, StackTrace stackTrace) {
          debugPrint('Admin foreground message error: $error\n$stackTrace');
        },
      );
      _messageOpenedSub = FirebaseMessaging.onMessageOpenedApp.listen(
        _openFireTrackingFromMessage,
      );
      unawaited(
        FirebaseMessaging.instance
            .getInitialMessage()
            .then((message) {
              if (message != null) _openFireTrackingFromMessage(message);
            })
            .catchError((Object error) {
              debugPrint('Admin initial message read failed: $error');
              _addLog('초기 화재 알림 확인 대기: $error');
            }),
      );
    } catch (error) {
      debugPrint('Admin messaging listener failed: $error');
      _addLog('Firebase 화재 알림 연결 대기: $error');
    }
  }

  void _startRemoteUserLocationWatch() {
    try {
      _remoteUserLocationSub = _data.watchUserLocations().listen(
        (locations) {
          if (!mounted) {
            _remoteUserLocs = locations;
            return;
          }
          setState(() => _remoteUserLocs = locations);
        },
        onError: (Object error, StackTrace stackTrace) {
          debugPrint(
            'Admin remote user location watch error: $error\n$stackTrace',
          );
          _addLog('사용자 위치 감시 실패: $error');
        },
      );
    } catch (error) {
      debugPrint('Admin remote user location watch failed: $error');
      _addLog('사용자 위치 감시 대기: $error');
    }
  }

  void _startFirebaseFireWatch() {
    try {
      _fireBeaconSub = _firebase.watchFireBeacons().listen(
        _onFirebaseFireBeacons,
        onError: (Object error, StackTrace stackTrace) {
          debugPrint('Admin fire beacon watch error: $error\n$stackTrace');
          _addLog('Firebase onFire 감시 실패: $error');
        },
      );
    } catch (error) {
      debugPrint('Admin fire beacon watch unavailable: $error');
      _addLog('Firebase onFire 감시 대기: $error');
    }
  }

  void _startAdminTestWatch() {
    try {
      _adminTestSub = _data.watchAdminTestStatus().listen(
        (status) {
          if (!mounted) {
            _adminTest = status;
            return;
          }
          setState(() {
            _adminTest = status;
            _syncLocalAdminTestState(status);
          });
        },
        onError: (Object error, StackTrace stackTrace) {
          debugPrint('Admin test watch error: $error\n$stackTrace');
          _addLog('관리자 테스트 상태 감시 실패: $error');
        },
      );
    } catch (error) {
      debugPrint('Admin test watch unavailable: $error');
      _addLog('관리자 테스트 상태 감시 대기: $error');
    }
  }

  Future<void> _load({String? keepMapId}) async {
    try {
      final maps = await _data.listCadMaps();
      maps.sort((a, b) => b.beacons.length.compareTo(a.beacons.length));
      if (!mounted) return;
      final selected = _selectMapFrom(maps, keepMapId ?? _selected?.id);
      setState(() {
        _maps = maps;
        _selected = selected;
        _syncBeaconSelections();
        _resetLocalSimulation();
        _syncLocalAdminTestState(_adminTest);
      });
      await _loadMapImage(selected);
      await _startBeaconMonitor(selected);
    } catch (error) {
      _addLog('지도 로드 실패: $error');
    }
  }

  Future<void> _loadMapImage(CadMap? map) async {
    if (map == null) {
      if (mounted) {
        setState(() {
          _mapImageUrl = '';
          _mapImageMapId = null;
        });
      }
      return;
    }

    setState(() {
      _mapImageUrl = null;
      _mapImageMapId = map.id;
    });

    try {
      final url = await _data.getCadMapImageHttpUrl(map);
      if (!mounted || _selected?.id != map.id) return;
      setState(() => _mapImageUrl = url);
    } catch (error) {
      if (!mounted || _selected?.id != map.id) return;
      setState(() => _mapImageUrl = '');
      _addLog('지도 이미지 로드 실패: $error');
    }
  }

  CadMap? _selectMapFrom(List<CadMap> maps, String? id) {
    if (maps.isEmpty) return null;
    if (id != null) {
      for (final map in maps) {
        if (map.id == id) return map;
      }
    }
    for (final map in maps) {
      if (map.isFinalMap && map.beacons.isNotEmpty) return map;
    }
    for (final map in maps) {
      final name = '${map.id} ${map.originalFile}'.toLowerCase();
      if (name.contains('tuk_7f') && map.beacons.isNotEmpty) return map;
    }
    return maps.first;
  }

  @override
  void dispose() {
    _knownBeaconSub?.cancel();
    _detectedBeaconSub?.cancel();
    _fireBeaconSub?.cancel();
    _adminTestSub?.cancel();
    _remoteUserLocationSub?.cancel();
    _motionSub?.cancel();
    _foregroundMessageSub?.cancel();
    _messageOpenedSub?.cancel();
    _locationWaitReminderTimer?.cancel();
    unawaited(_beacons.dispose());
    unawaited(_pdr.dispose());
    unawaited(_hardwareButtons.dispose());
    _mapController.dispose();
    _trackingMapController.dispose();
    _bodyScrollController.dispose();
    super.dispose();
  }

  void _syncBeaconSelections() {
    final beacons = _selected?.beacons ?? [];
    if (beacons.isEmpty) {
      _fireBeaconId = null;
      return;
    }

    if (_adminTest.selectedBeaconId.isNotEmpty &&
        _hasBeacon(_adminTest.selectedBeaconId)) {
      _fireBeaconId = _adminTest.selectedBeaconId;
    }
    if (!_hasBeacon(_fireBeaconId)) {
      _fireBeaconId =
          _firstMatchingBeacon((beacon) => !beacon.isExit)?.id ??
          beacons.last.id;
    }
  }

  void _syncLocalAdminTestState(AdminTestStatus status) {
    final selectedBeacon = _beaconById(status.selectedBeaconId);
    _testActive = status.testActive;
    if (selectedBeacon != null) {
      _fireBeaconId = selectedBeacon.id;
      _fire = FireSystemStatus(
        isFire: true,
        location: selectedBeacon.id,
        description: '관리자 화재 감지 점검',
      );
      _updateRoutePreview(fireBeacon: selectedBeacon);
      return;
    }
    if (status.selectedBeaconId.isEmpty && !status.testActive) {
      _fire = null;
      _lastRouteResult = null;
    }
  }

  CadMapBeacon? _firstMatchingBeacon(bool Function(CadMapBeacon) matches) {
    for (final beacon in _selected?.beacons ?? const <CadMapBeacon>[]) {
      if (matches(beacon)) return beacon;
    }
    return null;
  }

  bool _hasBeacon(String? id) {
    if (id == null) return false;
    return _selected?.beacons.any((beacon) => beacon.id == id) ?? false;
  }

  CadMapBeacon? _beaconById(String? id) {
    if (id == null) return null;
    for (final beacon in _selected?.beacons ?? const <CadMapBeacon>[]) {
      if (beacon.id == id) return beacon;
    }
    return null;
  }

  CadMapBeacon? _activeFireBeacon() {
    if (_fire?.isFire != true) return null;
    return _beaconById(_fire?.location);
  }

  void _resetLocalSimulation() {
    _fire = null;
    _lastRouteResult = null;
  }

  Future<void> _run(String failureLabel, Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } catch (error) {
      _addLog('$failureLabel 실패: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _addLog(String message) {
    _addLogAt(DateTime.now(), message);
  }

  void _addLogAt(DateTime time, String message) {
    if (!mounted) return;
    final stamp = time.toString().substring(11, 19);
    setState(() {
      _log = '[$stamp] $message\n$_log';
      if (_log.length > 2200) _log = _log.substring(0, 2200);
    });
  }

  void _setScanStatus(String status) {
    if (!mounted) return;
    setState(() => _scanStatus = status);
  }

  Future<void> _startBeaconMonitor(CadMap? map) async {
    await _knownBeaconSub?.cancel();
    _knownBeaconSub = null;
    _activeScanUuids = '';
    _knownBeacons = {};
    _latestReadingByKey.clear();
    _rssiHistory.clear();
    _estimator.reset();
    if (mounted) {
      setState(() {
        _bleReadings = [];
        _liveUserLoc = null;
        _scanStatus = map == null ? '선택된 지도가 없습니다.' : 'BLE 비콘 정보 로드 중';
      });
    }
    if (map == null) return;

    _knownBeaconSub = _firebase
        .watchBeacons(map.id)
        .listen(
          (beacons) async {
            final known = {
              for (final beacon in beacons)
                beacon.matchKey.toLowerCase(): beacon,
            };
            final uuids = beacons
                .map((beacon) => beacon.uuid.toLowerCase())
                .where((uuid) => uuid.isNotEmpty)
                .toSet()
                .toList();
            final nextScanUuids = uuids.join('|');

            if (!mounted) return;
            setState(() {
              _knownBeacons = known;
              _scanStatus = uuids.isEmpty
                  ? '스캔할 BLE UUID가 없습니다.'
                  : 'BLE UUID ${uuids.length}개 준비 완료';
            });
            if (uuids.isEmpty || nextScanUuids == _activeScanUuids) return;

            final granted = await _beacons.requestPermissions();
            if (!mounted) return;
            if (!granted) {
              _setScanStatus('BLE/위치 권한이 없어 스캔할 수 없습니다.');
              _addLog('BLE/위치 권한 확인 필요');
              return;
            }

            try {
              await _beacons.startScanning(uuids);
              _activeScanUuids = nextScanUuids;
              _setScanStatus('BLE 스캔 중: ${uuids.length}개 UUID');
              _addLog('BLE 스캔 시작: ${uuids.length}개 UUID');
            } catch (error) {
              _setScanStatus('BLE 스캔 시작 실패: $error');
              _addLog('BLE 스캔 시작 실패: $error');
            }
          },
          onError: (Object error, StackTrace stackTrace) {
            debugPrint('Admin known beacon watch error: $error\n$stackTrace');
            _setScanStatus('BLE 비콘 정보 로드 실패: $error');
          },
        );
  }

  void _onDetectedBeacons(List<DetectedBeacon> detected) {
    final now = DateTime.now();

    for (final item in detected) {
      final matchKey = item.matchKey.toLowerCase();
      final meta = _knownBeacons[matchKey];
      final displayName = meta?.displayName ?? item.matchKey;
      final id = meta?.id ?? displayName;
      final reading = _BeaconReading(
        id: id,
        displayName: displayName,
        matchKey: matchKey,
        rssi: item.rssi,
        detectedAt: item.detectedAt,
      );
      _latestReadingByKey[matchKey] = reading;
      final history = _rssiHistory.putIfAbsent(matchKey, () => <int>[]);
      history.add(item.rssi);
      if (history.length > 36) history.removeAt(0);
    }

    _latestReadingByKey.removeWhere(
      (_, reading) => now.difference(reading.detectedAt).inSeconds > 90,
    );
    final readings = _latestReadingByKey.values.toList();
    readings.sort((a, b) => b.rssi.compareTo(a.rssi));
    final estimatedUser = _estimateLiveLocation(detected);
    final user = estimatedUser ?? _liveLocationForSelectedMap();
    final fireBeacon = _activeFireBeacon();
    final routeResult = user == null || fireBeacon == null
        ? null
        : _routes.evaluate(map: _selected, user: user, fireBeacon: fireBeacon);
    if (!mounted) return;
    setState(() {
      _bleReadings = readings.take(12).toList();
      if (estimatedUser != null) {
        _liveUserLoc = estimatedUser;
      }
      if (routeResult != null) {
        _lastRouteResult = routeResult;
      }
      final liveCount = readings
          .where((reading) => _isReadingLive(reading, now: now))
          .length;
      _scanStatus = readings.isEmpty
          ? 'BLE 신호 대기 중'
          : 'BLE 최근 ${readings.length}개 / 수신 중 $liveCount개 · ${now.toString().substring(11, 19)}';
    });
    if (_pendingEvacuationTest && user != null && !_busy) {
      _completePendingEvacuationTest(user);
    }
  }

  void _onFirebaseFireBeacons(List<BeaconData> fireBeacons) {
    final ids = fireBeacons.map((beacon) => beacon.id).toSet();
    final previous = _lastFirebaseFireIds;
    _lastFirebaseFireIds = ids;
    if (mounted) {
      setState(() {
        _firebaseFireIds = ids;
        _foregroundFireMessageActive = ids.isNotEmpty;
      });
    } else {
      _firebaseFireIds = ids;
      _foregroundFireMessageActive = ids.isNotEmpty;
    }
    if (previous == null) {
      if (ids.isNotEmpty) {
        _addLog('Firebase onFire 감지 중: ${ids.join(', ')}');
      }
      return;
    }

    for (final id in ids.difference(previous)) {
      _addLog('Firebase onFire 변경: $id onFire=true');
    }
    for (final id in previous.difference(ids)) {
      _addLog('Firebase onFire 변경: $id onFire=false');
    }
  }

  void _onForegroundFireMessage(RemoteMessage message) {
    if (!mounted) return;
    final notification = message.notification;
    final title = notification?.title ?? '화재 경보';
    final body = notification?.body ?? '화재가 감지되었습니다. 사용자 위치를 확인하세요.';
    _addLog('FCM 화재 알림 수신: $title - $body');
    setState(() => _foregroundFireMessageActive = true);
  }

  void _openFireTrackingFromMessage(RemoteMessage message) {
    _addLog('FCM 화재 알림 열기');
    _showFireTrackingView();
  }

  String _normalizeKey(String value) => value.trim().toLowerCase();

  Set<String> _cadBeaconKeys(CadMapBeacon beacon) {
    return {
      beacon.id,
      beacon.name,
      beacon.label,
      beacon.displayLabel,
      beacon.displayName,
    }.map(_normalizeKey).where((value) => value.isNotEmpty).toSet();
  }

  bool _hasSharedKey(Set<String> a, Set<String> b) {
    for (final key in a) {
      if (b.contains(key)) return true;
    }
    return false;
  }

  BeaconData? _metadataForBeacon(CadMapBeacon beacon) {
    return BeaconReadingMatcher.metadataForCadBeacon(
      beacon,
      _knownBeacons.values,
    );
  }

  _BeaconReading? _readingForBeacon(CadMapBeacon beacon) {
    final matchKey = BeaconReadingMatcher.matchKeyForCadBeacon(
      beacon,
      _knownBeacons.values,
    );
    return matchKey == null ? null : _latestReadingByKey[matchKey];
  }

  bool _isReadingLive(_BeaconReading? reading, {DateTime? now}) {
    if (reading == null) return false;
    final base = now ?? DateTime.now();
    return base.difference(reading.detectedAt) <= _liveSignalWindow;
  }

  bool _isBeaconOnFire(CadMapBeacon beacon) {
    final keys = _cadBeaconKeys(beacon);
    final meta = _metadataForBeacon(beacon);
    if (meta?.onFire == true) return true;
    if (meta != null && _firebaseFireIds.contains(meta.id)) return true;
    final fireKeys = _firebaseFireIds.map(_normalizeKey).toSet();
    return _hasSharedKey(keys, fireKeys);
  }

  List<_BeaconReading> _liveReadings() {
    final now = DateTime.now();
    return _latestReadingByKey.values
        .where((reading) => _isReadingLive(reading, now: now))
        .toList()
      ..sort((a, b) => b.rssi.compareTo(a.rssi));
  }

  _BeaconReading? _strongestLiveReading() {
    final readings = _liveReadings();
    return readings.isEmpty ? null : readings.first;
  }

  BeaconData? _strongestKnownBeacon(List<DetectedBeacon> detected) {
    BeaconData? best;
    var bestRssi = -1000;
    for (final item in detected) {
      final beacon = _knownBeacons[item.matchKey.toLowerCase()];
      if (beacon == null) continue;
      if (item.rssi > bestRssi) {
        bestRssi = item.rssi;
        best = beacon;
      }
    }
    return best;
  }

  UserLiveLocation? _estimateLiveLocation(List<DetectedBeacon> detected) {
    final map = _selected;
    if (map == null || _knownBeacons.isEmpty) return null;
    final position = _estimator.estimate(detected, _knownBeacons);
    final strongest = _strongestKnownBeacon(detected);
    if (position == null || strongest == null) return null;
    return UserLiveLocation(
      x: position.x,
      y: position.y,
      mapId: map.id,
      floorId: position.floorId,
      beaconId: strongest.id,
    );
  }

  CadMapBeacon? _cadBeaconForMetadata(BeaconData meta) {
    return BeaconReadingMatcher.cadBeaconForMetadata(
      meta,
      _selected?.beacons ?? const <CadMapBeacon>[],
    );
  }

  CadMapBeacon? _cadBeaconForReading(_BeaconReading? reading) {
    if (reading == null) return null;
    return BeaconReadingMatcher.cadBeaconForMatchKey(
      reading.matchKey,
      _knownBeacons.values,
      _selected?.beacons ?? const <CadMapBeacon>[],
    );
  }

  UserLiveLocation? _liveLocationForSelectedMap() {
    final map = _selected;
    final live = _liveUserLoc;
    if (map != null && live != null) {
      final sameMap =
          live.mapId == null || live.mapId!.isEmpty || live.mapId == map.id;
      if (sameMap && _routes.isPointInsideMap(map, live.x, live.y)) {
        return live;
      }
    }
    final beacon = _cadBeaconForReading(_strongestLiveReading());
    if (map == null || beacon == null) return null;
    return UserLiveLocation(
      x: beacon.x,
      y: beacon.y,
      mapId: map.id,
      floorId: map.id,
      beaconId: beacon.id,
    );
  }

  UserLiveLocation? _displayLocationForSelectedMap() {
    return _liveLocationForSelectedMap();
  }

  List<UserLiveLocation> _remoteUserLocationsForSelectedMap({
    bool visibleOnly = true,
  }) {
    final map = _selected;
    if (map == null) return const [];
    final users = _remoteUserLocs.where((user) {
      if (user.mapId != null &&
          user.mapId!.isNotEmpty &&
          user.mapId != map.id) {
        return false;
      }
      return _routes.isPointInsideMap(map, user.x, user.y);
    }).toList();
    if (!visibleOnly) return users;
    return UserLocationDisplaySelection.visibleLocations(
      users,
      hiddenUserIds: _hiddenRemoteUserIds,
    );
  }

  List<UserLiveLocation> _allRemoteUserLocationsForSelectedMap() {
    return _remoteUserLocationsForSelectedMap(visibleOnly: false);
  }

  UserLiveLocation? _remoteUserLocationForSelectedMap() {
    final users = _remoteUserLocationsForSelectedMap();
    return users.isEmpty ? null : users.first;
  }

  CadMapBeacon? _firebaseFireBeacon() {
    for (final beacon in _selected?.beacons ?? const <CadMapBeacon>[]) {
      if (_isBeaconOnFire(beacon)) return beacon;
    }
    return null;
  }

  bool _isIsolationRiskUser(UserLiveLocation user, CadMapBeacon? fireBeacon) {
    if (fireBeacon == null) return false;
    final fireId = fireBeacon.id.trim().toLowerCase();
    final fireName = fireBeacon.displayName.trim().toLowerCase();
    final userBeacon = user.beaconId?.trim().toLowerCase() ?? '';
    final inHomeRoom =
        userBeacon == 'h' ||
        userBeacon == 'h708' ||
        userBeacon.contains('h708');
    final doorBlocked = fireId == 'b04' || fireName == 'b04';
    return inHomeRoom && doorBlocked;
  }

  Set<String> _isolatedRemoteUserIds(
    List<UserLiveLocation> users,
    CadMapBeacon? fireBeacon,
  ) {
    return users
        .where((user) => _isIsolationRiskUser(user, fireBeacon))
        .map((user) => user.userId?.trim().toLowerCase())
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet();
  }

  bool get _fireTrackingMenuEnabled {
    return _foregroundFireMessageActive ||
        _firebaseFireIds.isNotEmpty ||
        _fire?.isFire == true ||
        _allRemoteUserLocationsForSelectedMap().isNotEmpty;
  }

  String _fireTrackingMenuSubtitle() {
    final allUsers = _allRemoteUserLocationsForSelectedMap();
    final visibleUsers = _remoteUserLocationsForSelectedMap();
    final fireActive =
        _foregroundFireMessageActive ||
        _firebaseFireIds.isNotEmpty ||
        _fire?.isFire == true;
    if (fireActive && allUsers.isNotEmpty) {
      if (visibleUsers.length != allUsers.length) {
        return '${visibleUsers.length}/${allUsers.length}명 표시 · 지도 확인';
      }
      return '${allUsers.length}명 위치 수신 · 지도 확인';
    }
    if (fireActive) {
      return '화재 발생 중 · 사용자 위치 수신 대기';
    }
    if (allUsers.isNotEmpty) {
      if (visibleUsers.length != allUsers.length) {
        return '${visibleUsers.length}/${allUsers.length}명 표시 · 화재 발생 시 확인';
      }
      return '${allUsers.length}명 위치 수신 · 화재 발생 시 확인';
    }
    return '화재 발생 시 활성화됩니다';
  }

  double _rssiStrength(int rssi) {
    return ((rssi + 100) / 60).clamp(0.0, 1.0).toDouble();
  }

  Color _signalColor(int? rssi, bool live) {
    if (!live || rssi == null) return const Color(0xFF64748B);
    if (rssi >= -65) return const Color(0xFF22C55E);
    if (rssi >= -80) return const Color(0xFFFBBF24);
    return const Color(0xFFF87171);
  }

  String _signalLabel(int? rssi, bool live) {
    if (rssi == null) return '수신 기록 없음';
    if (!live) return '수신 만료';
    if (rssi >= -65) return '강함';
    if (rssi >= -80) return '보통';
    return '약함';
  }

  String _ageLabel(_BeaconReading? reading) {
    if (reading == null) return '수신 기록 없음';
    final seconds = DateTime.now().difference(reading.detectedAt).inSeconds;
    if (seconds <= 1) return '방금 수신';
    if (seconds < 60) return '$seconds초 전';
    return '${seconds ~/ 60}분 전';
  }

  String _beaconHardwareLabel(CadMapBeacon beacon) {
    final meta = _metadataForBeacon(beacon);
    if (meta == null) return 'BLE 등록 정보 없음';
    return '${meta.uuid} / ${meta.major}:${meta.minor}';
  }

  Future<void> _triggerFireAtBeacon(CadMapBeacon beacon) {
    return _run('화재 지정', () async {
      final startedAt = DateTime.now();
      await _data.updateAdminTest(selectedBeaconId: beacon.id);
      setState(() {
        _fire = FireSystemStatus(
          isFire: true,
          location: beacon.id,
          description: '관리자 화재 감지 점검',
        );
        _fireBeaconId = beacon.id;
        _testActive = false;
        _updateRoutePreview(fireBeacon: beacon);
      });
      _addLogAt(startedAt, '테스트 화재 위치 지정: ${beacon.id}');
      _addLog('Firebase admin/test/selectedBeaconId = ${beacon.id}');
    });
  }

  Future<void> _requestEndTest() async {
    if (!_testActive &&
        _fire == null &&
        !_adminTest.testActive &&
        _adminTest.selectedBeaconId.isEmpty) {
      _addLog('진행 중인 테스트가 없습니다.');
      return;
    }
    if (_endPromptOpen) return;
    _endPromptOpen = true;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('테스트를 종료시킬까요?'),
        content: const Text('확인을 누르면 점검 화재 상태와 대피 경로 표시가 초기화됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('확인'),
          ),
        ],
      ),
    );
    _endPromptOpen = false;
    if (confirmed == true) {
      _finishLocationWait(popDialog: true);
      await _endTest();
    }
  }

  Future<void> _endTest() {
    return _run('테스트 종료', () async {
      await _data.updateAdminTest(selectedBeaconId: '', testActive: false);
      _finishLocationWait(popDialog: true);
      setState(() {
        _fire = null;
        _lastRouteResult = null;
        _testActive = false;
      });
      _addLog('테스트 종료: admin/test/testActive=false');
    });
  }

  void _promptEndTestIfExit(CadMapBeacon? beacon) {
    if (!_testActive || _endPromptOpen || beacon?.isExit != true) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_requestEndTest());
    });
  }

  Future<void> _clearFire() {
    return _run('화재 해제', () async {
      await _data.updateAdminTest(selectedBeaconId: '', testActive: false);
      _finishLocationWait(popDialog: true);
      setState(() {
        _fire = null;
        _lastRouteResult = null;
        _testActive = false;
      });
      _addLog('점검 상태 초기화');
    });
  }

  void _updateRoutePreview({UserLiveLocation? user, CadMapBeacon? fireBeacon}) {
    final map = _selected;
    if (map == null) return;
    _lastRouteResult = _routes.evaluate(
      map: map,
      user: user ?? _liveLocationForSelectedMap(),
      fireBeacon: fireBeacon ?? _activeFireBeacon(),
    );
  }

  Future<void> _beginLocationWaitForTest(CadMap map) async {
    final bluetoothReady = await _ensureBluetoothReadyForLocationWait();
    if (!mounted || !bluetoothReady) return;

    setState(() => _pendingEvacuationTest = true);
    _addLog('비콘 BLE 방송 시작 후 사용자 위치 확인 중: 비콘 근처에서 몇 걸음 이동하세요.');
    _showLocationWaitPrompt();
    await _startBeaconMonitor(map);
  }

  Future<bool> _ensureBluetoothReadyForLocationWait() async {
    final enabled = await _hardwareButtons.isBluetoothEnabled();
    if (enabled) return true;

    const message = '블루투스가 꺼져 있습니다. 블루투스를 켠 뒤 테스트를 다시 진행하세요.';
    _addLog(message);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(message)));
    }
    await _hardwareButtons.openBluetoothSettings();
    return false;
  }

  void _completePendingEvacuationTest(UserLiveLocation user) {
    if (!mounted || !_pendingEvacuationTest) return;
    final fireBeacon = _beaconById(_fireBeaconId);
    final result = _routes.evaluate(
      map: _selected,
      user: user,
      fireBeacon: fireBeacon,
    );
    setState(() => _lastRouteResult = result);
    _addLog('BLE 사용자 위치 확인: ${user.beaconId ?? '현재 위치'}');
    if (result.hasRoute) {
      _addLog(
        '대피경로 계산 완료: ${user.beaconId ?? '현재 위치'} -> ${fireBeacon?.id ?? '화재 위치'}, '
        '${result.distanceMeters.round()}m',
      );
    } else {
      _addLog('대피경로 계산 실패: 우회 경로를 찾지 못했습니다.');
    }
    _finishLocationWait(popDialog: true);
  }

  void _showLocationWaitPrompt() {
    if (_locationWaitPromptOpen || !mounted) return;
    _locationWaitPromptOpen = true;
    _locationWaitReminderTimer?.cancel();
    _locationWaitReminderTimer = Timer(const Duration(seconds: 20), () {
      if (!mounted || !_pendingEvacuationTest) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('아직 BLE 사용자 위치를 찾는 중입니다. 비콘 근처에서 몇 걸음 이동하세요.'),
        ),
      );
    });

    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          _locationWaitDialogContext = dialogContext;
          return AlertDialog(
            icon: const Icon(
              Icons.bluetooth_searching,
              color: Color(0xFF60A5FA),
              size: 42,
            ),
            title: const Text('관리자 위치를 찾는 중'),
            content: const Text(
              '테스트 BLE 방송을 시작했습니다.\n'
              '관리자 태블릿 위치를 잡기 위해 '
              '비콘 근처에서 몇 걸음 이동해 주세요.',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () => _cancelLocationWait(),
                child: const Text('취소'),
              ),
            ],
          );
        },
      ).whenComplete(() {
        _locationWaitDialogContext = null;
        _locationWaitPromptOpen = false;
      }),
    );
  }

  void _cancelLocationWait() {
    _finishLocationWait(popDialog: true);
    _addLog('BLE 사용자 위치 확인 취소');
  }

  void _finishLocationWait({required bool popDialog}) {
    _locationWaitReminderTimer?.cancel();
    _locationWaitReminderTimer = null;
    if (mounted && _pendingEvacuationTest) {
      setState(() => _pendingEvacuationTest = false);
    } else {
      _pendingEvacuationTest = false;
    }

    final dialogContext = _locationWaitDialogContext;
    if (popDialog && dialogContext != null) {
      Navigator.of(dialogContext).pop();
    }
  }

  Future<void> _runEvacuationTest() {
    return _run('테스트 진행', () async {
      final map = _selected;
      if (map == null || map.beacons.isEmpty) {
        _addLog('테스트할 지도나 비콘이 없습니다.');
        return;
      }
      var adminTest = _adminTest;
      if (!adminTest.isTest) {
        try {
          adminTest = await _data.fetchAdminTestStatus();
          if (!mounted) return;
          setState(() {
            _adminTest = adminTest;
            _syncLocalAdminTestState(adminTest);
          });
          _addLog('관리자 모드 새로고침: isTest=${adminTest.isTest}');
        } catch (error) {
          _addLog('관리자 모드 새로고침 실패: $error');
        }
      }
      if (!adminTest.isTest) {
        _showAdminModeRequired();
        return;
      }

      final currentUser = _liveLocationForSelectedMap();
      final decision = AdminEvacuationTestFlow.decide(
        hasMap: map.beacons.isNotEmpty,
        adminModeEnabled: adminTest.isTest,
        hasUserLocation: currentUser != null,
      );
      switch (decision) {
        case AdminEvacuationTestDecision.missingMap:
          _addLog('테스트할 지도나 비콘이 없습니다.');
          return;
        case AdminEvacuationTestDecision.adminModeRequired:
          _showAdminModeRequired();
          return;
        case AdminEvacuationTestDecision.startAndWaitForBleLocation:
          final fireBeacon = _beaconById(_fireBeaconId) ?? map.beacons.last;
          await _startAdminTestBroadcast(
            map: map,
            fireBeacon: fireBeacon,
            user: null,
          );
          await _beginLocationWaitForTest(map);
          return;
        case AdminEvacuationTestDecision.start:
          _finishLocationWait(popDialog: true);
      }
      final fireBeacon = _beaconById(_fireBeaconId) ?? map.beacons.last;
      final user = currentUser!;
      await _startAdminTestBroadcast(
        map: map,
        fireBeacon: fireBeacon,
        user: user,
      );
    });
  }

  Future<void> _startAdminTestBroadcast({
    required CadMap map,
    required CadMapBeacon fireBeacon,
    required UserLiveLocation? user,
  }) async {
    final userLabel = user?.beaconId ?? '현재 위치';
    final result = user == null
        ? null
        : _routes.evaluate(map: map, user: user, fireBeacon: fireBeacon);
    final startedAt = DateTime.now();
    await _data.updateAdminTest(
      selectedBeaconId: fireBeacon.id,
      testActive: true,
    );

    setState(() {
      _fire = FireSystemStatus(
        isFire: true,
        location: fireBeacon.id,
        description: '관리자 화재 감지 점검',
      );
      _fireBeaconId = fireBeacon.id;
      _lastRouteResult = result;
      _testActive = true;
    });

    _addLogAt(startedAt, '${fireBeacon.id} 테스트 진행');
    _addLogAt(startedAt, 'admin/test/testActive=true');
    _addLog('Firebase beacons/onFire는 변경하지 않아 사용자 앱 푸시를 보내지 않습니다.');

    if (result == null) {
      _addLog('비콘 BLE 방송 시작 후 사용자 위치를 확인합니다.');
    } else if (result.hasRoute) {
      _addLog(
        '대피경로 테스트 통과: $userLabel -> ${fireBeacon.id}, '
        '${result.distanceMeters.round()}m',
      );
    } else {
      _addLog('대피경로 테스트 실패: 우회 경로를 찾지 못했습니다.');
    }
  }

  void _showAdminModeRequired() {
    const message = '비콘의 관리자 모드를 ON해주세요!';
    _addLog(message);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text(message)));
  }

  void _openMode() {
    FocusScope.of(context).unfocus();
    setState(() {
      _modeSelected = true;
      _mapExpanded = false;
      _fireTrackingView = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_bodyScrollController.hasClients) {
        _bodyScrollController.jumpTo(0);
      }
    });
    unawaited(_startBeaconMonitor(_selected));
  }

  void _goHome() {
    FocusScope.of(context).unfocus();
    _finishLocationWait(popDialog: true);
    setState(() {
      _modeSelected = false;
      _mapExpanded = false;
      _fireTrackingView = false;
    });
  }

  void _showFireTrackingView() {
    if (!mounted) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _modeSelected = true;
      _mapExpanded = false;
      _fireTrackingView = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackingMapController.focusOnUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_modeSelected && !_mapExpanded && !_fireTrackingView,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_fireTrackingView) {
          setState(() => _fireTrackingView = false);
          return;
        }
        if (_mapExpanded) {
          setState(() => _mapExpanded = false);
          return;
        }
        if (_modeSelected) {
          _goHome();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0F1218),
        appBar: AppBar(
          backgroundColor: const Color(0xFF141B26),
          foregroundColor: Colors.white,
          title: Text(
            !_modeSelected
                ? 'Fieva Admin'
                : _fireTrackingView
                ? '화재 사용자 위치 확인'
                : _mapExpanded
                ? '상세 시뮬레이션 지도'
                : '시뮬레이션 점검',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          actions: [
            if (_fireTrackingView)
              IconButton(
                tooltip: '점검 화면으로 돌아가기',
                onPressed: () => setState(() => _fireTrackingView = false),
                icon: const Icon(Icons.arrow_back),
              ),
            if (_mapExpanded)
              IconButton(
                tooltip: '상세 지도 닫기',
                onPressed: () => setState(() => _mapExpanded = false),
                icon: const Icon(Icons.close_fullscreen),
              ),
            if (_modeSelected && !_mapExpanded && !_fireTrackingView)
              IconButton(
                tooltip: '홈',
                onPressed: _goHome,
                icon: const Icon(Icons.home_outlined),
              ),
          ],
        ),
        body: SafeArea(
          child: _mapExpanded
              ? _expandedMapBody()
              : _fireTrackingView
              ? _fireTrackingBody()
              : _modeSelected
              ? _adminBody()
              : _homeBody(),
        ),
      ),
    );
  }

  Widget _homeBody() {
    final fireBeacon = _firebaseFireBeacon();
    final fireTrackingEnabled = _fireTrackingMenuEnabled;

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 620;
        final tall = constraints.maxHeight >= 760;
        final minHeight = constraints.maxHeight > 44
            ? constraints.maxHeight - 44
            : 0.0;
        final logoSize = wide ? 132.0 : 116.0;
        final topGap = wide
            ? 44.0
            : tall
            ? 46.0
            : 24.0;
        final chooserGap = wide
            ? 78.0
            : tall
            ? 88.0
            : 42.0;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: topGap),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: logoSize,
                        height: logoSize,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFEF4444,
                              ).withValues(alpha: 0.22),
                              blurRadius: 28,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Image.asset(
                            'assets/fieva_app_icon.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'FIEVA 관리자 점검',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        '화재 감지 훈련과 실제 비콘 상태를 확인합니다.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white60, fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _statusPill(
                            _selected == null
                                ? '지도 대기'
                                : '지도 내 ${_selected!.beacons.length}개 비콘 설치됨',
                            const Color(0xFF60A5FA),
                          ),
                          _statusPill(
                            fireBeacon == null
                                ? 'onFire 없음'
                                : 'onFire ${fireBeacon.displayName}',
                            fireBeacon == null
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFFEF4444),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: chooserGap),
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: wide ? 560 : 360),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          '관리자 점검',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          '점검 모드를 선택하세요.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                        const SizedBox(height: 16),
                        _modeLaunchButton(
                          icon: Icons.science,
                          title: '시뮬레이션 모드',
                          subtitle: '지도, 테스트, 비콘 신호 점검',
                          color: const Color(0xFF60A5FA),
                        ),
                        const SizedBox(height: 10),
                        _modeLaunchButton(
                          icon: Icons.location_searching,
                          title: '화재 사용자 위치 확인',
                          subtitle: _fireTrackingMenuSubtitle(),
                          color: fireTrackingEnabled
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF94A3B8),
                          enabled: fireTrackingEnabled,
                          onTap: _showFireTrackingView,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 26),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _modeLaunchButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    bool enabled = true,
    VoidCallback? onTap,
  }) {
    final effectiveColor = enabled ? color : const Color(0xFF64748B);
    final titleColor = enabled ? Colors.white : Colors.white54;
    final subtitleColor = enabled ? Colors.white60 : Colors.white38;
    return Material(
      color: const Color(0xFF18212F),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: enabled ? onTap ?? _openMode : null,
        child: Container(
          constraints: const BoxConstraints(minHeight: 92),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: effectiveColor.withValues(alpha: 0.38)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: effectiveColor.withValues(alpha: enabled ? 0.16 : 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: effectiveColor, size: 24),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: subtitleColor, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Icon(
                enabled ? Icons.chevron_right : Icons.lock_outline,
                color: effectiveColor,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _adminBody() {
    return ListView(
      controller: _bodyScrollController,
      padding: const EdgeInsets.all(14),
      children: [
        _modeHeaderCard(),
        const SizedBox(height: 12),
        _statusCard(),
        const SizedBox(height: 12),
        _mapCard(),
        const SizedBox(height: 12),
        _mapPickCard(),
        const SizedBox(height: 12),
        _evacuationTestCard(),
        const SizedBox(height: 12),
        _realOverviewCard(),
        const SizedBox(height: 12),
        _bleMonitorCard(),
        const SizedBox(height: 12),
        _realBeaconListCard(),
        const SizedBox(height: 12),
        _logPanel(),
      ],
    );
  }

  Widget _modeHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF141B26),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.science, color: Color(0xFF60A5FA)),
              const SizedBox(width: 8),
              Expanded(
                child: const Text(
                  '시뮬레이션 점검',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton.filledTonal(
                tooltip: '홈',
                onPressed: _goHome,
                icon: const Icon(Icons.home_outlined),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _statusPill(
                _testActive ? '테스트 중' : '대기',
                _testActive ? const Color(0xFFEF4444) : const Color(0xFF22C55E),
              ),
              if (_pendingEvacuationTest)
                _statusPill('위치 확인 중', const Color(0xFF60A5FA)),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            '사용자 앱에 푸시를 보내지 않고 지도, 대피 경로, BLE RSSI를 한 화면에서 검증합니다.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _statusCard() {
    final fireBeacon = _activeFireBeacon();
    final isFire = fireBeacon != null;
    final adminReady = _adminTest.isTest;
    final selectedTestBeaconId = _adminTest.selectedBeaconId.isNotEmpty
        ? _adminTest.selectedBeaconId
        : _fireBeaconId ?? '';
    return _card(
      icon: isFire ? Icons.local_fire_department : Icons.check_circle,
      title: '시뮬레이션 준비',
      accent: isFire ? const Color(0xFFEF4444) : const Color(0xFF22C55E),
      trailing: IconButton.filledTonal(
        tooltip: adminReady ? '관리자 모드 ON' : '관리자 모드 OFF',
        onPressed: null,
        icon: Icon(
          adminReady ? Icons.local_fire_department : Icons.power_settings_new,
        ),
      ),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _statusPill(
              adminReady ? '관리자 모드 ON' : '관리자 모드 OFF',
              adminReady ? const Color(0xFF22C55E) : const Color(0xFFF59E0B),
            ),
            _statusPill(
              _testActive
                  ? '테스트 중'
                  : _pendingEvacuationTest
                  ? '위치 확인 중'
                  : '테스트 대기',
              _testActive
                  ? const Color(0xFFEF4444)
                  : _pendingEvacuationTest
                  ? const Color(0xFF60A5FA)
                  : const Color(0xFF94A3B8),
            ),
            _statusPill(
              selectedTestBeaconId.isEmpty
                  ? '화재 비콘 미선택'
                  : '화재 $selectedTestBeaconId',
              selectedTestBeaconId.isEmpty
                  ? const Color(0xFF94A3B8)
                  : const Color(0xFF60A5FA),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          isFire
              ? '점검 화재 위치: ${fireBeacon.displayName}'
              : '건물 관리자가 실제 사용자 모드에 영향을 주지 않고 대피 경로와 비콘 신호를 점검합니다.',
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }

  Widget _mapCard() {
    return _card(
      icon: Icons.map,
      title: '지도 선택',
      children: [
        DropdownButton<String>(
          value: _selected?.id,
          isExpanded: true,
          dropdownColor: const Color(0xFF1E293B),
          underline: const SizedBox.shrink(),
          iconEnabledColor: Colors.white,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          hint: const Text('지도 선택', style: TextStyle(color: Colors.white70)),
          items: _maps
              .map(
                (map) => DropdownMenuItem(
                  value: map.id,
                  child: Text('${map.originalFile} (${map.beacons.length}개)'),
                ),
              )
              .toList(),
          onChanged: (id) {
            if (id == null) return;
            final selected = _maps.firstWhere((map) => map.id == id);
            setState(() {
              _selected = selected;
              _syncBeaconSelections();
              _resetLocalSimulation();
              _syncLocalAdminTestState(_adminTest);
            });
            unawaited(_loadMapImage(selected));
            unawaited(_startBeaconMonitor(selected));
          },
        ),
      ],
    );
  }

  Widget _realOverviewCard() {
    final map = _selected;
    final strongest = _strongestLiveReading();
    final strongestBeacon = _cadBeaconForReading(strongest);
    final liveCount = _liveReadings().length;
    final fireBeacon = _firebaseFireBeacon();
    final knownCount = _knownBeacons.length;
    final mapBeaconCount = map?.beacons.length ?? 0;

    return _card(
      icon: Icons.sensors,
      title: '현장 비콘 점검',
      accent: const Color(0xFF38BDF8),
      trailing: IconButton.filledTonal(
        tooltip: 'BLE 스캔 재시작',
        onPressed: _busy
            ? null
            : () => unawaited(_startBeaconMonitor(_selected)),
        icon: const Icon(Icons.refresh),
      ),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _metricTile(
              icon: Icons.radar,
              label: '수신 중',
              value: '$liveCount / $mapBeaconCount',
              color: liveCount > 0
                  ? const Color(0xFF22C55E)
                  : const Color(0xFFF59E0B),
            ),
            _metricTile(
              icon: Icons.bluetooth_connected,
              label: '등록 BLE',
              value: '$knownCount개',
              color: const Color(0xFF60A5FA),
            ),
            _metricTile(
              icon: Icons.local_fire_department,
              label: 'onFire',
              value: fireBeacon?.displayName ?? '없음',
              color: fireBeacon == null
                  ? const Color(0xFF94A3B8)
                  : const Color(0xFFEF4444),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _signalBars(
                    strongest == null ? 0.0 : _rssiStrength(strongest.rssi),
                    strongest == null
                        ? const Color(0xFFF59E0B)
                        : _signalColor(strongest.rssi, true),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strongestBeacon == null
                              ? '현재 위치 비콘 미확인'
                              : '현재 위치 ${strongestBeacon.displayName}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          strongest == null
                              ? _scanStatus
                              : '${_signalLabel(strongest.rssi, true)} · ${_ageLabel(strongest)}',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    strongest == null ? '-- dBm' : '${strongest.rssi} dBm',
                    style: TextStyle(
                      color: strongest == null
                          ? const Color(0xFFF59E0B)
                          : _signalColor(strongest.rssi, true),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _rssiMeter(
                strongest == null ? 0.0 : _rssiStrength(strongest.rssi),
                strongest == null
                    ? const Color(0xFFF59E0B)
                    : _signalColor(strongest.rssi, true),
                height: 11,
              ),
              const SizedBox(height: 6),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '약함',
                    style: TextStyle(color: Colors.white38, fontSize: 10),
                  ),
                  Text(
                    '강함',
                    style: TextStyle(color: Colors.white38, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _realBeaconListCard() {
    final source = List<CadMapBeacon>.of(
      _selected?.beacons ?? const <CadMapBeacon>[],
    );
    final beacons = source.where(_matchesBeaconFilter).toList()
      ..sort(_compareRealBeacons);

    return _card(
      icon: Icons.inventory_2_outlined,
      title: '비콘 상태 목록',
      accent: const Color(0xFFA7F3D0),
      trailing: IconButton.filledTonal(
        tooltip: _beaconListExpanded ? '비콘 상태 목록 접기' : '비콘 상태 목록 펼치기',
        onPressed: () {
          setState(() => _beaconListExpanded = !_beaconListExpanded);
        },
        icon: Icon(_beaconListExpanded ? Icons.expand_less : Icons.expand_more),
      ),
      children: _beaconListExpanded
          ? [
              SegmentedButton<_BeaconListFilter>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: _BeaconListFilter.all,
                    label: Text('전체'),
                  ),
                  ButtonSegment(
                    value: _BeaconListFilter.live,
                    label: Text('수신'),
                  ),
                  ButtonSegment(
                    value: _BeaconListFilter.fire,
                    label: Text('화재'),
                  ),
                  ButtonSegment(
                    value: _BeaconListFilter.waiting,
                    label: Text('대기'),
                  ),
                ],
                selected: {_beaconFilter},
                onSelectionChanged: (selection) {
                  setState(() => _beaconFilter = selection.first);
                },
              ),
              const SizedBox(height: 12),
              if (source.isEmpty)
                const Text(
                  '등록된 비콘이 없습니다.',
                  style: TextStyle(color: Colors.white70),
                )
              else if (beacons.isEmpty)
                const Text(
                  '필터에 해당하는 비콘이 없습니다.',
                  style: TextStyle(color: Colors.white70),
                )
              else
                ...beacons.map(_realBeaconTile),
            ]
          : const [],
    );
  }

  bool _matchesBeaconFilter(CadMapBeacon beacon) {
    final reading = _readingForBeacon(beacon);
    final live = _isReadingLive(reading);
    final fire = _isBeaconOnFire(beacon);
    return switch (_beaconFilter) {
      _BeaconListFilter.all => true,
      _BeaconListFilter.live => live,
      _BeaconListFilter.fire => fire,
      _BeaconListFilter.waiting => !live,
    };
  }

  int _compareRealBeacons(CadMapBeacon a, CadMapBeacon b) {
    final aFire = _isBeaconOnFire(a);
    final bFire = _isBeaconOnFire(b);
    if (aFire != bFire) return aFire ? -1 : 1;
    final aReading = _readingForBeacon(a);
    final bReading = _readingForBeacon(b);
    final aLive = _isReadingLive(aReading);
    final bLive = _isReadingLive(bReading);
    if (aLive != bLive) return aLive ? -1 : 1;
    if (aReading != null && bReading != null) {
      final rssiCompare = bReading.rssi.compareTo(aReading.rssi);
      if (rssiCompare != 0) return rssiCompare;
    }
    return a.displayName.compareTo(b.displayName);
  }

  Widget _realBeaconTile(CadMapBeacon beacon) {
    final reading = _readingForBeacon(beacon);
    final live = _isReadingLive(reading);
    final fire = _isBeaconOnFire(beacon);
    final color = _signalColor(reading?.rssi, live);
    final label = fire ? 'onFire' : _signalLabel(reading?.rssi, live);
    final progress = reading == null ? 0.0 : _rssiStrength(reading.rssi);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: fire
            ? const Color(0xFF451A1A)
            : live
            ? const Color(0xFF0F2A24)
            : const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: fire
              ? const Color(0xFFEF4444)
              : color.withValues(alpha: live ? 0.42 : 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: fire ? const Color(0xFFEF4444) : color,
                child: Icon(
                  fire
                      ? Icons.local_fire_department
                      : beacon.isExit
                      ? Icons.exit_to_app
                      : Icons.sensors,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      beacon.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      _beaconHardwareLabel(beacon),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _statusPill(label, fire ? const Color(0xFFEF4444) : color),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _signalBars(progress, color, compact: true),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'RSSI',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          reading == null ? '-- dBm' : '${reading.rssi} dBm',
                          style: TextStyle(
                            color: color,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _rssiMeter(progress, color),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '블루투스 신호 세기',
                          style: TextStyle(color: Colors.white38, fontSize: 10),
                        ),
                        Text(
                          _ageLabel(reading),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mapPickCard() {
    final map = _selected;
    final imageUrl = _selected?.id == _mapImageMapId ? _mapImageUrl : null;
    final result = _lastRouteResult;
    return _card(
      icon: Icons.science,
      title: '화재 시뮬레이션 지도 표시',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_testActive) ...[
            _statusPill('테스트 중', const Color(0xFFEF4444)),
            const SizedBox(width: 8),
          ],
          IconButton.filledTonal(
            tooltip: '상세 지도 펼치기',
            onPressed: map == null || imageUrl == null || imageUrl.isEmpty
                ? null
                : () {
                    setState(() => _mapExpanded = true);
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => _mapController.focusOnUser(),
                    );
                  },
            icon: const Icon(Icons.open_in_full),
          ),
        ],
      ),
      children: [
        SizedBox(
          height: 250,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: map == null
                ? _mapPlaceholder('선택된 지도가 없습니다.')
                : imageUrl == null
                ? _mapPlaceholder('지도 이미지를 불러오는 중...')
                : imageUrl.isEmpty
                ? _mapPlaceholder('지도 이미지를 불러오지 못했습니다.')
                : Stack(
                    children: [
                      Positioned.fill(
                        child: _simulationMap(
                          map: map,
                          imageUrl: imageUrl,
                          result: result,
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: _adminLocationButton(compact: true),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _simulationMap({
    required CadMap map,
    required String imageUrl,
    required EvacuationRouteResult? result,
  }) {
    return CadMapView(
      cadMap: map,
      imageUrl: imageUrl,
      userLocation: _displayLocationForSelectedMap(),
      fireBeacon: _activeFireBeacon(),
      destinationPoint: result?.points.isNotEmpty == true
          ? result!.points.last
          : null,
      destinationLabel: result?.destinationId ?? '',
      routePoints: result?.points ?? const [],
      controller: _mapController,
      onBrowsingChanged: (browsing) {
        if (mounted && browsing != _isBrowsingMap) {
          setState(() => _isBrowsingMap = browsing);
        }
      },
    );
  }

  Widget _expandedMapBody() {
    final map = _selected;
    final imageUrl = _selected?.id == _mapImageMapId ? _mapImageUrl : null;
    final result = _lastRouteResult;
    if (map == null || imageUrl == null) {
      return _mapPlaceholder('상세 지도를 불러오는 중...');
    }
    if (imageUrl.isEmpty) {
      return _mapPlaceholder('지도 이미지를 불러오지 못했습니다.');
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          color: const Color(0xFF18212F),
          child: Row(
            children: [
              const Icon(Icons.map, color: Color(0xFF60A5FA)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '화재 시뮬레이션 지도 표시',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (_testActive) ...[
                _statusPill('테스트 중', const Color(0xFFEF4444)),
                const SizedBox(width: 8),
              ],
              const SizedBox(width: 8),
              IconButton.filledTonal(
                tooltip: '화재 초기화',
                onPressed: _busy ? null : _clearFire,
                icon: const Icon(Icons.restart_alt),
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: _simulationMap(
                  map: map,
                  imageUrl: imageUrl,
                  result: result,
                ),
              ),
              Positioned(left: 12, top: 12, child: _adminMapInfo(map, result)),
              Positioned(right: 12, top: 12, child: _adminLocationButton()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fireTrackingBody() {
    final map = _selected;
    final imageUrl = _selected?.id == _mapImageMapId ? _mapImageUrl : null;
    final allUsers = _allRemoteUserLocationsForSelectedMap();
    final users = _remoteUserLocationsForSelectedMap();
    final user = users.isEmpty ? null : users.first;
    final fireBeacon = _firebaseFireBeacon();
    final isolatedUserIds = _isolatedRemoteUserIds(users, fireBeacon);

    if (map == null || imageUrl == null) {
      return _mapPlaceholder('사용자 위치 지도를 불러오는 중...');
    }
    if (imageUrl.isEmpty) {
      return _mapPlaceholder('지도 이미지를 불러오지 못했습니다.');
    }

    return Stack(
      children: [
        Positioned.fill(
          child: CadMapView(
            cadMap: map,
            imageUrl: imageUrl,
            userLocation: user,
            userLocations: users,
            isolatedUserIds: isolatedUserIds,
            fireBeacon: fireBeacon,
            routePoints: const [],
            controller: _trackingMapController,
            onBrowsingChanged: (browsing) {
              if (mounted && browsing != _isBrowsingTrackingMap) {
                setState(() => _isBrowsingTrackingMap = browsing);
              }
            },
          ),
        ),
        Positioned(
          left: 12,
          top: 12,
          child: _fireTrackingInfo(
            map,
            allUsers,
            users,
            fireBeacon,
            isolatedUserIds,
          ),
        ),
        Positioned(right: 12, top: 12, child: _trackingLocationButton(user)),
      ],
    );
  }

  Widget _fireTrackingInfo(
    CadMap map,
    List<UserLiveLocation> allUsers,
    List<UserLiveLocation> users,
    CadMapBeacon? fireBeacon,
    Set<String> isolatedUserIds,
  ) {
    final totalCount = allUsers.length;
    final visibleCount = users.length;
    final userLabel = totalCount == 0
        ? '수신 대기'
        : visibleCount == totalCount
        ? '$totalCount명 표시'
        : '$visibleCount/$totalCount명 표시';

    return Container(
      constraints: const BoxConstraints(maxWidth: 260),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xE6151E2B),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '화재 사용자 위치',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            '${_floorLabel(map)} · $userLabel',
            style: const TextStyle(
              color: Color(0xFF7DD3FC),
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            allUsers.isEmpty
                ? '사용자 앱 위치 업로드 대기 중'
                : users.isEmpty
                ? '선택된 사용자가 없습니다'
                : '${users.length}명 위치 수신 · ${_locationsUpdatedLabel(users)}',
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
          if (fireBeacon != null) ...[
            const SizedBox(height: 7),
            Text(
              '화재 ${fireBeacon.displayName}',
              style: const TextStyle(
                color: Color(0xFFFCA5A5),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          if (isolatedUserIds.isNotEmpty) ...[
            const SizedBox(height: 7),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0x33EF4444),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0x99FCA5A5)),
              ),
              child: Text(
                '고립 위험 ${isolatedUserIds.length}명',
                style: const TextStyle(
                  color: Color(0xFFFCA5A5),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
          if (allUsers.isNotEmpty) ...[
            const SizedBox(height: 9),
            _userVisibilityPicker(allUsers, fireBeacon),
          ],
        ],
      ),
    );
  }

  Widget _userVisibilityPicker(
    List<UserLiveLocation> users,
    CadMapBeacon? fireBeacon,
  ) {
    final hiddenInView = users.asMap().entries.where((entry) {
      final key = UserLocationDisplaySelection.userKey(entry.value, entry.key);
      return _hiddenRemoteUserIds.contains(key);
    }).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(7),
                onTap: () {
                  setState(() {
                    _userVisibilityExpanded = !_userVisibilityExpanded;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      _userVisibilityExpanded
                          ? Icons.expand_less
                          : Icons.expand_more,
                      size: 16,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 4),
                    const Flexible(
                      child: Text(
                        '표시할 사용자',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_userVisibilityExpanded && hiddenInView > 0)
              TextButton(
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(42, 24),
                  foregroundColor: const Color(0xFF7DD3FC),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  setState(() {
                    for (final entry in users.asMap().entries) {
                      _hiddenRemoteUserIds.remove(
                        UserLocationDisplaySelection.userKey(
                          entry.value,
                          entry.key,
                        ),
                      );
                    }
                  });
                },
                child: const Text('전체 표시', style: TextStyle(fontSize: 11)),
              ),
          ],
        ),
        if (_userVisibilityExpanded) ...[
          const SizedBox(height: 3),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 156),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (final entry in users.asMap().entries)
                    _userVisibilityTile(entry.value, entry.key, fireBeacon),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _userVisibilityTile(
    UserLiveLocation user,
    int index,
    CadMapBeacon? fireBeacon,
  ) {
    final key = UserLocationDisplaySelection.userKey(user, index);
    final visible = !_hiddenRemoteUserIds.contains(key);
    final beacon = user.beaconId?.isNotEmpty == true ? user.beaconId! : '좌표';
    final isolationRisk = _isIsolationRiskUser(user, fireBeacon);

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _setRemoteUserVisible(key, !visible),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            SizedBox(
              width: 26,
              height: 26,
              child: Checkbox(
                value: visible,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: const BorderSide(color: Colors.white54),
                activeColor: isolationRisk
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF38BDF8),
                onChanged: (checked) {
                  _setRemoteUserVisible(key, checked ?? true);
                },
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                isolationRisk ? '$key · $beacon · 고립 위험' : '$key · $beacon',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: !visible
                      ? Colors.white38
                      : isolationRisk
                      ? const Color(0xFFFCA5A5)
                      : Colors.white,
                  fontSize: 11,
                  fontWeight: isolationRisk ? FontWeight.w900 : FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setRemoteUserVisible(String userId, bool visible) {
    setState(() {
      if (visible) {
        _hiddenRemoteUserIds.remove(userId);
      } else {
        _hiddenRemoteUserIds.add(userId);
      }
    });
  }

  Widget _trackingLocationButton(UserLiveLocation? user) {
    return Material(
      color: const Color(0xE6151E2B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Colors.white12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: user == null ? null : _trackingMapController.focusOnUser,
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.my_location, color: Color(0xFF7DD3FC), size: 24),
        ),
      ),
    );
  }

  String _locationUpdatedLabel(UserLiveLocation user) {
    final updated = user.lastUpdated;
    if (updated == null) return '사용자 위치 수신됨';
    final seconds = DateTime.now().difference(updated).inSeconds;
    if (seconds <= 1) return '방금 업데이트';
    if (seconds < 60) return '$seconds초 전 업데이트';
    return '${seconds ~/ 60}분 전 업데이트';
  }

  String _locationsUpdatedLabel(List<UserLiveLocation> users) {
    DateTime? latest;
    for (final user in users) {
      final updated = user.lastUpdated;
      if (updated == null) continue;
      if (latest == null || updated.isAfter(latest)) latest = updated;
    }
    if (latest == null) return '사용자 위치 수신됨';
    return _locationUpdatedLabel(
      UserLiveLocation(x: users.first.x, y: users.first.y, lastUpdated: latest),
    );
  }

  Widget _adminMapInfo(CadMap map, EvacuationRouteResult? result) {
    final fire = _activeFireBeacon();
    return Container(
      constraints: const BoxConstraints(maxWidth: 190),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xE6151E2B),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${_floorLabel(map)} · 비콘 ${map.beacons.length}개',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _isBrowsingMap ? '지도 둘러보는 중' : '사용자 위치 중심',
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
          if (fire != null) ...[
            const SizedBox(height: 6),
            Text(
              '화재 ${fire.displayName}',
              style: const TextStyle(
                color: Color(0xFFFCA5A5),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          if (result?.destinationId.isNotEmpty == true) ...[
            const SizedBox(height: 3),
            Text(
              '대피 출구 ${result!.destinationId}',
              style: const TextStyle(
                color: Color(0xFF86EFAC),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _adminLocationButton({bool compact = false}) {
    final location = _displayLocationForSelectedMap();
    return Material(
      color: const Color(0xE6151E2B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(compact ? 10 : 14),
        side: const BorderSide(color: Colors.white12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(compact ? 10 : 14),
        onTap: location == null ? null : _mapController.focusOnUser,
        child: Padding(
          padding: EdgeInsets.all(compact ? 8 : 12),
          child: Icon(
            Icons.my_location,
            size: compact ? 19 : 24,
            color: const Color(0xFF7DD3FC),
          ),
        ),
      ),
    );
  }

  String _floorLabel(CadMap map) {
    final source = '${map.id} ${map.originalFile}';
    final match = RegExp(
      r'(\d{1,2})\s*f',
      caseSensitive: false,
    ).firstMatch(source);
    return match == null ? '현재 층' : '${match.group(1)}층';
  }

  Widget _mapPlaceholder(String message) {
    return Container(
      color: const Color(0xFF0F172A),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(18),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white70, fontSize: 13),
      ),
    );
  }

  Widget _evacuationTestCard() {
    final beacons = _selected?.beacons ?? const <CadMapBeacon>[];
    final result = _lastRouteResult;
    final adminReady = _adminTest.isTest;

    return _card(
      icon: Icons.route,
      title: '화재 대피 테스트',
      children: [
        _beaconDropdown(
          value: _fireBeaconId,
          beacons: beacons,
          hint: '화재 위치 비콘',
          onChanged: (id) {
            if (_busy || _testActive) return;
            setState(() => _fireBeaconId = id);
            final beacon = _beaconById(id);
            if (beacon != null) {
              unawaited(_triggerFireAtBeacon(beacon));
            }
          },
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _statusPill(
              adminReady ? '관리자 모드 ON' : '관리자 모드 OFF',
              adminReady ? const Color(0xFF22C55E) : const Color(0xFFF59E0B),
            ),
            _statusPill(
              _fireBeaconId == null ? '화재 위치 대기' : '화재 $_fireBeaconId',
              _fireBeaconId == null
                  ? const Color(0xFF94A3B8)
                  : const Color(0xFF60A5FA),
            ),
            if (_pendingEvacuationTest)
              _statusPill('BLE 위치 확인 중', const Color(0xFF38BDF8)),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: _busy || _testActive
                  ? null
                  : () {
                      final beacon = _beaconById(_fireBeaconId);
                      if (beacon == null) {
                        _addLog('화재 위치로 지정할 비콘이 없습니다.');
                        return;
                      }
                      unawaited(_triggerFireAtBeacon(beacon));
                    },
              icon: const Icon(Icons.local_fire_department),
              label: const Text('화재 지정'),
            ),
            FilledButton.icon(
              onPressed: _busy || _testActive || _pendingEvacuationTest
                  ? null
                  : _runEvacuationTest,
              icon: Icon(
                _pendingEvacuationTest
                    ? Icons.bluetooth_searching
                    : Icons.play_arrow,
              ),
              label: Text(_pendingEvacuationTest ? '위치 확인 중' : '테스트 진행'),
            ),
            OutlinedButton.icon(
              onPressed: _busy ? null : _requestEndTest,
              icon: const Icon(Icons.stop_circle_outlined),
              label: const Text('테스트 종료'),
            ),
          ],
        ),
        if (result != null) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: result.hasRoute
                  ? const Color(0xFF064E3B)
                  : const Color(0xFF7F1D1D),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              result.hasRoute
                  ? '통과: ${result.distanceMeters.round()}m / ${result.nodeIds.join(' -> ')}'
                  : '실패: 우회 경로 없음',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _bleMonitorCard() {
    return _card(
      icon: Icons.bluetooth_searching,
      title: '블루투스 신호 세기',
      accent: const Color(0xFF38BDF8),
      trailing: IconButton.filledTonal(
        tooltip: 'BLE 스캔 재시작',
        onPressed: _busy
            ? null
            : () => unawaited(_startBeaconMonitor(_selected)),
        icon: const Icon(Icons.refresh),
      ),
      children: [
        Text(
          _scanStatus,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 10),
        if (_bleReadings.isEmpty)
          const Text(
            '감지된 비콘 신호가 없습니다.',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          )
        else
          ..._bleReadings.asMap().entries.map(
            (entry) => _bleReadingTile(entry.key + 1, entry.value),
          ),
      ],
    );
  }

  Widget _bleReadingTile(int rank, _BeaconReading reading) {
    final live = _isReadingLive(reading);
    final strength = _rssiStrength(reading.rssi);
    final color = _signalColor(reading.rssi, live);
    final history = _rssiHistory[reading.matchKey] ?? const <int>[];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: live ? 0.38 : 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: color.withValues(alpha: 0.34)),
                ),
                child: Text(
                  '$rank',
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reading.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '${_signalLabel(reading.rssi, live)} · ${_ageLabel(reading)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _signalBars(strength, color, compact: true),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              SizedBox(
                width: 74,
                child: Text(
                  '${reading.rssi} dBm',
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Expanded(child: _rssiMeter(strength, color)),
              const SizedBox(width: 10),
              SizedBox(
                width: 72,
                height: 34,
                child: CustomPaint(
                  painter: _RssiSparklinePainter(history, color),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _signalBars(double strength, Color color, {bool compact = false}) {
    final safeStrength = strength.clamp(0.0, 1.0).toDouble();
    final heights = compact
        ? const [7.0, 11.0, 15.0, 20.0]
        : const [9.0, 14.0, 20.0, 27.0];
    final barWidth = compact ? 5.0 : 6.0;
    final gap = compact ? 3.0 : 4.0;

    return SizedBox(
      width: compact ? 29 : 36,
      height: compact ? 24 : 32,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < heights.length; i++) ...[
            Container(
              width: barWidth,
              height: heights[i],
              decoration: BoxDecoration(
                color: safeStrength > i / heights.length
                    ? color
                    : Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            if (i != heights.length - 1) SizedBox(width: gap),
          ],
        ],
      ),
    );
  }

  Widget _rssiMeter(double strength, Color color, {double height = 9}) {
    final safeStrength = strength.clamp(0.0, 1.0).toDouble();

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Stack(
        children: [
          Container(
            height: height,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.11),
            ),
          ),
          FractionallySizedBox(
            widthFactor: safeStrength,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withValues(alpha: 0.58), color],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _beaconDropdown({
    required String? value,
    required List<CadMapBeacon> beacons,
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
    final safeValue = beacons.any((beacon) => beacon.id == value)
        ? value
        : null;
    return DropdownButton<String>(
      value: safeValue,
      isExpanded: true,
      dropdownColor: const Color(0xFF1E293B),
      underline: const SizedBox.shrink(),
      iconEnabledColor: Colors.white,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      hint: Text(hint, style: const TextStyle(color: Colors.white70)),
      items: beacons
          .map(
            (beacon) => DropdownMenuItem(
              value: beacon.id,
              child: Text(beacon.displayName, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: beacons.isEmpty ? null : onChanged,
    );
  }

  Widget _statusPill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _metricTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 142,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 19),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({
    required IconData icon,
    required String title,
    required List<Widget> children,
    Color accent = const Color(0xFF60A5FA),
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF18212F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: accent, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          if (children.isNotEmpty) ...[const SizedBox(height: 12), ...children],
        ],
      ),
    );
  }

  Widget _logPanel() {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: SingleChildScrollView(
        child: Text(
          _log,
          style: const TextStyle(
            color: Color(0xFF86EFAC),
            fontFamily: 'monospace',
            fontSize: 12,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}

class _RssiSparklinePainter extends CustomPainter {
  final List<int> values;
  final Color color;

  const _RssiSparklinePainter(this.values, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height - 1),
      Offset(size.width, size.height - 1),
      axisPaint,
    );

    if (values.length < 2) return;

    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = values.length == 1
          ? size.width
          : (i / (values.length - 1)) * size.width;
      final normalized = ((values[i] + 100) / 60).clamp(0.0, 1.0).toDouble();
      final y = size.height - (normalized * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _RssiSparklinePainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.color != color;
  }
}
