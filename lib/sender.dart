import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as enc;

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

    // 🔐 Generate AES key + IV
    final key = enc.Key.fromSecureRandom(32);
    final iv = enc.IV.fromSecureRandom(16);

    final aes = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final encrypted = aes.encryptBytes(bytes, iv: iv);

    // Save encrypted file
    final dir = await getApplicationDocumentsDirectory();
    final encFile = File("${dir.path}/secret.enc");
    await encFile.writeAsBytes(iv.bytes + encrypted.bytes);

    // Save key (for prototype only)
    final keyFile = File("${dir.path}/key.bin");
    await keyFile.writeAsBytes(key.bytes);

    setState(() {
      status = "Encrypted!\n\nSend these files to receiver:\nsecret.enc\nkey.bin\n\nPath:\n${dir.path}";
    });
  }

  @override
  Widget build(BuildContext c) {
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
