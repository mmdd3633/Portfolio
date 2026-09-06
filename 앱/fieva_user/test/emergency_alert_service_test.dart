import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fieva_user/services/emergency_alert_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('fieva/emergency_alert');
  final calls = <String>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call.method);
          return true;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('starts and stops the native emergency alert', () async {
    final service = EmergencyAlertService();

    await service.startFireAlert();
    await service.stopFireAlert();

    expect(calls, ['startEmergencyAlert', 'stopEmergencyAlert']);
  });
}
