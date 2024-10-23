import 'dart:convert';

import 'package:client/screens/TagScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:client/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TagScreenPost extends ConsumerStatefulWidget {
  final Tag tag;
  const TagScreenPost({super.key, required this.tag});

  @override
  _TagScreenPostState createState() => _TagScreenPostState();
}

class _TagScreenPostState extends ConsumerState<TagScreenPost> {
  late Tag tag;

  Future<void> _connectToServer() async {
    final url = Uri.parse('${dotenv.get('API_SERVER')}/tag');
    final headers = {'content-type': 'application/json'};
    final req = Tag(
      tagId: tag.tagId, 
      tagColor: tag.tagColor, 
      tagName: tag.tagName
    );

    final res = await http.post(
      url,
      headers: headers,
      body: jsonEncode(req.toJson()),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to post');
    }
  }

  @override
  void initState() {
    super.initState();
    tag = widget.tag;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _connectToServer(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
            // データ取得中
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // エラー発生
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // 成功
            return TagScreen();
          }
      },
    );
  }
}