

import 'package:client/const.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class FilePick extends StatefulWidget {
  const FilePick({super.key});
  @override
  _FilePickState createState() => _FilePickState();
}

class _FilePickState extends State<FilePick> {

  Future<void> _pickUpload() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        PlatformFile pickedFile = result.files.first;

        if (pickedFile.bytes != null) {
          final url = Uri.parse('$baseURL/list');
          var req = http.MultipartRequest('POST', url);

          req.files.add(http.MultipartFile.fromBytes(
            'file',
            pickedFile.bytes!,
            filename: pickedFile.name,
          ));

          // リクエストを送信
          var res = await req.send();

          // ステータスコードを確認
          if (res.statusCode != 200) {
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
        onPressed: _pickUpload, 
        child: const Icon(Icons.upload_file_outlined),
        style: OutlinedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
          minimumSize: const Size(50, 50),
        ),
      ),
    );
  }
}