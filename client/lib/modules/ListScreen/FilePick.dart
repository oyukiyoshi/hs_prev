import 'dart:convert';

import 'package:client/data.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

class FilePick extends StatefulWidget {
  const FilePick({super.key});
  @override
  _FilePickState createState() => _FilePickState();
}

class _FilePickState extends State<FilePick> {

  int sentenceId = 0;

  Future<void> _pickUpload() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        PlatformFile pickedFile = result.files.first;

        if (pickedFile.bytes != null) {
          final url = Uri.parse('${dotenv.get('API_SERVER')}/list');
          var req = http.MultipartRequest('POST', url);

          req.files.add(http.MultipartFile.fromBytes(
            'file',
            pickedFile.bytes!,
            filename: pickedFile.name,
          ));

          final res = await req.send();

          // ステータスコードを確認
          if (res.statusCode == 200) {
            final responseBody = await res.stream.bytesToString();
            final Sentence sentence = Sentence.fromJson(jsonDecode(responseBody));
            sentenceId = sentence.sentenceId;
            return;
          } else {
            throw Exception('Fail to upload file');
          }
        } else {
          throw Exception('No file bytes found');
        }
      } else {
        print('File selection was cancelled');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await _pickUpload();
          if (sentenceId != 0) {
            context.go('/sentence/$sentenceId');
          }
        },
        style: OutlinedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
          minimumSize: const Size(50, 50),
        ),
        child: const Icon(Icons.upload_file_outlined),
      ),
    );
  }
}