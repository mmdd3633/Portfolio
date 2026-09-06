import 'package:flutter_tts/flutter_tts.dart';
import '../models/route_node.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();
  String _lastUtterance = '';
  DateTime _lastSpokeAt = DateTime.fromMillisecondsSinceEpoch(0);

  Future<void> initialize() async {
    await _tts.setLanguage('ko-KR');
    await _tts.setSpeechRate(0.55);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  Future<void> speak(String text, {bool force = false}) async {
    final now = DateTime.now();
    if (!force &&
        text == _lastUtterance &&
        now.difference(_lastSpokeAt).inSeconds < 8) {
      return;
    }
    _lastUtterance = text;
    _lastSpokeAt = now;
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> announceFire() async {
    await speak('화재 경보. 가까운 비상구로 대피하세요.', force: true);
  }

  Future<void> announceSearchingLocation() async {
    await speak('사용자의 위치를 탐색 중입니다. 앞으로 몇 걸음 이동해주세요');
  }

  Future<void> announceStep(NavStep step, double remainingMeters) async {
    final dist = remainingMeters.round();
    final action = _turnText(step.turn);
    final text = dist > 10 ? '$dist미터 앞에서 $action' : action;
    await speak(text);
  }

  Future<void> announceArrival() async {
    await speak('비상구에 도착했습니다. 안전하게 대피하세요.', force: true);
  }

  String _turnText(TurnDirection turn) {
    switch (turn) {
      case TurnDirection.straight:
        return '직진하세요';
      case TurnDirection.left:
        return '좌회전하세요';
      case TurnDirection.right:
        return '우회전하세요';
      case TurnDirection.slightLeft:
        return '왼쪽으로 진행하세요';
      case TurnDirection.slightRight:
        return '오른쪽으로 진행하세요';
      case TurnDirection.uTurn:
        return '뒤로 돌아가세요';
      case TurnDirection.arrive:
        return '곧 비상구에 도착합니다';
    }
  }

  Future<void> dispose() async {
    await _tts.stop();
  }
}
