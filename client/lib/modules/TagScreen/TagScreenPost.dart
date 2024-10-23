import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:client/data.dart';

class TagScreenPost {
  final Tag tag;
  TagScreenPost({required this.tag});

  Future<void> connectToServer() async {
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
}