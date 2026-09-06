import '../models/route_node.dart';

class EvacuationGuidanceService {
  const EvacuationGuidanceService._();

  static const turnBackMessage = '이동 방향이 대피 경로와 반대입니다. 뒤로 돌아가세요.';

  static const _segmentGuidance = <String, String>{
    'h>b04': '오른쪽 벽을 짚고 이동하세요. 정면 방향으로 이동하세요',
    'b11>b12': '약 스무 걸음 앞 좌측 벽에 비상계단이 있습니다',
    'b02>b01': '비상구에 근접하였습니다. 약 열 걸음 앞 우측 벽에 비상계단이 있습니다',
    'b06>b05': '비상구에 근접하였습니다. 약 열 걸음 앞 좌측 벽에 비상계단이 있습니다',
    'b04>b05': '비상구에 근접 하였습니다. 약 열 걸음 앞 우측 벽에 비상 계단이 있습니다',
    'b09>b10': '비상구에 근접하였습니다. 약 열 걸음 앞 우측 벽에 비상 계단이 있습니다',
    'b11>b10': '비상구에 근접하였습니다. 약 스무 걸음 앞 좌측 벽에 비상 계단이 있습니다',
    'b08>b09': '우측 벽을 짚고 우회전 하십시오',
  };

  static String homeExitGuidance({
    String? fireBeaconId,
    String? nextBeaconId,
    String? afterDoorBeaconId,
  }) {
    final afterDoor = _normalizeBeaconId(afterDoorBeaconId);
    if (_isUpperCorridorBeacon(afterDoor)) {
      return '자세를 낮추고 문을 나가 왼쪽으로 이동하세요';
    }
    if (_isLowerCorridorBeacon(afterDoor)) {
      return '자세를 낮추고 문을 나가 오른쪽으로 이동하세요';
    }

    final next = _normalizeBeaconId(nextBeaconId);
    if (next == 'b03') {
      return '자세를 낮추고 문을 나가 왼쪽으로 이동하세요';
    }
    if (next == 'b05') {
      return '자세를 낮추고 문을 나가 오른쪽으로 이동하세요';
    }

    final fire = _normalizeBeaconId(fireBeaconId);
    final fireNumber = int.tryParse(RegExp(r'\d+').stringMatch(fire) ?? '');
    if (fireNumber != null && fire.startsWith('b')) {
      if (fireNumber >= 1 && fireNumber <= 3) {
        return '자세를 낮추고 문을 나가 우측으로 이동하세요';
      }
      if (fireNumber >= 4 && fireNumber <= 12) {
        return '자세를 낮추고 문을 나가 좌측으로 이동하세요';
      }
    }
    return '자세를 낮추고 방을 나와 복도로 이동하세요';
  }

  static bool _isUpperCorridorBeacon(String beaconId) {
    final number = _beaconNumber(beaconId);
    return beaconId.startsWith('b') &&
        number != null &&
        number >= 1 &&
        number <= 3;
  }

  static bool _isLowerCorridorBeacon(String beaconId) {
    final number = _beaconNumber(beaconId);
    return beaconId.startsWith('b') &&
        number != null &&
        number >= 5 &&
        number <= 12;
  }

  static int? _beaconNumber(String beaconId) {
    return int.tryParse(RegExp(r'\d+').stringMatch(beaconId) ?? '');
  }

  static String exitBeaconGuidance({
    required String beaconId,
    required TurnDirection routeTurn,
  }) {
    final beacon = _normalizeBeaconId(beaconId);
    final turn = _exitDoorTurns[beacon] ?? routeTurn;
    final side = _exitDoorSideText(turn);
    if (beacon == 'b01' || beacon == 'b1') {
      return '$side에 비상구가 있습니다';
    }
    final command = _exitDoorCommandText(turn);
    if (command.isEmpty) {
      return '$side 방향에 비상구가 있습니다. 비상구로 이동하세요';
    }
    return '비상구가 $side에 있습니다. $command하여 비상구로 이동하세요';
  }

  static String? specificSegmentGuidance({
    required String currentBeaconId,
    String? previousBeaconId,
    String? nextBeaconId,
  }) {
    final previous = _normalizeBeaconId(previousBeaconId);
    final current = _normalizeBeaconId(currentBeaconId);
    final next = _normalizeBeaconId(nextBeaconId);
    if (previous.isNotEmpty && current.isNotEmpty) {
      final message = _segmentGuidance['$previous>$current'];
      if (message != null) return message;
    }
    if (current.isNotEmpty && next.isNotEmpty) {
      final message = _segmentGuidance['$current>$next'];
      if (message != null) return message;
    }
    return null;
  }

  static String corridorGuidance({
    required TurnDirection turn,
    required bool includeWallGuide,
  }) {
    final direction = _directionText(turn);
    final movement = '$direction 방향으로 이동하세요';
    if (!includeWallGuide) return movement;
    return '${_wallGuideText(turn)} $movement';
  }

  static String _directionText(TurnDirection turn) {
    return switch (turn) {
      TurnDirection.left => '왼쪽',
      TurnDirection.right => '오른쪽',
      TurnDirection.slightLeft => '왼쪽 앞',
      TurnDirection.slightRight => '오른쪽 앞',
      TurnDirection.uTurn => '뒤쪽',
      TurnDirection.arrive => '정면',
      TurnDirection.straight => '정면',
    };
  }

