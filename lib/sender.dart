import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:archive/archive.dart';

class Sender extends StatefulWidget {
  @override
  _SenderState createState() => _SenderState();
}

class _SenderState extends State<Sender> {
  String status = "Pick an image to encrypt";

  Future<void> pickAndEncrypt() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final img = File(picked.path);
    final bytes = await img.readAsBytes();

    final key = enc.Key.fromSecureRandom(32);
    final iv = enc.IV.fromSecureRandom(16);

    final aes = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final encrypted = aes.encryptBytes(bytes, iv: iv);

    final archive = Archive();
    archive.addFile(ArchiveFile(
      'secret.enc',
      encrypted.bytes.length,
      iv.bytes + encrypted.bytes,
    ));
    archive.addFile(ArchiveFile(
      'key.bin',
      key.bytes.length,
      key.bytes,
    ));

    final nshx = ZipEncoder().encode(archive)!;

    final dir = Directory("/storage/emulated/0/Download/drm_share");
    if (!dir.existsSync()) dir.createSync(recursive: true);

    final file = File("${dir.path}/secret.nshx");
    await file.writeAsBytes(nshx);

    setState(() {
      status = "Encrypted & bundled!\n\nSend:\nsecret.nshx\n\nPath:\n${dir.path}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sender")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              child: Text("Pick & Encrypt Image"),
              onPressed: pickAndEncrypt,
            ),
            SizedBox(height: 20),
            Text(status),
          ],
        ),
      ),
    );
  }
}
