import 'package:flutter/services.dart';

class EmergencyAlertService {
  static const MethodChannel _channel = MethodChannel('fieva/emergency_alert');

  Future<bool> startFireAlert() async {
    try {
      return await _channel.invokeMethod<bool>('startEmergencyAlert') ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> stopFireAlert() async {
    try {
      return await _channel.invokeMethod<bool>('stopEmergencyAlert') ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> consumeEmergencyLaunch() async {
    try {
      return await _channel.invokeMethod<bool>('consumeEmergencyLaunch') ??
          false;
    } catch (_) {
      return false;
    }
  }
}
