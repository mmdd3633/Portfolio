import 'dart:async';
import 'dart:math' as math;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../models/beacon_data.dart';
import '../models/cad_map.dart';
import '../models/route_node.dart';
import '../services/beacon_service.dart';
import '../services/beacon_signal_guard.dart';
import '../services/emergency_alert_service.dart';
import '../services/evacuation_guidance_service.dart';
import '../services/evacuation_route_service.dart';
import '../services/firebase_service.dart';
import '../services/fieva_data_service.dart';
import '../services/focus_direction_service.dart';
import '../services/hardware_button_service.dart';
import '../services/location_estimator.dart';
import '../services/pdr_motion_service.dart';
import '../services/tts_service.dart';
import '../services/user_guidance_mode_service.dart';
import '../services/user_identity_service.dart';
import '../widgets/cad_map_view.dart';
import '../widgets/navigation_panel.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  static const Map<String, TurnDirection> _exitDoorTurns = {
    'b1': TurnDirection.right,
    'b01': TurnDirection.right,
    'b11': TurnDirection.left,
  };
  static const Set<String> _confirmedExitBeaconIds = {
    'b01',
    'b05',
    'b10',
    'b12',
  };
  static const Map<String, TurnDirection> _exitApproachTurns = {
    'b02>b01': TurnDirection.right,
    'b04>b05': TurnDirection.right,
    'b06>b05': TurnDirection.left,
    'b09>b10': TurnDirection.right,
    'b11>b10': TurnDirection.left,
    'b11>b12': TurnDirection.left,
  };
  static const List<(String, String)> _corridorEdges = [
    ('b01', 'b02'),
    ('b02', 'b03'),
    ('b03', 'b04'),
    ('b04', 'b05'),
    ('b05', 'b06'),
    ('b06', 'b07'),
    ('b07', 'b09'),
    ('b09', 'b08'),
    ('b09', 'b10'),
    ('b10', 'b11'),
    ('b11', 'b12'),
  ];
  static const _debugStatusUiInterval = Duration(seconds: 1);
  static const _guidanceRefreshInterval = Duration(seconds: 1);
  static const _liveLocationUploadInterval = Duration(seconds: 2);
  static const _noFireGuidanceText = '화재 미발생, 위치 추적 비활성화';
  static const _sameGuidanceSpeechCooldown = Duration(seconds: 25);
  static const _sameBeaconSpeechCooldown = Duration(seconds: 15);
  static const _regularGuidanceSpeechGap = Duration(seconds: 8);
  static const _priorityGuidanceSpeechGap = Duration(seconds: 3);
  static const _turnGuidanceSegmentCooldown = Duration(seconds: 20);
  static const _beaconSwitchConfirmations = 1;

  final _data = FievaDataService();
  final _firebase = FirebaseService();
  final _identity = UserIdentityService();
  final _beacons = BeaconService();
  final _signalGuard = BeaconSignalGuard(
    requiredConfirmations: 1,
    minimumConfirmationSpan: Duration.zero,
    signalTimeout: const Duration(seconds: 4),
  );
  final _estimator = LocationEstimator();
  final _pdr = PdrMotionService();
  final _routes = EvacuationRouteService();
  final _tts = TtsService();
  final _hardwareButtons = HardwareButtonService();
  final _emergencyAlerts = EmergencyAlertService();
  final _mapController = CadMapController();
  final _focusDirection = FocusDirectionService();
  final _userIdController = TextEditingController(
    text: UserIdentityService.defaultUserId,
  );

  List<CadMap> _availableMaps = [];
  CadMap? _currentMap;
  String? _imageUrl;
  String _status = 'Firebase CAD 지도를 불러오는 중...';
  bool _loading = true;

  UserLiveLocation? _userLocation;
  CadMapBeacon? _fireBeacon;
  CadMapBeacon? _hardwareFireBeacon;
  CadMapBeacon? _statusFireBeacon;

  StreamSubscription<CadMap?>? _mapSub;
  StreamSubscription<List<BeaconData>>? _fireBeaconSub;
  StreamSubscription<FireSystemStatus>? _fireStatusSub;
  StreamSubscription<List<BeaconData>>? _knownBeaconSub;
  StreamSubscription<List<DetectedBeacon>>? _detectedBeaconSub;
  StreamSubscription<PdrMotionSnapshot>? _motionSub;
  StreamSubscription<RemoteMessage>? _foregroundMessageSub;
  StreamSubscription<RemoteMessage>? _messageOpenedSub;
  StreamSubscription<void>? _volumeUpSub;
  Map<String, BeaconData> _knownBeacons = {};
  EvacuationRouteResult _cachedRouteResult = const EvacuationRouteResult();
  DateTime? _lastLiveLocationWrite;
  DateTime? _lastBeaconDebugUiUpdate;
  DateTime? _lastGuidanceRefreshAt;
  DateTime? _lastRouteRefreshAt;
  Offset? _cachedRouteUserPoint;
  String? _cachedRouteMapId;
  String? _cachedRouteFireId;
  String? _cachedRouteUserBeaconId;
  String? _lastGuidanceBeaconId;
  String? _previousGuidanceBeaconId;
  List<String> _previousGuidanceRouteNodeIds = const [];
  String _activeScanUuids = '';
  String _beaconDebugStatus = 'beacon debug: waiting';
  String? _userId;
  UserGuidanceMode _guidanceMode = UserGuidanceMode.general;
  bool _needsUserId = false;
  bool _savingUserId = false;
  String? _userIdErrorText;
  bool _hasLiveLocationFix = false;
  bool _firePreviouslyActive = false;
  bool _fireAlertAnnouncedForCurrentIncident = false;
  bool _isBrowsingMap = false;
  FireSystemStatus? _fireStatus;
  Timer? _signalWatchdog;
  Timer? _locationWarningTimer;
  bool _locationWarningOpen = false;
  BuildContext? _locationWarningDialogContext;
  String _guidanceText = _noFireGuidanceText;
  String? _lastAnnouncedBeaconId;
  DateTime? _lastGuidanceSpokenAt;
  final Map<String, DateTime> _lastGuidanceKeySpokenAt = {};
  final Map<String, DateTime> _lastBeaconGuidanceSpokenAt = {};
  final Map<String, DateTime> _lastTurnGuidanceSegmentSpokenAt = {};
  String? _lastExitBeaconId;
  DateTime? _lastExitSignalAt;
  bool _homeGuidanceSpoken = false;
  bool _homeBeaconExited = false;
  bool _corridorWallGuidanceSpoken = false;
  bool _evacuated = false;
  bool _bluetoothPrompted = false;
  bool _ttsPlaybackEnabled = true;
  bool _noFireIdleAnnounced = false;
  String? _lastLocationBeaconId;
  String? _pendingLocationBeaconId;
  int _pendingLocationBeaconCount = 0;
  DateTime? _lastFocusVibrationAt;
  FocusDirectionDecision? _lastFocusVibrationDecision;
  final _wrongDirectionTracker = WrongDirectionTracker();
  bool _wrongDirectionActive = false;
  String? _fastWrongDirectionKey;
  double? _lastNextRouteRssi;
  double? _lastOppositeRouteRssi;
  DateTime? _lastFastWrongSampleAt;
  int _fastWrongCandidateCount = 0;
  DateTime? _fastWrongDirectionUntil;
  DateTime? _lastFastWrongAnnouncementAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _signalWatchdog = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _checkSignalHealth(),
    );
    _volumeUpSub = _hardwareButtons.volumeUpEvents.listen(
      (_) => unawaited(_handleVolumeUp()),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_bootstrap());
    });
  }

  Future<void> _bootstrap() async {
    await _tts.initialize();
    final hasUserId = await _ensureUserId();
    if (!hasUserId) return;
    if (!mounted) return;
    await _ensureBluetoothReady(announce: true);
    try {
      final maps = await _data.listCadMaps();
      if (!mounted) return;

      setState(() {
        _availableMaps = maps;
        _loading = false;
        _status = maps.isEmpty
            ? 'Firebase cad_maps 문서가 없습니다.'
            : 'Firebase CAD 지도를 불러왔습니다.';
      });

      if (maps.isNotEmpty) {
        await _selectMap(_preferredMap(maps));
      }

      await _firebase.setupMessaging();
      _foregroundMessageSub = _firebase.foregroundMessages.listen(
        _onForegroundFireMessage,
      );
      _messageOpenedSub = FirebaseMessaging.onMessageOpenedApp.listen(
        _openFireFromMessage,
      );
      unawaited(
        FirebaseMessaging.instance.getInitialMessage().then((message) {
          if (message != null) _openFireFromMessage(message);
        }),
      );
      unawaited(_handleNativeEmergencyLaunch());
      _fireBeaconSub = _firebase.watchFireBeacons().listen(_onFireBeacons);
      _fireStatusSub = _data.watchFireStatus().listen(_onFireStatus);
      _motionSub = _pdr.motionStream.listen(_estimator.updateMotion);
      await _pdr.start();
      _setNoFireIdleState(announce: true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _status = 'Firebase cad_maps 로드 실패: $error';
      });
    }
  }

  Future<bool> _ensureUserId() async {
    if (_userId != null && _userId!.trim().isNotEmpty) return true;
    String? stored;
    try {
      stored = await _identity.loadUserId();
    } catch (error, stackTrace) {
      debugPrint('User id load failed: $error\n$stackTrace');
    }
    if (stored != null) {
      if (mounted) {
        setState(() {
          _userId = stored;
          _needsUserId = false;
        });
      } else {
        _userId = stored;
      }
      return true;
    }

    if (!mounted) {
      _userId = UserIdentityService.defaultUserId;
      return true;
    }

    setState(() {
      _loading = false;
      _needsUserId = true;
      _status = '사용자 ID를 설정하세요.';
      _userIdErrorText = null;
    });
    return false;
  }

  Future<void> _submitInitialUserId() async {
    if (_savingUserId) return;
    final normalized = UserIdentityService.normalizeUserId(
      _userIdController.text,
    );
    if (normalized.isEmpty) {
      setState(() => _userIdErrorText = '영문, 숫자, -, _만 사용할 수 있어요.');
      return;
    }

    setState(() {
      _savingUserId = true;
      _userIdErrorText = null;
    });
    try {
      await _identity.saveUserId(normalized);
    } catch (error, stackTrace) {
      debugPrint('User id save failed: $error\n$stackTrace');
    }
    if (!mounted) return;
    setState(() {
      _userId = normalized;
      _needsUserId = false;
      _savingUserId = false;
      _loading = true;
      _status = 'Firebase CAD 지도를 불러오는 중...';
    });
    unawaited(_bootstrap());
  }

  CadMap _preferredMap(List<CadMap> maps) {
    for (final map in maps) {
      if (map.isFinalMap && map.beacons.isNotEmpty) return map;
    }
    for (final map in maps) {
      final name = '${map.id} ${map.originalFile}'.toLowerCase();
      if (name.contains('tuk_7f') && map.beacons.isNotEmpty) return map;
    }
    for (final map in maps) {
      if (map.beacons.isNotEmpty) return map;
    }
    return maps.first;
  }

  Future<void> _selectMap(CadMap map) async {
    _mapSub?.cancel();
    setState(() {
      _currentMap = map;
      _statusFireBeacon = _routes.resolveFireBeacon(map, _fireStatus);
      _imageUrl = null;
      _status = '${map.originalFile} 변환 이미지를 불러오는 중...';
    });
    _applyFireSources();

    try {
      final imageUrl = await _data.getCadMapImageHttpUrl(map);
      if (!mounted) return;
      setState(() {
        _imageUrl = imageUrl;
        _status = _mapStatus(map);
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _imageUrl = '';
        _status = '변환 이미지 로드 실패: $error';
      });
    }

    _mapSub = _data.watchCadMap(map.id).listen((updated) async {
      if (updated == null || !mounted) return;
      setState(() {
        _currentMap = updated;
        _statusFireBeacon = _routes.resolveFireBeacon(updated, _fireStatus);
        _status = _mapStatus(updated);
      });
      _applyFireSources();

      final sourceChanged =
          updated.imageUrl != map.imageUrl ||
          updated.imagePath != map.imagePath;
      if (sourceChanged) {
        try {
          final imageUrl = await _data.getCadMapImageHttpUrl(updated);
          if (mounted) setState(() => _imageUrl = imageUrl);
        } catch (error) {
          if (mounted) setState(() => _status = '변환 이미지 로드 실패: $error');
        }
      }
    });
    await _startLiveLocalization(map);
  }

  Future<void> _startLiveLocalization(CadMap map) async {
    await _knownBeaconSub?.cancel();
    _knownBeacons = {};
    _activeScanUuids = '';
    _hasLiveLocationFix = false;
    _estimator.reset();
    _signalGuard.reset();
    _lastLiveLocationWrite = null;
    if (mounted) setState(() => _userLocation = null);
    if (_isFireTrackingActive) {
      _armLocationWarning();
    } else {
      _setNoFireIdleState();
    }
    await _ensureBluetoothReady(announce: !_bluetoothPrompted);

    _detectedBeaconSub ??= _beacons.detectedStream.listen(
      (detected) => unawaited(_onDetectedBeacons(detected)),
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('Beacon detection stream error: $error\n$stackTrace');
        _setBeaconDebugStatus('beacon stream error: $error');
      },
    );
    _knownBeaconSub = _firebase.watchBeacons(map.id).listen((beacons) async {
      _knownBeacons = {
        for (final beacon in beacons) beacon.matchKey.toLowerCase(): beacon,
      };
      final uuids = beacons
          .map((beacon) => beacon.uuid.toLowerCase())
          .where((uuid) => uuid.isNotEmpty)
          .toSet()
          .toList();
      final nextScanUuids = uuids.join('|');
      _setBeaconDebugStatus(
        'map=${map.id} known=${beacons.length} uuids=${uuids.join(',')}',
      );
      if (uuids.isEmpty || nextScanUuids == _activeScanUuids) return;

      final bluetoothReady = await _ensureBluetoothReady(
        announce: !_bluetoothPrompted,
      );
      if (!bluetoothReady) return;

      final granted = await _beacons.requestPermissions();
      _setBeaconDebugStatus(
        'map=${map.id} known=${beacons.length} permission=$granted uuids=${uuids.join(',')}',
      );
      if (!granted) return;
      await _beacons.startScanning(uuids);
      _activeScanUuids = nextScanUuids;
      _setBeaconDebugStatus(
        'scanning map=${map.id} known=${beacons.length} uuids=${uuids.join(',')}',
      );
      if (_isFireTrackingActive) {
        if (_guidanceMode.usesTts) await _tts.announceSearchingLocation();
      } else {
        _setNoFireIdleState(announce: true);
      }
    });
  }

  Future<void> _onDetectedBeacons(List<DetectedBeacon> detected) async {
    try {
      _setBeaconDebugStatus(
        'detected=${detected.length} known=${_knownBeacons.length} active=$_activeScanUuids',
      );
      final map = _currentMap;
      if (map == null || _knownBeacons.isEmpty) return;
      if (!_isFireTrackingActive) {
        _setNoFireIdleState();
        return;
      }

      final confirmed = _signalGuard.confirm(detected, _knownBeacons);
      if (confirmed.isEmpty) return;

      final position = _estimator.estimate(confirmed, _knownBeacons);
      var strongest = _strongestKnownBeacon(confirmed);
      if (strongest != null && _homeBeaconExited && _isHomeBeacon(strongest)) {
        strongest =
            _strongestKnownBeacon(confirmed, excludeHomeBeacon: true) ??
            strongest;
      }
      if (position == null || strongest == null) {
        if (_guidanceMode.usesTts) await _tts.announceSearchingLocation();
        return;
      }
      final now = DateTime.now();
      final fireBeacon = _resolveFireBeacon();
      final routeFilteredStrongest = _routeFilteredStrongestBeacon(
        confirmed,
        currentStrongest: strongest,
        previousBeaconId: _lastLocationBeaconId,
      );
      if (routeFilteredStrongest != null) {
        strongest = routeFilteredStrongest;
      }
      strongest = _stabilizedLocationBeacon(strongest);
      final previousLocationBeaconId = _lastLocationBeaconId;
      if (!_homeBeaconExited &&
          _isHomeBeaconId(previousLocationBeaconId) &&
          !_isHomeBeacon(strongest)) {
        _homeBeaconExited = true;
      }
      _lastLocationBeaconId = strongest.id;

      final x = position.x;
      final y = position.y;
      final floorId = position.floorId;
      final beaconId = strongest.id;
      _hasLiveLocationFix = true;
      final liveLocation = UserLiveLocation(
        userId: _userId,
        x: x,
        y: y,
        mapId: map.id,
        floorId: floorId,
        beaconId: beaconId,
      );
      _refreshRouteCache(map, liveLocation, fireBeacon);
      final routeResult = _computeRoute(map, liveLocation, fireBeacon);
      _updateFocusDirectionFeedback(
        routeResult: routeResult,
        currentBeaconId: beaconId,
        detected: confirmed,
        now: now,
      );
      _updateFastWrongDirectionFeedback(
        routeResult: routeResult,
        currentBeaconId: beaconId,
        now: now,
      );
      if (mounted) {
        _locationWarningTimer?.cancel();
        _dismissLocationWarning();
        setState(() => _userLocation = liveLocation);
      }

      final lastWrite = _lastLiveLocationWrite;
      final fireActive = fireBeacon != null;
      final shouldUpload =
          fireActive &&
          (lastWrite == null ||
              now.difference(lastWrite) >= _liveLocationUploadInterval);
      if (shouldUpload) {
        _lastLiveLocationWrite = now;
        final userId = _userId ?? UserIdentityService.defaultUserId;
        unawaited(
          _data
              .updateUserLocation(
                x,
                y,
                userId: userId,
                mapId: map.id,
                floorId: floorId,
                beaconId: beaconId,
              )
              .catchError((Object error) {
                debugPrint('Live location upload failed: $error');
              }),
        );
      }
      if (_shouldUpdateGuidance(strongest.id, now)) {
        _updateGuidanceForBeacon(strongest);
      }
    } catch (error, stackTrace) {
      debugPrint('Detected beacon processing failed: $error\n$stackTrace');
      _setBeaconDebugStatus('beacon processing error: $error');
    }
  }

  Future<bool> _ensureBluetoothReady({required bool announce}) async {
    final enabled = await _hardwareButtons.isBluetoothEnabled();
    if (enabled) return true;

    _bluetoothPrompted = true;
    const message = '블루투스가 꺼져 있습니다. 볼륨 업 키를 한 번 눌러 블루투스를 켜 주세요.';
    if (mounted) {
      setState(() {
        _status = message;
        _guidanceText = message;
      });
    }
    if (announce) {
      if (_guidanceMode.usesTts) await _tts.speak(message, force: true);
    }
    return false;
  }

  Future<void> _handleVolumeUp() async {
    final bluetoothReady = await _hardwareButtons.isBluetoothEnabled();
    if (!bluetoothReady) {
      if (_guidanceMode.usesTts) {
        await _tts.speak('블루투스 설정 화면을 엽니다.', force: true);
      }
      await _hardwareButtons.openBluetoothSettings();
      return;
    }

    if (_isFireTrackingActive) {
      await _handleEmergencyEntry();
      return;
    }

    if (_guidanceMode.usesTts) await _tts.announceNoFireIdle();
  }

  void _updateGuidanceForBeacon(BeaconData beacon) {
    if (_evacuated) return;
    final previousBeaconId = _previousGuidanceBeaconId;
    final fireBeacon = _resolveFireBeacon();
    final user = UserLiveLocation(
      userId: _userId,
      x: beacon.x,
      y: beacon.y,
      mapId: _currentMap?.id,
      floorId: beacon.floorId,
      beaconId: beacon.id,
    );
    final routeResult = _computeRoute(_currentMap, user, fireBeacon);
    final nextBeaconId = _nextRouteBeaconId(beacon.id, routeResult.nodeIds);
    final isHome = _isHomeBeacon(beacon);
    final wasHomeGuidanceSpoken = _homeGuidanceSpoken;
    String? turnSegmentKey;
    final exitTurn = _exitDoorTurnForRoute(
      currentBeaconId: beacon.id,
      nextBeaconId: nextBeaconId,
      destinationId: routeResult.destinationId,
    );
    final now = DateTime.now();
    late final String message;

    final wrongDirection = _wrongDirectionTracker.shouldAnnounceTurnBack(
      previousBeaconId: previousBeaconId,
      currentBeaconId: beacon.id,
      routeNodeIds: routeResult.nodeIds,
      previousRouteNodeIds: _previousGuidanceRouteNodeIds,
      now: now,
    );
    _wrongDirectionActive = wrongDirection;
    if (wrongDirection || _isFastWrongDirectionActive(now)) {
      message = EvacuationGuidanceService.turnBackMessage;
    } else if (isHome) {
      turnSegmentKey = _turnGuidanceSegmentKey(
        beacon.id,
        _afterHomeDoorBeaconId(routeResult.nodeIds) ?? nextBeaconId,
      );
      message = EvacuationGuidanceService.homeExitGuidance(
        fireBeaconId: fireBeacon?.id,
        nextBeaconId: nextBeaconId,
        afterDoorBeaconId: _afterHomeDoorBeaconId(routeResult.nodeIds),
      );
      _homeGuidanceSpoken = true;
    } else if (_arrivedAtDestinationExit(beacon.id, routeResult)) {
      _lastExitBeaconId = beacon.id;
      _lastExitSignalAt = DateTime.now();
      turnSegmentKey = _arrivalTurnSegmentKey(routeResult);
      message = _arrivalExitMessage(routeResult);
    } else if (exitTurn != null) {
      turnSegmentKey = _turnGuidanceSegmentKey(beacon.id, nextBeaconId);
      message = _approachingExitMessage(exitTurn);
    } else if (EvacuationGuidanceService.specificSegmentGuidance(
          currentBeaconId: beacon.id,
          previousBeaconId: previousBeaconId,
          nextBeaconId: nextBeaconId,
        )
        case final specificMessage?) {
      message = specificMessage;
    } else if (!_corridorWallGuidanceSpoken) {
      _corridorWallGuidanceSpoken = true;
      message = EvacuationGuidanceService.corridorGuidance(
        turn: TurnDirection.straight,
        includeWallGuide: true,
      );
    } else {
      message = EvacuationGuidanceService.corridorGuidance(
        turn: TurnDirection.straight,
        includeWallGuide: false,
      );
    }

    if (mounted) {
      setState(() => _guidanceText = message);
    }

    final shouldSpeak = _shouldSpeakGuidance(
      beaconId: beacon.id,
      message: message,
      now: now,
      priority: wrongDirection || beacon.isExit || isHome,
      forceFirstHomeGuidance: isHome && !wasHomeGuidanceSpoken,
      turnSegmentKey: turnSegmentKey,
    );
    if (shouldSpeak) {
      _lastAnnouncedBeaconId = beacon.id;
      unawaited(_tts.speak(message, force: beacon.isExit || isHome));
    }
    if (previousBeaconId != beacon.id) {
      _previousGuidanceBeaconId = beacon.id;
    }
    _previousGuidanceRouteNodeIds = routeResult.nodeIds;
  }

  bool _shouldSpeakGuidance({
    required String beaconId,
    required String message,
    required DateTime now,
    required bool priority,
    bool forceFirstHomeGuidance = false,
    String? turnSegmentKey,
  }) {
    final normalizedBeacon = _normalizeBeaconId(beaconId);
    if (!_guidanceMode.usesTts) return false;
    if (turnSegmentKey != null) {
      final lastTurn = _lastTurnGuidanceSegmentSpokenAt[turnSegmentKey];
      if (!forceFirstHomeGuidance &&
          lastTurn != null &&
          now.difference(lastTurn) < _turnGuidanceSegmentCooldown) {
        return false;
      }
    }
    final key = '$normalizedBeacon|$message';
    final lastSameMessage = _lastGuidanceKeySpokenAt[key];
    if (!forceFirstHomeGuidance &&
        lastSameMessage != null &&
        now.difference(lastSameMessage) < _sameGuidanceSpeechCooldown) {
      return false;
    }

    final lastSpoken = _lastGuidanceSpokenAt;
    final minGap = priority
        ? _priorityGuidanceSpeechGap
        : _regularGuidanceSpeechGap;
    if (!forceFirstHomeGuidance &&
        lastSpoken != null &&
        now.difference(lastSpoken) < minGap) {
      return false;
    }

    final lastBeaconSpoken = _lastBeaconGuidanceSpokenAt[normalizedBeacon];
    if (!priority &&
        lastBeaconSpoken != null &&
        now.difference(lastBeaconSpoken) < _sameBeaconSpeechCooldown) {
      return false;
    }

    _lastGuidanceSpokenAt = now;
    _lastGuidanceKeySpokenAt[key] = now;
    _lastBeaconGuidanceSpokenAt[normalizedBeacon] = now;
    if (turnSegmentKey != null) {
      _lastTurnGuidanceSegmentSpokenAt[turnSegmentKey] = now;
    }
    return true;
  }

  bool _isStraightCorridorMessage(String message) {
    return message.contains('정면') || message.contains('직진');
  }

  String? _nextRouteBeaconId(
    String currentBeaconId,
    List<String> routeNodeIds,
  ) {
    final current = _normalizeBeaconId(currentBeaconId);
    final nodes = routeNodeIds
        .map(_normalizeBeaconId)
        .where((id) => id.isNotEmpty)
        .toList();
    final index = nodes.indexOf(current);
    if (index >= 0 && index + 1 < nodes.length) return nodes[index + 1];
    if (index < 0 && nodes.length >= 2) return nodes[1];
    return null;
  }

  String? _turnGuidanceSegmentKey(String? fromBeaconId, String? toBeaconId) {
    final from = _normalizeBeaconId(fromBeaconId);
    final to = _normalizeBeaconId(toBeaconId);
    if (from.isEmpty || to.isEmpty || from == to) return null;
    return '$from>$to';
  }

  String? _arrivalTurnSegmentKey(EvacuationRouteResult routeResult) {
    final nodes = routeResult.nodeIds
        .map(_normalizeBeaconId)
        .where((id) => id.isNotEmpty)
        .toList(growable: false);
    final destination = _normalizeBeaconId(routeResult.destinationId);
    final destinationIndex = nodes.indexOf(destination);
    if (destinationIndex <= 0) return null;
    return _turnGuidanceSegmentKey(nodes[destinationIndex - 1], destination);
  }

  String? _afterHomeDoorBeaconId(List<String> routeNodeIds) {
    final nodes = routeNodeIds
        .map(_normalizeBeaconId)
        .where((id) => id.isNotEmpty)
        .toList(growable: false);
    final doorIndex = nodes.indexOf('b04');
    if (doorIndex >= 0 && doorIndex + 1 < nodes.length) {
      return nodes[doorIndex + 1];
    }
    return null;
  }

  void _updateFocusDirectionFeedback({
    required EvacuationRouteResult routeResult,
    required String currentBeaconId,
    required List<DetectedBeacon> detected,
    required DateTime now,
  }) {
    if (!_isFireTrackingActive || routeResult.nodeIds.isEmpty) return;
    if (_isHomeBeaconId(currentBeaconId)) return;

    final nextBeaconId = _nextRouteBeaconId(
      currentBeaconId,
      routeResult.nodeIds,
    );
    final target = _knownBeaconById(nextBeaconId);
    if (target == null) return;

    final snapshot = _focusDirection.update(
      targetBeacon: target,
      detected: detected,
      filteredRssiFor: _estimator.filteredRssiFor,
      now: now,
    );
    _applyFocusFeedback(snapshot, now);
  }

  void _updateFastWrongDirectionFeedback({
    required EvacuationRouteResult routeResult,
    required String currentBeaconId,
    required DateTime now,
  }) {
    if (!_isFireTrackingActive || routeResult.nodeIds.isEmpty) {
      _resetFastWrongDirectionCandidate();
      return;
    }
    if (_isHomeBeaconId(currentBeaconId) ||
        !_isCorridorBeaconId(currentBeaconId)) {
      _resetFastWrongDirectionCandidate();
      return;
    }

    final nextBeaconId = _nextRouteBeaconId(
      currentBeaconId,
      routeResult.nodeIds,
    );
    final oppositeBeaconId = _oppositeCorridorBeaconId(
      currentBeaconId,
      nextBeaconId,
    );
    final nextBeacon = _knownBeaconById(nextBeaconId);
    final oppositeBeacon = _knownBeaconById(oppositeBeaconId);
    if (nextBeacon == null || oppositeBeacon == null) {
      _resetFastWrongDirectionCandidate();
      return;
    }

    final sampleGap = _lastFastWrongSampleAt == null
        ? null
        : now.difference(_lastFastWrongSampleAt!);
    if (sampleGap != null && sampleGap < const Duration(milliseconds: 450)) {
      return;
    }
    _lastFastWrongSampleAt = now;

    final nextRssi = _estimator.filteredRssiFor(nextBeacon.matchKey);
    final oppositeRssi = _estimator.filteredRssiFor(oppositeBeacon.matchKey);
    if (nextRssi == null || oppositeRssi == null) return;

    final key =
        '${_normalizeBeaconId(currentBeaconId)}>${_normalizeBeaconId(nextBeaconId)}<${_normalizeBeaconId(oppositeBeaconId)}';
    if (_fastWrongDirectionKey != key) {
      _fastWrongDirectionKey = key;
      _lastNextRouteRssi = nextRssi;
      _lastOppositeRouteRssi = oppositeRssi;
      _fastWrongCandidateCount = 0;
      return;
    }

    final previousNext = _lastNextRouteRssi;
    final previousOpposite = _lastOppositeRouteRssi;
    _lastNextRouteRssi = nextRssi;
    _lastOppositeRouteRssi = oppositeRssi;
    if (previousNext == null || previousOpposite == null) return;

    final nextDelta = nextRssi - previousNext;
    final oppositeDelta = oppositeRssi - previousOpposite;
    final wrongCandidate =
        oppositeDelta >= 1.0 &&
        nextDelta <= 0.4 &&
        oppositeDelta - nextDelta >= 1.2;

    if (!wrongCandidate) {
      _fastWrongCandidateCount = 0;
      return;
    }

    _fastWrongCandidateCount += 1;
    if (_fastWrongCandidateCount < 2) return;

    _fastWrongDirectionUntil = now.add(const Duration(seconds: 4));
    _fastWrongCandidateCount = 0;
    _announceConfirmedWrongDirection(now);
  }

  String? _oppositeCorridorBeaconId(
    String currentBeaconId,
    String? nextBeaconId,
  ) {
    final current = _normalizeBeaconId(currentBeaconId);
    final next = _normalizeBeaconId(nextBeaconId);
    if (current.isEmpty || next.isEmpty) return null;
    for (final (a, b) in _corridorEdges) {
      if (a == current && b != next) return b;
      if (b == current && a != next) return a;
    }
    return null;
  }

  bool _isFastWrongDirectionActive(DateTime now) {
    final until = _fastWrongDirectionUntil;
    return until != null && now.isBefore(until);
  }

  void _resetFastWrongDirectionCandidate() {
    _fastWrongDirectionKey = null;
    _lastNextRouteRssi = null;
    _lastOppositeRouteRssi = null;
    _lastFastWrongSampleAt = null;
    _fastWrongCandidateCount = 0;
  }

  void _announceConfirmedWrongDirection(DateTime now) {
    final last = _lastFastWrongAnnouncementAt;
    if (last != null && now.difference(last) < const Duration(seconds: 4)) {
      return;
    }
    _lastFastWrongAnnouncementAt = now;
    const message = EvacuationGuidanceService.turnBackMessage;
    if (mounted) {
      setState(() => _guidanceText = message);
    }
    if (_guidanceMode.usesVibration) {
      unawaited(_hardwareButtons.vibrate('strong'));
    }
    if (_guidanceMode.usesTts) {
      unawaited(_tts.speak(message, force: true));
    }
  }

  BeaconData? _knownBeaconById(String? beaconId) {
    final normalized = _normalizeBeaconId(beaconId ?? '');
    if (normalized.isEmpty) return null;
    for (final beacon in _knownBeacons.values) {
      final keys = [
        beacon.id,
        beacon.name,
        beacon.label,
        beacon.displayLabel,
      ].map(_normalizeBeaconId);
      if (keys.contains(normalized)) return beacon;
    }
    return null;
  }

  void _applyFocusFeedback(FocusDirectionSnapshot snapshot, DateTime now) {
    final decision = snapshot.decision;
    if (decision == FocusDirectionDecision.correct ||
        decision == FocusDirectionDecision.searching ||
        decision == FocusDirectionDecision.uncertain ||
        decision == FocusDirectionDecision.wrongCandidate) {
      return;
    }

    final lastAt = _lastFocusVibrationAt;
    final sameDecision = _lastFocusVibrationDecision == decision;
    if (sameDecision &&
        lastAt != null &&
        now.difference(lastAt) < const Duration(seconds: 3)) {
      return;
    }

    _lastFocusVibrationAt = now;
    _lastFocusVibrationDecision = decision;
    if (_guidanceMode.usesVibration) {
      unawaited(_hardwareButtons.vibrate('strong'));
    }
    if (_guidanceMode.usesVisual && mounted) {
      setState(() => _guidanceText = EvacuationGuidanceService.turnBackMessage);
    }
    if (_guidanceMode.usesTts) {
      unawaited(
        _tts.speak(EvacuationGuidanceService.turnBackMessage, force: true),
      );
    }
  }

  String _normalizeBeaconId(String? value) {
    if (value == null) return '';
    final match = RegExp(r'[a-zA-Z]+\s*0*\d+|h\s*708|h').firstMatch(value);
    final raw = (match?.group(0) ?? value).trim().toLowerCase();
    final letter = RegExp(r'^[a-z]+').stringMatch(raw) ?? '';
    final digits = RegExp(r'\d+').stringMatch(raw);
    if (letter.isEmpty) return raw.replaceAll(RegExp(r'\s+'), '');
    if (digits == null) return letter;
    return '$letter${digits.padLeft(2, '0')}';
  }

  bool _shouldUpdateGuidance(String beaconId, DateTime now) {
    final lastRefresh = _lastGuidanceRefreshAt;
    final changedBeacon = _lastGuidanceBeaconId != beaconId;
    final stale =
        lastRefresh == null ||
        now.difference(lastRefresh) >= _guidanceRefreshInterval;
    if (!changedBeacon && !stale) return false;
    _lastGuidanceBeaconId = beaconId;
    _lastGuidanceRefreshAt = now;
    return true;
  }

  bool _isHomeBeacon(BeaconData beacon) {
    final source =
        '${beacon.id} ${beacon.name} ${beacon.label} ${beacon.displayLabel}'
            .toLowerCase();
    return beacon.id.toLowerCase() == 'h' ||
        beacon.name.toLowerCase() == 'h' ||
        source.contains('708') ||
        source.contains('거주') ||
        source.contains('강의실');
  }

  bool _isHomeBeaconId(String? beaconId) {
    if (beaconId == null || beaconId.trim().isEmpty) return false;
    final normalized = _normalizeBeaconId(beaconId);
    return normalized == 'h' || normalized == 'h708';
  }

  bool _isCorridorBeaconId(String? beaconId) {
    final normalized = _normalizeBeaconId(beaconId);
    return RegExp(r'^b\d+$').hasMatch(normalized);
  }

  void _markEvacuatedFromExit() {
    if (_lastExitBeaconId == null) return;
    final seenAt = _lastExitSignalAt;
    if (seenAt == null ||
        DateTime.now().difference(seenAt) > const Duration(seconds: 12)) {
      return;
    }

    const message = '비상구로 대피하였습니다. 1층으로 이동 및 밖으로 대피하세요';
    setState(() {
      _guidanceText = message;
    });
    if (_guidanceMode.usesTts) {
      unawaited(_tts.speak(message, force: true));
    }
  }

  void _checkSignalHealth() {
    if (!mounted ||
        !_isFireTrackingActive ||
        _userLocation == null ||
        _signalGuard.isSignalAlive()) {
      return;
    }
    _markEvacuatedFromExit();
    if (_evacuated) return;
    _hasLiveLocationFix = false;
    _estimator.reset();
    if (!_isFireTrackingActive) {
      _clearRouteCache(mapId: _currentMap?.id, fireId: null);
    }
    setState(() => _userLocation = null);
    _setBeaconDebugStatus('beacon signal lost; location cleared');
    _armLocationWarning();
  }

  void _armLocationWarning() {
    _locationWarningTimer?.cancel();
    if (!_isFireTrackingActive) return;
    _locationWarningTimer = Timer(const Duration(seconds: 20), () {
      if (!mounted ||
          !_isFireTrackingActive ||
          _userLocation != null ||
          _locationWarningOpen) {
        return;
      }
      unawaited(_showLocationWarning());
    });
  }

  Future<void> _showLocationWarning() async {
    if (!_isFireTrackingActive) return;
    _locationWarningOpen = true;
    const message = '위치를 찾지 못했습니다. 몇 걸음 움직여 주세요.';
    if (_guidanceMode.usesTts) {
      unawaited(_tts.speak(message, force: true));
    }
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Color(0xFFFBBF24),
          size: 42,
        ),
        title: const Text('위치를 찾지 못했습니다'),
        content: Builder(
          builder: (context) {
            _locationWarningDialogContext = dialogContext;
            return const Text(
              '위치를 찾지 못했습니다.\n몇 걸음 움직여 주세요.',
              textAlign: TextAlign.center,
            );
          },
        ),
      ),
    );
    _locationWarningDialogContext = null;
    _locationWarningOpen = false;
    if (mounted && _isFireTrackingActive && _userLocation == null) {
      _armLocationWarning();
    }
  }

  void _dismissLocationWarning() {
    final dialogContext = _locationWarningDialogContext;
    if (!_locationWarningOpen || dialogContext == null) return;
    Navigator.of(dialogContext).pop();
  }

  BeaconData? _strongestKnownBeacon(
    List<DetectedBeacon> detected, {
    bool excludeHomeBeacon = false,
    Set<String> allowedBeaconIds = const {},
  }) {
    BeaconData? best;
    var bestRssi = -1000;
    for (final item in detected) {
      final beacon = _knownBeacons[item.matchKey.toLowerCase()];
      if (beacon == null) continue;
      if (excludeHomeBeacon && _isHomeBeacon(beacon)) continue;
      if (allowedBeaconIds.isNotEmpty &&
          !_knownBeaconMatchesAnyId(beacon, allowedBeaconIds)) {
        continue;
      }
      if (item.rssi > bestRssi) {
        bestRssi = item.rssi;
        best = beacon;
      }
    }
    return best;
  }

  BeaconData? _routeFilteredStrongestBeacon(
    List<DetectedBeacon> detected, {
    required BeaconData currentStrongest,
    required String? previousBeaconId,
  }) {
    if (!_isFireTrackingActive || _cachedRouteResult.nodeIds.isEmpty) {
      return null;
    }

    final routeIds = _cachedRouteResult.nodeIds
        .map(_normalizeBeaconId)
        .where((id) => id.isNotEmpty)
        .toSet();
    if (routeIds.isEmpty) return null;

    final currentId = _normalizeBeaconId(currentStrongest.id);
    if (_knownBeaconMatchesAnyId(currentStrongest, routeIds) &&
        !(_homeBeaconExited && _isHomeBeacon(currentStrongest))) {
      return null;
    }

    final routeStrongest = _strongestKnownBeacon(
      detected,
      excludeHomeBeacon: _homeBeaconExited,
      allowedBeaconIds: routeIds,
    );
    if (routeStrongest == null) {
      final previous = _knownBeaconById(previousBeaconId);
      if (previous != null &&
          _knownBeaconMatchesAnyId(previous, routeIds) &&
          !(_homeBeaconExited && _isHomeBeacon(previous))) {
        return previous;
      }
      return null;
    }

    final routeId = _normalizeBeaconId(routeStrongest.id);
    if (routeId == currentId) return null;

    return routeStrongest;
  }

  BeaconData _stabilizedLocationBeacon(BeaconData candidate) {
    final candidateId = _normalizeBeaconId(candidate.id);
    final currentId = _normalizeBeaconId(_lastLocationBeaconId);
    if (candidateId.isEmpty || currentId.isEmpty || candidateId == currentId) {
      _resetPendingLocationBeacon();
      return candidate;
    }

    if (_pendingLocationBeaconId != candidateId) {
      _pendingLocationBeaconId = candidateId;
      _pendingLocationBeaconCount = 1;
    } else {
      _pendingLocationBeaconCount += 1;
    }

    if (_pendingLocationBeaconCount < _beaconSwitchConfirmations) {
      return _knownBeaconById(currentId) ?? candidate;
    }

    _resetPendingLocationBeacon();
    return candidate;
  }

  void _resetPendingLocationBeacon() {
    _pendingLocationBeaconId = null;
    _pendingLocationBeaconCount = 0;
  }

  bool _knownBeaconMatchesAnyId(BeaconData beacon, Set<String> normalizedIds) {
    final keys = [
      beacon.id,
      beacon.name,
      beacon.label,
      beacon.displayLabel,
    ].map(_normalizeBeaconId);
    return keys.any(normalizedIds.contains);
  }

  void _setBeaconDebugStatus(String value) {
    final now = DateTime.now();
    final lastUpdate = _lastBeaconDebugUiUpdate;
    final shouldUpdateUi =
        lastUpdate == null ||
        now.difference(lastUpdate) >= _debugStatusUiInterval;
    if (shouldUpdateUi) {
      _lastBeaconDebugUiUpdate = now;
      debugPrint('[FIEVA BLE] $value');
    }
    if (!mounted) return;
    if (shouldUpdateUi) {
      setState(() => _beaconDebugStatus = value);
    } else {
      _beaconDebugStatus = value;
    }
  }

  String _mapStatus(CadMap map) {
    return '${map.originalFile} / 비콘 ${map.beacons.length}개 / 출구 ${map.exitCount}개';
  }

  void _onFireBeacons(List<BeaconData> fireBeacons) {
    if (!mounted) return;
    _hardwareFireBeacon = _resolveFireBeaconFromLiveBeacons(fireBeacons);
    _applyFireSources();
  }

  void _onFireStatus(FireSystemStatus status) {
    if (!mounted) return;
    _fireStatus = status;
    _statusFireBeacon = _routes.resolveFireBeacon(_currentMap, status);
    _applyFireSources();
  }

  void _applyFireSources() {
    if (!mounted) return;
    final fireBeacon = _statusFireBeacon ?? _hardwareFireBeacon;
    final isFire = fireBeacon != null || _fireStatus?.isFire == true;
    final fireChanged = _fireBeacon?.id != fireBeacon?.id;
    if (fireChanged) {
      _lastGuidanceBeaconId = null;
      _previousGuidanceBeaconId = null;
      _previousGuidanceRouteNodeIds = const [];
      _lastLocationBeaconId = null;
      _resetPendingLocationBeacon();
      _homeBeaconExited = false;
      _focusDirection.reset();
      _lastFocusVibrationAt = null;
      _lastFocusVibrationDecision = null;
      _lastGuidanceSpokenAt = null;
      _lastGuidanceKeySpokenAt.clear();
      _lastBeaconGuidanceSpokenAt.clear();
      _lastTurnGuidanceSegmentSpokenAt.clear();
      _resetFastWrongDirectionCandidate();
      _fastWrongDirectionUntil = null;
      _lastFastWrongAnnouncementAt = null;
      _wrongDirectionTracker.markCorrected();
    }
    final map = _currentMap;
    final user = map == null ? null : _userLocationForMap(map);
    if (fireChanged) {
      _clearRouteCache(mapId: map?.id, fireId: fireBeacon?.id);
    }
    _refreshRouteCache(map, user, fireBeacon);
    setState(() {
      _fireBeacon = fireBeacon;
      if (!isFire) {
        _guidanceText = _noFireGuidanceText;
        _userLocation = null;
        _hasLiveLocationFix = false;
      } else if (_guidanceText == _noFireGuidanceText) {
        _guidanceText = TtsService.searchingLocationMessage;
      }
    });
    if (isFire && !_firePreviouslyActive) {
      _noFireIdleAnnounced = false;
      _armLocationWarning();
      unawaited(_emergencyAlerts.startFireAlert());
      _announceFireOnce();
    } else if (!isFire) {
      _fireAlertAnnouncedForCurrentIncident = false;
      unawaited(_emergencyAlerts.stopFireAlert());
      _setNoFireIdleState(announce: !_noFireIdleAnnounced);
    }
    _firePreviouslyActive = isFire;
  }

  bool get _isFireTrackingActive {
    return _resolveFireBeacon() != null || _fireStatus?.isFire == true;
  }

  void _setNoFireIdleState({bool announce = false}) {
    if (_isFireTrackingActive) return;
    _locationWarningTimer?.cancel();
    _dismissLocationWarning();
    _lastLiveLocationWrite = null;
    _lastLocationBeaconId = null;
    _resetPendingLocationBeacon();
    _homeBeaconExited = false;
    _hasLiveLocationFix = false;
    _estimator.reset();
    _signalGuard.reset();
    _focusDirection.reset();
    _lastFocusVibrationAt = null;
    _lastFocusVibrationDecision = null;
    _lastTurnGuidanceSegmentSpokenAt.clear();
    _resetFastWrongDirectionCandidate();
    _fastWrongDirectionUntil = null;
    _lastFastWrongAnnouncementAt = null;
    _clearRouteCache(mapId: _currentMap?.id, fireId: null);
    if (mounted) {
      setState(() {
        _userLocation = null;
        _guidanceText = _noFireGuidanceText;
      });
    } else {
      _userLocation = null;
      _guidanceText = _noFireGuidanceText;
    }
    if (announce && !_noFireIdleAnnounced) {
      _noFireIdleAnnounced = true;
      if (_guidanceMode.usesTts) unawaited(_tts.announceNoFireIdle());
    }
  }

  void _onForegroundFireMessage(RemoteMessage message) {
    if (!mounted) return;
    unawaited(_emergencyAlerts.startFireAlert());
    _announceFireOnce();
    final notification = message.notification;
    final title = notification?.title ?? '화재 경보';
    final body = notification?.body ?? '화재가 감지되었습니다. 즉시 대피하세요.';
    _showFireMessage(title: title, body: body);
  }

  void _showFireMessage({required String title, required String body}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title\n$body'),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 6),
      ),
    );
  }

  void _openFireFromMessage(RemoteMessage message) {
    unawaited(_handleEmergencyEntry());
  }

  Future<void> _handleNativeEmergencyLaunch() async {
    final launchedForEmergency = await _emergencyAlerts
        .consumeEmergencyLaunch();
    if (!launchedForEmergency) return;
    _showFireMessage(title: '화재 경보', body: '화재가 감지되었습니다. 즉시 대피하세요.');
    await _handleEmergencyEntry();
  }

  Future<void> _handleEmergencyEntry() async {
    _announceFireOnce();
    if (!mounted) return;
    if (_userLocation != null) {
      _mapController.focusOnUser();
    }
  }

  void _announceFireOnce() {
    if (_fireAlertAnnouncedForCurrentIncident) return;
    _fireAlertAnnouncedForCurrentIncident = true;
    if (_guidanceMode.usesTts) unawaited(_tts.announceFire());
  }

  CadMapBeacon? _resolveFireBeacon() {
    return _fireBeacon;
  }

  CadMapBeacon? _resolveFireBeaconFromLiveBeacons(List<BeaconData> fires) {
    final map = _currentMap;
    if (map == null || map.beacons.isEmpty || fires.isEmpty) return null;

    for (final fire in fires) {
      final byId = _beaconById(map, fire.id);
      if (byId != null) return byId;
      final byNumber = _beaconByNumber(map, fire.id);
      if (byNumber != null) return byNumber;
    }

    final first = fires.first;
    return CadMapBeacon(id: first.id, x: first.x, y: first.y);
  }

  CadMapBeacon? _beaconByNumber(CadMap map, String id) {
    final digits = RegExp(r'\d+').firstMatch(id)?.group(0);
    if (digits == null) return null;
    final index = int.tryParse(digits);
    if (index == null || index <= 0 || index > map.beacons.length) return null;
    return map.beacons[index - 1];
  }

  EvacuationRouteResult _computeRoute(
    CadMap? map,
    UserLiveLocation? user,
    CadMapBeacon? fireBeacon,
  ) {
    final mapId = map?.id;
    if (map == null || user == null) {
      if (fireBeacon == null &&
          (_cachedRouteMapId != mapId ||
              _cachedRouteUserPoint != null ||
              _cachedRouteResult.points.isNotEmpty)) {
        _clearRouteCache(mapId: mapId, fireId: fireBeacon?.id);
      }
      return _cachedRouteResult;
    }

    if (_cachedRouteMapId != map.id ||
        _cachedRouteFireId != fireBeacon?.id ||
        _cachedRouteResult.points.isEmpty) {
      _refreshRouteCache(map, user, fireBeacon);
    }
    return _cachedRouteResult;
  }

  void _refreshRouteCache(
    CadMap? map,
    UserLiveLocation? user,
    CadMapBeacon? fireBeacon,
  ) {
    if (map == null || user == null) {
      if (fireBeacon == null) {
        _clearRouteCache(mapId: map?.id, fireId: null);
      }
      return;
    }

    final userPoint = Offset(user.x, user.y);
    final fireId = fireBeacon?.id;
    final beaconId = user.beaconId;
    final mapChanged = _cachedRouteMapId != map.id;
    final fireChanged = _cachedRouteFireId != fireId;
    final currentBeaconOffRoute =
        beaconId != null &&
        beaconId.trim().isNotEmpty &&
        !_routeContainsBeacon(_cachedRouteResult.nodeIds, beaconId);
    final shouldRefresh =
        mapChanged ||
        fireChanged ||
        _cachedRouteResult.points.isEmpty ||
        fireBeacon == null ||
        currentBeaconOffRoute;

    if (!shouldRefresh) return;

    _cachedRouteResult = _routes.evaluate(
      map: map,
      user: user,
      fireBeacon: fireBeacon,
    );
    _cachedRouteMapId = map.id;
    _cachedRouteFireId = fireId;
    _cachedRouteUserBeaconId = beaconId;
    _cachedRouteUserPoint = userPoint;
    _lastRouteRefreshAt = DateTime.now();
  }

  bool _routeContainsBeacon(List<String> nodeIds, String beaconId) {
    final target = _normalizeBeaconId(beaconId);
    if (target.isEmpty) return false;
    return nodeIds.map(_normalizeBeaconId).contains(target);
  }

  void _clearRouteCache({String? mapId, String? fireId}) {
    _cachedRouteResult = const EvacuationRouteResult();
    _cachedRouteMapId = mapId;
    _cachedRouteFireId = fireId;
    _cachedRouteUserBeaconId = null;
    _cachedRouteUserPoint = null;
    _lastRouteRefreshAt = null;
  }

  EvacuationRouteResult _displayRouteForCurrentUser(
    EvacuationRouteResult routeResult,
    UserLiveLocation? user,
  ) {
    final map = _currentMap;
    if (map == null || user == null || !routeResult.hasRoute) {
      return routeResult;
    }

    final userPoint = Offset(user.x, user.y);
    final remainingIds = _remainingRouteNodeIds(
      routeResult.nodeIds,
      user.beaconId,
    );
    final points = <Offset>[userPoint];
    for (final id in remainingIds) {
      final beacon = _beaconById(map, id);
      if (beacon == null) continue;
      final point = Offset(beacon.x, beacon.y);
      if (_offsetDistance(points.last, point) > 1) points.add(point);
    }
    if (points.length == 1) points.add(points.first);

    return EvacuationRouteResult(
      points: points,
      nodeIds: routeResult.nodeIds,
      distanceCad: _routeDistanceCad(points),
      destinationId: routeResult.destinationId,
    );
  }

  List<String> _remainingRouteNodeIds(List<String> nodeIds, String? beaconId) {
    final current = _normalizeBeaconId(beaconId);
    if (current.isEmpty) return nodeIds.skip(1).toList(growable: false);

    final normalized = nodeIds.map(_normalizeBeaconId).toList(growable: false);
    final index = normalized.indexOf(current);
    if (index < 0) return nodeIds.skip(1).toList(growable: false);
    return nodeIds.skip(index + 1).toList(growable: false);
  }

  UserLiveLocation? _clampedUserLocationForRoute(
    UserLiveLocation? user,
    EvacuationRouteResult routeResult,
  ) {
    final map = _currentMap;
    if (map == null || user == null || !_isCorridorBeaconId(user.beaconId)) {
      return user;
    }

    final segments = <(Offset, Offset)>[];
    for (var i = 0; i + 1 < routeResult.nodeIds.length; i++) {
      final aId = routeResult.nodeIds[i];
      final bId = routeResult.nodeIds[i + 1];
      if (!_isCorridorBeaconId(aId) || !_isCorridorBeaconId(bId)) continue;
      final a = _beaconById(map, aId);
      final b = _beaconById(map, bId);
      if (a == null || b == null) continue;
      segments.add((Offset(a.x, a.y), Offset(b.x, b.y)));
    }
    if (segments.isEmpty) return user;

    final raw = Offset(user.x, user.y);
    Offset? best;
    var bestDistance = double.infinity;
    for (final (a, b) in segments) {
      final projected = _projectPointToSegment(raw, a, b);
      final distance = _offsetDistance(raw, projected);
      if (distance < bestDistance) {
        best = projected;
        bestDistance = distance;
      }
    }
    if (best == null) return user;
    return UserLiveLocation(
      userId: user.userId,
      x: best.dx,
      y: best.dy,
      lastUpdated: user.lastUpdated,
      status: user.status,
      mapId: user.mapId,
      floorId: user.floorId,
      beaconId: user.beaconId,
    );
  }

  UserLiveLocation? _userLocationForMap(CadMap map) {
    final user = _userLocation;
    if (user == null) return null;

    final mapId = user.mapId;
    if (mapId != null && mapId.isNotEmpty && mapId != map.id) {
      return null;
    }

    if (!_isPointInsideMap(map, user.x, user.y)) return null;
    return user;
  }

  bool _isPointInsideMap(CadMap map, double x, double y) {
    return _routes.isPointInsideMap(map, x, y);
  }

  double _distance(double ax, double ay, double bx, double by) {
    final dx = ax - bx;
    final dy = ay - by;
    return math.sqrt(dx * dx + dy * dy);
  }

  double _offsetDistance(Offset a, Offset b) {
    return _distance(a.dx, a.dy, b.dx, b.dy);
  }

  Offset _projectPointToSegment(Offset point, Offset a, Offset b) {
    final dx = b.dx - a.dx;
    final dy = b.dy - a.dy;
    final lengthSquared = dx * dx + dy * dy;
    if (lengthSquared <= 0) return a;
    final t =
        (((point.dx - a.dx) * dx) + ((point.dy - a.dy) * dy)) / lengthSquared;
    final clamped = t.clamp(0.0, 1.0).toDouble();
    return Offset(a.dx + dx * clamped, a.dy + dy * clamped);
  }

  double _routeDistanceCad(List<Offset> route) {
    return _routes.routeDistanceCad(route);
  }

  double _cadUnitsToMeters(double cadUnits) {
    return cadUnits / 1000;
  }

  NavStep? _currentStep(List<Offset> route, double remainingMeters) {
    if (route.length < 2) return null;
    final from = route.first;
    final to = route[1];
    return NavStep(
      from: RouteNode(
        id: 'user',
        x: from.dx,
        y: from.dy,
        floorId: _currentMap?.id ?? '',
      ),
      to: RouteNode(
        id: route.length == 2 ? 'exit' : 'next',
        x: to.dx,
        y: to.dy,
        floorId: _currentMap?.id ?? '',
      ),
      distance: _cadUnitsToMeters(_offsetDistance(from, to)),
      bearing: _bearing(from, to),
      turn: _screenTurn(from, to),
    );
  }

  NavStep? _displayStep({
    required List<Offset> route,
    required double remainingMeters,
    required UserLiveLocation? user,
    required EvacuationRouteResult routeResult,
  }) {
    if (route.length < 2 || user == null) {
      return _currentStep(route, remainingMeters);
    }

    if (_wrongDirectionActive || _isFastWrongDirectionActive(DateTime.now())) {
      return _stepForTurn(user, TurnDirection.uTurn);
    }

    final currentBeaconId = _normalizeBeaconId(user.beaconId);
    if (_arrivedAtDestinationExit(user.beaconId, routeResult)) {
      return _stepForTurn(user, TurnDirection.arrive);
    }

    if (_isHomeBeaconId(user.beaconId)) {
      return _stepForTurn(user, _homeExitTurn(routeResult.nodeIds));
    }

    final nextBeaconId = user.beaconId == null
        ? null
        : _nextRouteBeaconId(user.beaconId!, routeResult.nodeIds);
    final exitTurn = _exitDoorTurnForRoute(
      currentBeaconId: currentBeaconId,
      nextBeaconId: nextBeaconId,
      destinationId: routeResult.destinationId,
    );
    if (exitTurn != null) {
      return _stepForTurn(user, exitTurn);
    }

    return _stepForTurn(user, TurnDirection.straight);
  }

  NavStep _stepForTurn(UserLiveLocation user, TurnDirection turn) {
    return NavStep(
      from: RouteNode(
        id: user.beaconId ?? 'user',
        x: user.x,
        y: user.y,
        floorId: _currentMap?.id ?? '',
      ),
      to: RouteNode(
        id: 'guidance',
        x: user.x,
        y: user.y,
        floorId: _currentMap?.id ?? '',
        isExit: turn == TurnDirection.arrive,
      ),
      distance: 0,
      bearing: 0,
      turn: turn,
    );
  }

  TurnDirection _homeExitTurn(List<String> routeNodeIds) {
    final afterDoor = _normalizeBeaconId(_afterHomeDoorBeaconId(routeNodeIds));
    final number = int.tryParse(RegExp(r'\d+').stringMatch(afterDoor) ?? '');
    if (afterDoor.startsWith('b') && number != null) {
      if (number >= 1 && number <= 3) return TurnDirection.left;
      if (number >= 5 && number <= 12) return TurnDirection.right;
    }
    final fire = _normalizeBeaconId(_resolveFireBeacon()?.id);
    final fireNumber = int.tryParse(RegExp(r'\d+').stringMatch(fire) ?? '');
    if (fire.startsWith('b') && fireNumber != null) {
      if (fireNumber >= 1 && fireNumber <= 3) return TurnDirection.right;
      if (fireNumber >= 4 && fireNumber <= 12) return TurnDirection.left;
    }
    return TurnDirection.straight;
  }

  TurnDirection? _exitDoorTurnForRoute({
    required String currentBeaconId,
    required String? nextBeaconId,
    required String destinationId,
  }) {
    final current = _normalizeBeaconId(currentBeaconId);
    final next = _normalizeBeaconId(nextBeaconId);
    final destination = _normalizeBeaconId(destinationId);
    if (next.isEmpty || next != destination) return null;
    final map = _currentMap;
    if (map == null) return null;
    final destinationBeacon = _beaconById(map, destination);
    if (destinationBeacon?.isExit != true) return null;
    return _exitApproachTurns['$current>$next'] ??
        _exitDoorTurnForCadBeacon(destinationBeacon);
  }

  bool _arrivedAtDestinationExit(
    String? currentBeaconId,
    EvacuationRouteResult routeResult,
  ) {
    final current = _normalizeBeaconId(currentBeaconId);
    final destination = _normalizeBeaconId(routeResult.destinationId);
    return current.isNotEmpty &&
        current == destination &&
        _confirmedExitBeaconIds.contains(destination);
  }

  String _arrivalExitMessage(EvacuationRouteResult routeResult) {
    final turn = _arrivalExitTurn(routeResult);
    return switch (turn) {
      TurnDirection.left || TurnDirection.slightLeft =>
        '잠시 후 왼쪽에 비상구가 있습니다. 왼쪽 벽을 짚고 비상구를 통해 1층으로 내려가세요',
      TurnDirection.right || TurnDirection.slightRight =>
        '잠시 후 오른쪽에 비상구가 있습니다. 오른쪽 벽을 짚고 비상구를 통해 1층으로 내려가세요',
      _ => '잠시 후 정면에 비상구가 있습니다. 비상구를 통해 1층으로 내려가세요',
    };
  }

  TurnDirection _arrivalExitTurn(EvacuationRouteResult routeResult) {
    final nodes = routeResult.nodeIds.map(_normalizeBeaconId).toList();
    final destination = _normalizeBeaconId(routeResult.destinationId);
    final destinationIndex = nodes.indexOf(destination);
    if (destinationIndex > 0) {
      final previous = nodes[destinationIndex - 1];
      final turn = _exitApproachTurns['$previous>$destination'];
      if (turn != null) return turn;
    }
    return _exitDoorTurnForCadBeacon(_beaconById(_currentMap, destination)) ??
        TurnDirection.straight;
  }

  String _approachingExitMessage(TurnDirection turn) {
    return switch (turn) {
      TurnDirection.left => '잠시 후 왼쪽에 비상구가 있습니다',
      TurnDirection.right => '잠시 후 오른쪽에 비상구가 있습니다',
      TurnDirection.slightLeft => '잠시 후 왼쪽 앞에 비상구가 있습니다',
      TurnDirection.slightRight => '잠시 후 오른쪽 앞에 비상구가 있습니다',
      TurnDirection.uTurn => '뒤쪽에 비상구가 있습니다. 이동 방향을 확인하세요',
      TurnDirection.arrive || TurnDirection.straight => '잠시 후 정면에 비상구가 있습니다',
    };
  }

  CadMapBeacon? _exitBeaconForFinalGuidance({
    required UserLiveLocation? user,
    required EvacuationRouteResult routeResult,
    required double remainingMeters,
  }) {
    final map = _currentMap;
    if (map == null) return null;

    final userBeaconId = user?.beaconId;
    if (userBeaconId != null && userBeaconId.trim().isNotEmpty) {
      final beacon = _beaconById(map, userBeaconId);
      if (beacon?.isExit == true) return beacon;
    }

    if (remainingMeters <= 3 && routeResult.destinationId.isNotEmpty) {
      final beacon = _beaconById(map, routeResult.destinationId);
      if (beacon?.isExit == true) return beacon;
    }
    return null;
  }

  TurnDirection? _exitDoorTurnForCadBeacon(CadMapBeacon? beacon) {
    if (beacon == null) return null;
    for (final key in [
      beacon.id,
      beacon.name,
      beacon.label,
      beacon.displayName,
      beacon.displayLabel,
    ]) {
      final turn = _exitDoorTurns[key.trim().toLowerCase()];
      if (turn != null) return turn;
    }
    return null;
  }

  double _bearing(Offset from, Offset to) {
    final radians = math.atan2(to.dx - from.dx, to.dy - from.dy);
    return (radians * 180 / math.pi + 360) % 360;
  }

  TurnDirection _screenTurn(Offset from, Offset to) {
    final dx = to.dx - from.dx;
    final dy = to.dy - from.dy;
    if (dx.abs() > dy.abs() * 1.2) {
      return dx < 0 ? TurnDirection.left : TurnDirection.right;
    }
    return TurnDirection.straight;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final enabled = state == AppLifecycleState.resumed;
    if (_ttsPlaybackEnabled == enabled) return;
    _ttsPlaybackEnabled = enabled;
    unawaited(_tts.setPlaybackEnabled(enabled));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mapSub?.cancel();
    _fireBeaconSub?.cancel();
    _fireStatusSub?.cancel();
    _knownBeaconSub?.cancel();
    _detectedBeaconSub?.cancel();
    _motionSub?.cancel();
    _foregroundMessageSub?.cancel();
    _messageOpenedSub?.cancel();
    _volumeUpSub?.cancel();
    _signalWatchdog?.cancel();
    _locationWarningTimer?.cancel();
    unawaited(_beacons.dispose());
    unawaited(_pdr.dispose());
    unawaited(_hardwareButtons.dispose());
    _tts.dispose();
    _mapController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsUserId) return _userIdSetupBody();

    final fireBeacon = _resolveFireBeacon();
    final userForMap = _currentMap == null
        ? null
        : _userLocationForMap(_currentMap!);
    final routeResult = _computeRoute(_currentMap, userForMap, fireBeacon);
    final displayUser = _clampedUserLocationForRoute(userForMap, routeResult);
    final displayRouteResult = _displayRouteForCurrentUser(
      routeResult,
      displayUser,
    );
    final route = displayRouteResult.points;
    final fireActive = fireBeacon != null;
    final routeDistanceCad = _routeDistanceCad(route);
    final routeDistanceMeters = _cadUnitsToMeters(routeDistanceCad);
    final destinationPoint = route.length >= 2 ? route.last : null;
    final displayStep = _displayStep(
      route: route,
      remainingMeters: routeDistanceMeters,
      user: displayUser,
      routeResult: routeResult,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0F1218),
      body: Column(
        children: [
          Expanded(
            child: _mapBody(
              fireBeacon: fireBeacon,
              route: route,
              destinationPoint: destinationPoint,
              destinationLabel: displayRouteResult.destinationId,
              userLocation: displayUser,
            ),
          ),
          NavigationPanel(
            currentStep: displayStep,
            remainingMeters: routeDistanceMeters,
            fireActive: fireActive,
            destinationLabel: displayRouteResult.destinationId,
            fireBeaconLabel: fireBeacon?.displayName ?? '',
            guidanceText: _guidanceText,
          ),
        ],
      ),
    );
  }

  Widget _userIdSetupBody() {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1218),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFF172033),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x66000000),
                      blurRadius: 24,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.person_pin_circle_outlined,
                      color: Color(0xFF38BDF8),
                      size: 46,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      '사용자 ID 설정',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '관리자 화면에서 위치를 구분할 이름을 입력하세요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white60, fontSize: 13),
                    ),
                    const SizedBox(height: 22),
                    TextField(
                      controller: _userIdController,
                      enabled: !_savingUserId,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: '사용자 ID',
                        hintText: 'user01, kim04, wheelchair_a',
                        errorText: _userIdErrorText,
                        filled: true,
                        fillColor: const Color(0xFF0F172A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submitInitialUserId(),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _savingUserId ? null : _submitInitialUserId,
                      icon: _savingUserId
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check),
                      label: Text(_savingUserId ? '저장 중' : '저장'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mapBody({
    required CadMapBeacon? fireBeacon,
    required List<Offset> route,
    required Offset? destinationPoint,
    required String destinationLabel,
    required UserLiveLocation? userLocation,
  }) {
    final map = _currentMap;
    final imageUrl = _imageUrl;
    if (_loading || map == null || imageUrl == null) {
      return _message(_status, loading: _loading || map != null);
    }
    if (imageUrl.isEmpty) {
      return _message(_status);
    }
    return Stack(
      children: [
        Positioned.fill(
          child: CadMapView(
            cadMap: map,
            imageUrl: imageUrl,
            userLocation: userLocation,
            fireBeacon: fireBeacon,
            destinationPoint: destinationPoint,
            destinationLabel: destinationLabel,
            routePoints: route,
            controller: _mapController,
            onBrowsingChanged: (browsing) {
              if (mounted && browsing != _isBrowsingMap) {
                setState(() => _isBrowsingMap = browsing);
              }
            },
          ),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: _mapInfoPanel(
            map: map,
            userLocation: userLocation,
            destinationLabel: destinationLabel,
            fireBeacon: fireBeacon,
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: _mapLocationButton(userLocation != null),
        ),
      ],
    );
  }

  Widget _mapInfoPanel({
    required CadMap map,
    required UserLiveLocation? userLocation,
    required String destinationLabel,
    required CadMapBeacon? fireBeacon,
  }) {
    final subtitle = _isBrowsingMap
        ? '지도 둘러보는 중'
        : userLocation == null
        ? '비콘 위치 확인 중'
        : '현재 위치 추적 중';
    final accent = fireBeacon == null
        ? const Color(0xFF38BDF8)
        : const Color(0xFFF87171);

    return Container(
      constraints: const BoxConstraints(maxWidth: 190),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xE6151E2B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.layers_rounded, color: accent, size: 18),
              const SizedBox(width: 7),
              Text(
                _floorLabel(map),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          if (destinationLabel.isNotEmpty) ...[
            const SizedBox(height: 7),
            Text(
              '대피 출구  $destinationLabel',
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

  Widget _mapLocationButton(bool enabled) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: const Color(0xE6151E2B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: enabled ? _mapController.focusOnUser : null,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.my_location, color: Color(0xFF7DD3FC)),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xCC151E2B),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '내 위치',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
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

  Widget _message(String text, {bool loading = false}) {
    return Container(
      color: const Color(0xFF101722),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (loading) ...[
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
          ],
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _statusChip() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$_status\n$_beaconDebugStatus',
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  // ignore: unused_element
  Widget _mapDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        value: _currentMap?.id,
        dropdownColor: const Color(0xFF1E293B),
        underline: const SizedBox.shrink(),
        iconEnabledColor: Colors.white,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        items: _availableMaps
            .map(
              (map) => DropdownMenuItem(
                value: map.id,
                child: Text(map.originalFile),
              ),
            )
            .toList(),
        onChanged: (id) {
          if (id == null) return;
          final selected = _availableMaps.firstWhere((map) => map.id == id);
          _selectMap(selected);
        },
      ),
    );
  }

  // ignore: unused_element
  Widget _quickActions(bool fireActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.small(
          heroTag: 'fire-toggle',
          tooltip: fireActive ? '화재 해제' : '교실 비콘 화재 테스트',
          backgroundColor: fireActive
              ? const Color(0xFF475569)
              : Colors.redAccent,
          onPressed: () => _toggleFire(fireActive),
          child: Icon(
            fireActive ? Icons.close : Icons.local_fire_department,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        FloatingActionButton.small(
          heroTag: 'location-random',
          tooltip: '사용자 위치 이동',
          backgroundColor: Colors.blueAccent,
          onPressed: _moveUserToNextBeacon,
          child: const Icon(Icons.my_location, color: Colors.white),
        ),
      ],
    );
  }

  Future<void> _toggleFire(bool fireActive) async {
    if (fireActive) {
      await _data.setFire(false);
      return;
    }
    final map = _currentMap;
    CadMapBeacon? target;
    for (final beacon in map?.beacons ?? const <CadMapBeacon>[]) {
      if (!beacon.isExit) {
        target = beacon;
        break;
      }
    }
    target ??= map?.beacons.isNotEmpty == true ? map!.beacons.first : null;
    await _data.setFire(true, location: target?.id ?? 'B01');
  }

  CadMapBeacon? _beaconById(CadMap? map, String id) {
    if (map == null) return null;
    final target = _normalizeBeaconId(id);
    for (final beacon in map.beacons) {
      final keys = [
        beacon.id,
        beacon.name,
        beacon.label,
        beacon.displayName,
        beacon.displayLabel,
      ].map(_normalizeBeaconId);
      if (keys.contains(target)) return beacon;
    }
    return null;
  }

  Future<void> _moveUserToNextBeacon() async {
    final map = _currentMap;
    if (map == null || map.beacons.isEmpty) return;
    final current = _userLocationForMap(map);
    var next = map.beacons.first;
    if (current != null) {
      var nearestIndex = 0;
      var nearestDistance = double.infinity;
      for (var i = 0; i < map.beacons.length; i++) {
        final beacon = map.beacons[i];
        final distance = _distance(current.x, current.y, beacon.x, beacon.y);
        if (distance < nearestDistance) {
          nearestIndex = i;
          nearestDistance = distance;
        }
      }
      next = map.beacons[(nearestIndex + 1) % map.beacons.length];
    }
    await _data.updateUserLocation(
      next.x,
      next.y,
      userId: _userId ?? UserIdentityService.defaultUserId,
      mapId: map.id,
      floorId: map.id,
      beaconId: next.id,
    );
  }
}
