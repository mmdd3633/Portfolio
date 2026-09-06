import 'dart:async';

import 'package:flutter/services.dart';

class HardwareButtonService {
  static const _channel = MethodChannel('fieva/accessibility_controls');

  final _volumeUpController = StreamController<void>.broadcast();
  bool _handlerInstalled = false;

  Stream<void> get volumeUpEvents {
    _installHandler();
    return _volumeUpController.stream;
  }

  void _installHandler() {
    if (_handlerInstalled) return;
    _handlerInstalled = true;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'volumeUp') {
        _volumeUpController.add(null);
      }
    });
  }

  Future<bool> isBluetoothEnabled() async {
    try {
      return await _channel.invokeMethod<bool>('isBluetoothEnabled') ?? true;
    } on PlatformException {
      return true;
    } on MissingPluginException {
      return true;
    }
  }

  Future<void> openBluetoothSettings() async {
    try {
      await _channel.invokeMethod<void>('openBluetoothSettings');
    } on PlatformException {
      // Best effort: Android may restrict direct Bluetooth changes.
    } on MissingPluginException {
      // Non-Android platforms do not expose this native hook.
    }
  }

  Future<void> dispose() async {
    await _volumeUpController.close();
  }
}
