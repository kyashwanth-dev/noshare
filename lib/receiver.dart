import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:archive/archive.dart';
import 'drm_bridge.dart';

class Receiver extends StatefulWidget {
  @override
  _ReceiverState createState() => _ReceiverState();
}

class _ReceiverState extends State<Receiver> {
  String status = "Import your .nshx file";

  Future<void> importNshx() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['nshx'],
    );

    if (result == null) return;

    final picked = File(result.files.first.path!);
    final bytes = picked.readAsBytesSync();

    final archive = ZipDecoder().decodeBytes(bytes);

    final dir = Directory("/data/data/com.example.drm_image_demo/files");

    for (final file in archive) {
      final out = File("${dir.path}/${file.name}");
      await out.writeAsBytes(file.content as List<int>);
    }

    setState(() {
      status = "File imported securely.\nTap 'Open Secure Image'";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Receiver")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              child: Text("Import .nshx"),
              onPressed: importNshx,
            ),
            SizedBox(height: 12),
            ElevatedButton(
              child: Text("Open Secure Image"),
              onPressed: DrmBridge.open,
            ),
            SizedBox(height: 20),
            Text(status),
          ],
        ),
      ),
    );
  }
}