  static String _wallGuideText(TurnDirection turn) {
    return switch (turn) {
      TurnDirection.left || TurnDirection.slightLeft => '왼쪽 벽을 짚고 이동하세요.',
      _ => '오른쪽 벽을 짚고 이동하세요.',
    };
  }

  static const Map<String, TurnDirection> _exitDoorTurns = {
    'b1': TurnDirection.right,
    'b01': TurnDirection.right,
    'b11': TurnDirection.left,
  };

  static String _exitDoorSideText(TurnDirection turn) {
    return switch (turn) {
      TurnDirection.left => '왼쪽',
      TurnDirection.right => '오른쪽',
      TurnDirection.slightLeft => '왼쪽 앞',
      TurnDirection.slightRight => '오른쪽 앞',
      TurnDirection.uTurn => '뒤쪽',
      TurnDirection.arrive || TurnDirection.straight => '정면',
    };
  }

  static String _exitDoorCommandText(TurnDirection turn) {
    return switch (turn) {
      TurnDirection.left => '좌회전',
      TurnDirection.right => '우회전',
      TurnDirection.slightLeft => '왼쪽 앞으로 이동',
      TurnDirection.slightRight => '오른쪽 앞으로 이동',
      TurnDirection.uTurn => '뒤돌아 이동',
      TurnDirection.arrive || TurnDirection.straight => '',
    };
  }

  static String _normalizeBeaconId(String? value) {
    if (value == null) return '';
    final match = RegExp(r'[a-zA-Z]+\s*0*\d+|h\s*708|h').firstMatch(value);
    final raw = (match?.group(0) ?? value).trim().toLowerCase();
    final letter = RegExp(r'^[a-z]+').stringMatch(raw) ?? '';
    final digits = RegExp(r'\d+').stringMatch(raw);
    if (letter.isEmpty) return raw.replaceAll(RegExp(r'\s+'), '');
    if (digits == null) return letter;
    return '$letter${digits.padLeft(2, '0')}';
  }
}

class WrongDirectionTracker {
  static const _wrongDirectionDelay = Duration(seconds: 2);
  String? _activeWrongMovementKey;
  DateTime? _wrongDirectionStartedAt;
  String? _lastObservedBeaconId;

  bool shouldAnnounceTurnBack({
    required String? previousBeaconId,
    required String currentBeaconId,
    required List<String> routeNodeIds,
    List<String> previousRouteNodeIds = const [],
    required DateTime now,
  }) {
    var previous = _normalize(previousBeaconId);
    final current = _normalize(currentBeaconId);
    if (current.isEmpty) {
      _resetWrongCandidate();
      return false;
    }

    if (previous.isEmpty || previous == current) {
      previous = _lastObservedBeaconId ?? '';
    }

    final sameAsLast = _lastObservedBeaconId == current;
    if (!sameAsLast) {
      _lastObservedBeaconId = current;
    }

    if (previous.isEmpty || previous == current) {
      return _activeWrongMovementKey?.endsWith('>$current') == true &&
          _wrongDirectionStartedAt != null &&
          now.difference(_wrongDirectionStartedAt!) >= _wrongDirectionDelay;
    }

    final next = _nextRouteBeacon(current, routeNodeIds);
    final wrong =
        _movedAwayFromPreviousRoute(
          previousBeaconId: previous,
          currentBeaconId: current,
          previousRouteNodeIds: previousRouteNodeIds,
        ) ||
        (next.isNotEmpty && next == previous);
    final movementKey = '$previous>$current';
    if (!wrong) {
      _resetWrongCandidate();
      return false;
    }

    if (_activeWrongMovementKey != movementKey) {
      _activeWrongMovementKey = movementKey;
      _wrongDirectionStartedAt = now;
      return false;
    }

    final started = _wrongDirectionStartedAt;
    return started != null && now.difference(started) >= _wrongDirectionDelay;
  }

  void markCorrected() {
    _resetWrongCandidate();
    _lastObservedBeaconId = null;
  }

  void _resetWrongCandidate() {
    _activeWrongMovementKey = null;
    _wrongDirectionStartedAt = null;
  }

  String _nextRouteBeacon(String currentBeaconId, List<String> routeNodeIds) {
    final nodes = routeNodeIds
        .map(_normalize)
        .where((id) => id.isNotEmpty)
        .toList();
    final index = nodes.indexOf(currentBeaconId);
    if (index >= 0 && index + 1 < nodes.length) return nodes[index + 1];
    if (index < 0 && nodes.length >= 2) return nodes[1];
    return '';
  }

  bool _movedAwayFromPreviousRoute({
    required String previousBeaconId,
    required String currentBeaconId,
    required List<String> previousRouteNodeIds,
  }) {
    final previousRoute = previousRouteNodeIds
        .map(_normalize)
        .where((id) => id.isNotEmpty)
        .toList(growable: false);
    final previousIndex = previousRoute.indexOf(previousBeaconId);
    if (previousIndex < 0 || previousIndex + 1 >= previousRoute.length) {
      return false;
    }
    final expectedNext = previousRoute[previousIndex + 1];
    if (expectedNext == currentBeaconId) return false;
    return true;
  }

  String _normalize(String? value) {
    return EvacuationGuidanceService._normalizeBeaconId(value);
  }
}
