import 'package:flutter/material.dart';
import 'drm_bridge.dart';

class Receiver extends StatelessWidget {
  @override
  Widget build(BuildContext c) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Open Secure Image"),
          onPressed: () => DrmBridge.open(),
        ),
      ),
    );
  }
}
