import 'package:flutter/material.dart';

import '../models/route_node.dart';

class NavigationPanel extends StatelessWidget {
  final NavStep? currentStep;
  final double remainingMeters;
  final bool fireActive;
  final String destinationLabel;
  final String fireBeaconLabel;
  final String guidanceText;

  const NavigationPanel({
    super.key,
    required this.currentStep,
    required this.remainingMeters,
    required this.fireActive,
    this.destinationLabel = '',
    this.fireBeaconLabel = '',
    this.guidanceText = '',
  });

  @override
  Widget build(BuildContext context) {
    final hasRoute = currentStep != null && remainingMeters > 0;
    final turn = currentStep?.turn ?? TurnDirection.straight;
    final bg = fireActive ? const Color(0xFFE11D48) : const Color(0xFF172033);
    final accent = fireActive
        ? const Color(0xFFFFD7DE)
        : const Color(0xFFDDEBFF);

    return Container(
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.98),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 20,
            offset: Offset(0, -6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (fireActive) _fireBanner(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _statusPill(
                  icon: Icons.exit_to_app,
                  text: destinationLabel.isEmpty
                      ? '안전 출구 탐색 중'
                      : '$destinationLabel 출구',
                  color: const Color(0xFF22C55E),
                ),
                if (fireActive && fireBeaconLabel.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  _statusPill(
                    icon: Icons.local_fire_department,
                    text: '$fireBeaconLabel 우회',
                    color: const Color(0xFFFFB4B4),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Text(
              hasRoute ? '비상구까지 ${remainingMeters.round()}m' : '현재 위치 확인 중',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: accent,
                fontSize: 27,
                height: 1,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 164,
              height: 128,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(36),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 3,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x44000000),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(_arrowIcon(turn), color: Colors.white, size: 104),
            ),
            const SizedBox(height: 10),
            Text(
              guidanceText.trim().isNotEmpty
                  ? guidanceText
                  : hasRoute
                  ? _instruction(turn)
                  : '비콘 신호를 확인하고 있습니다',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fireBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              '화재 경보 - 가장 가까운 비상구로 이동하세요',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusPill({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withValues(alpha: 0.45)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 5),
            Flexible(
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
            ),
          ],
        ),
      ),
    );
  }

  IconData _arrowIcon(TurnDirection turn) {
    return switch (turn) {
      TurnDirection.left => Icons.turn_left,
      TurnDirection.right => Icons.turn_right,
      TurnDirection.slightLeft => Icons.subdirectory_arrow_left,
      TurnDirection.slightRight => Icons.subdirectory_arrow_right,
      TurnDirection.uTurn => Icons.rotate_left,
      TurnDirection.arrive => Icons.flag,
      TurnDirection.straight => Icons.straight,
    };
  }

  String _instruction(TurnDirection turn) {
    return switch (turn) {
      TurnDirection.left => '왼쪽으로 이동하세요',
      TurnDirection.right => '오른쪽으로 이동하세요',
      TurnDirection.slightLeft => '왼쪽 앞 방향으로 이동하세요',
      TurnDirection.slightRight => '오른쪽 앞 방향으로 이동하세요',
      TurnDirection.uTurn => '뒤돌아 이동하세요',
      TurnDirection.arrive => '비상구에 도착했습니다',
      TurnDirection.straight => '직진하세요',
    };
  }
}
