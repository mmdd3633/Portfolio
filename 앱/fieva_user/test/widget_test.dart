import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fieva_user/main.dart';
import 'package:fieva_user/screens/map_screen.dart';

void main() {
  testWidgets('User app opens directly on the map and beacon screen', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const FievaApp());
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(MapScreen), findsOneWidget);
    expect(find.text('대피 안내 시작'), findsNothing);
    expect(find.text('관리자 모드'), findsNothing);
  });

  testWidgets('Keeps location tracking idle when there is no fire', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const FievaApp());
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 21));

    expect(find.text('화재 미발생, 위치 추적 비활성화'), findsOneWidget);
    expect(find.byIcon(Icons.straight), findsNothing);
    expect(find.text('위치를 찾지 못했습니다'), findsNothing);
    expect(find.textContaining('몇 걸음 움직여 주세요'), findsNothing);
  });
}
