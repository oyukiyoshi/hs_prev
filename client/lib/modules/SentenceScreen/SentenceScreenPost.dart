import 'dart:convert';

import 'package:client/modules/riverpod/PassageTextColorProvider.dart';
import 'package:client/modules/riverpod/PassageTextIsClickedProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:client/data.dart';


class SentenceScreenPost {
  final List<Passage> passageList;
  final Tag tag;
  final WidgetRef ref;
  SentenceScreenPost({required this.passageList, required this.tag, required this.ref});

  Future<int> connectToServerSequentially() async {
    bool err = false;
    for (var passage in passageList) {
      final url = Uri.parse('${dotenv.get('API_SERVER')}/sentence');
      final headers = {'content-type': 'application/json'};
      final req = Passage(
        sentenceId: passage.sentenceId, 
        lineNo: passage.lineNo, 
        tagId: passage.tagId, 
        textType: passage.textType, 
        passageContent: passage.passageContent
      );

      final res = await http.post(
        url,
        headers: headers,
        body: jsonEncode(req.toJson()),
      );

      if (res.statusCode != 200) {
        err = true;
        throw Exception('Failed to post');
      }
      ref.read(clickedPassageTextProvider.notifier).clearNo();
      ref.read(textColorProvider.notifier).setColor(passage.lineNo, tag.tagColor);
    }
    if (!err) {
      return 0;
    } else {
      return 1;
    }
  }
}