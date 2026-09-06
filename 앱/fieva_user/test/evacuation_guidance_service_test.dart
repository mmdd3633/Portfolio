import 'package:flutter_test/flutter_test.dart';

import 'package:fieva_user/models/route_node.dart';
import 'package:fieva_user/services/evacuation_guidance_service.dart';

void main() {
  group('EvacuationGuidanceService', () {
    test('removes current location wording from corridor guidance', () {
      final message = EvacuationGuidanceService.corridorGuidance(
        turn: TurnDirection.straight,
        includeWallGuide: false,
      );

      expect(message, isNot(contains('현재 위치')));
      expect(message, '정면 방향으로 이동하세요');
    });

    test('guides H708 door direction from fire side', () {
      expect(
        EvacuationGuidanceService.homeExitGuidance(fireBeaconId: 'B03'),
        '자세를 낮추고 문을 나가 우측으로 이동하세요',
      );
      expect(
        EvacuationGuidanceService.homeExitGuidance(fireBeaconId: 'B05'),
        '자세를 낮추고 문을 나가 좌측으로 이동하세요',
      );
    });

    test('moves right wall guide from H708 to B04 assignment', () {
      expect(
        EvacuationGuidanceService.specificSegmentGuidance(
          currentBeaconId: 'B04',
          previousBeaconId: 'H',
        ),
        '오른쪽 벽을 짚고 이동하세요. 정면 방향으로 이동하세요',
      );
    });

    test('uses short B01 exit guidance', () {
      expect(
        EvacuationGuidanceService.exitBeaconGuidance(
          beaconId: 'B01',
          routeTurn: TurnDirection.right,
        ),
        '오른쪽에 비상구가 있습니다',
      );
    });

    test('uses specific stair guidance for known route segments', () {
      expect(
        EvacuationGuidanceService.specificSegmentGuidance(
          currentBeaconId: 'B11',
          nextBeaconId: 'B12',
        ),
        '약 스무 걸음 앞 좌측 벽에 비상계단이 있습니다',
      );
      expect(
        EvacuationGuidanceService.specificSegmentGuidance(
          currentBeaconId: 'B02',
          nextBeaconId: 'B01',
        ),
        '비상구에 근접하였습니다. 약 열 걸음 앞 우측 벽에 비상계단이 있습니다',
      );
    });

    test('uses previous-to-current guidance for B08 to B09 turn', () {
      expect(
        EvacuationGuidanceService.specificSegmentGuidance(
          currentBeaconId: 'B09',
          previousBeaconId: 'B08',
        ),
        '우측 벽을 짚고 우회전 하십시오',
      );
    });
  });

  group('WrongDirectionTracker', () {
    test('announces turn back only after wrong direction persists', () {
      final tracker = WrongDirectionTracker();
      final started = DateTime(2026, 7, 7, 12);

      expect(
        tracker.shouldAnnounceTurnBack(
          previousBeaconId: 'B04',
          currentBeaconId: 'B03',
          routeNodeIds: const ['B03', 'B04', 'B05'],
          now: started,
        ),
        isFalse,
      );
      expect(
        tracker.shouldAnnounceTurnBack(
          previousBeaconId: 'B04',
          currentBeaconId: 'B03',
          routeNodeIds: const ['B03', 'B04', 'B05'],
          now: started.add(const Duration(milliseconds: 1900)),
        ),
        isFalse,
      );
      expect(
        tracker.shouldAnnounceTurnBack(
          previousBeaconId: 'B04',
          currentBeaconId: 'B03',
          routeNodeIds: const ['B03', 'B04', 'B05'],
          now: started.add(const Duration(milliseconds: 2100)),
        ),
        isTrue,
      );
    });

    test(
      'keeps wrong direction candidate while staying on the same beacon',
      () {
        final tracker = WrongDirectionTracker();
        final started = DateTime(2026, 7, 7, 12);

        expect(
          tracker.shouldAnnounceTurnBack(
            previousBeaconId: 'B04',
            currentBeaconId: 'B03',
            routeNodeIds: const ['B03', 'B04', 'B05'],
            now: started,
          ),
          isFalse,
        );
        expect(
          tracker.shouldAnnounceTurnBack(
            previousBeaconId: 'B03',
            currentBeaconId: 'B03',
            routeNodeIds: const ['B03', 'B04', 'B05'],
            now: started.add(const Duration(milliseconds: 2100)),
          ),
          isTrue,
        );
      },
    );

    test('detects movement away from the previous route plan', () {
      final tracker = WrongDirectionTracker();
      final started = DateTime(2026, 7, 7, 12);

      expect(
        tracker.shouldAnnounceTurnBack(
          previousBeaconId: 'B04',
          currentBeaconId: 'B03',
          routeNodeIds: const ['B03', 'B02', 'B01'],
          previousRouteNodeIds: const ['B04', 'B05', 'B06'],
          now: started,
        ),
        isFalse,
      );
      expect(
        tracker.shouldAnnounceTurnBack(
          previousBeaconId: 'B03',
          currentBeaconId: 'B03',
          routeNodeIds: const ['B03', 'B02', 'B01'],
          previousRouteNodeIds: const ['B04', 'B05', 'B06'],
          now: started.add(const Duration(milliseconds: 2100)),
        ),
        isTrue,
      );
    });

    test('does not flag movement toward the next route beacon', () {
      final tracker = WrongDirectionTracker();

      expect(
        tracker.shouldAnnounceTurnBack(
          previousBeaconId: 'B03',
          currentBeaconId: 'B04',
          routeNodeIds: const ['B04', 'B05'],
          previousRouteNodeIds: const ['B03', 'B04', 'B05'],
          now: DateTime(2026, 7, 7, 12),
        ),
        isFalse,
      );
    });
  });
}
