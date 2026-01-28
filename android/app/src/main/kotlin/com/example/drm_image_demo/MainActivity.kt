package com.example.drm_image_demo

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

  override fun configureFlutterEngine(engine: FlutterEngine) {
    super.configureFlutterEngine(engine)

    MethodChannel(engine.dartExecutor.binaryMessenger, "drm")
      .setMethodCallHandler { call, result ->
        if (call.method == "open") {
          SecureImageViewer.show(this)
          result.success(null)
        } else {
          result.notImplemented()
        }
      }
  }
}
