import 'package:flutter/services.dart';

class DrmBridge {
  static const _channel = MethodChannel("drm");

  static Future<void> open() async {
    await _channel.invokeMethod("open");
  }
}
