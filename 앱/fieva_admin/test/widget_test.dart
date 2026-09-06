import 'package:flutter_test/flutter_test.dart';

import 'package:fieva_admin/main.dart';
import 'package:fieva_admin/screens/admin_screen.dart';

void main() {
  testWidgets('Admin app opens directly on the mode selection home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FievaApp());
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(AdminScreen), findsOneWidget);
    expect(find.text('FIEVA 관리자 점검'), findsOneWidget);
    expect(find.text('시뮬레이션 모드'), findsOneWidget);
    expect(find.text('화재 사용자 위치 확인'), findsOneWidget);
    expect(find.textContaining('수신 0/'), findsNothing);
    expect(find.text('실제 비콘 모드'), findsNothing);
  });
}
