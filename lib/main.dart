import 'package:flutter/material.dart';
import 'sender.dart';
import 'receiver.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: Text("Secure DRM Demo")),
      body: Column(
        children: [
          ElevatedButton(child: Text("Sender"), onPressed: () {
            Navigator.push(c, MaterialPageRoute(builder: (_) => Sender()));
          }),
          ElevatedButton(child: Text("Receiver"), onPressed: () {
            Navigator.push(c, MaterialPageRoute(builder: (_) => Receiver()));
          })
        ],
      ),
    );
  }
}
