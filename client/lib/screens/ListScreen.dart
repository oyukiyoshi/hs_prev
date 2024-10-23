import 'dart:convert';

import 'package:client/modules/ListScreen/FilePick.dart';
import 'package:client/modules/ListScreen/ListScreenDelete.dart';
import 'package:client/modules/downloadFile.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:client/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/modules/RightNavigationRail.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../const.dart';

class ListScreen extends ConsumerStatefulWidget {
  const ListScreen({super.key});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends ConsumerState<ListScreen> {
  Future<List<Sentence>> _connectToServer() async {
    final url = Uri.parse('${dotenv.get('API_SERVER')}/list');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List<dynamic> sentences = jsonDecode(res.body) as List<dynamic>;
      return sentences
          .map((json) => Sentence.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load sentences');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: FutureBuilder<List<Sentence>>(
        future: _connectToServer(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // データ取得中
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // エラー発生
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // データなし
            return const Center(child: Text('No sentences available.'));
          } else {
            // 成功
            final sentenceList = snapshot.data!;
            return Row(
              children: [
                const Flexible(
                  flex: 1,
                  child: RightNavigationRail(),
                ),
                Flexible(
                  flex: 3,
                  child: ListView.builder(
                    itemCount: sentenceList.length,
                    itemBuilder: (context, index) {
                      final sentence = sentenceList[index];
                      final jst = DateTime.parse(sentence.changedAt.toUtc().toIso8601String()).toLocal();
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: columnVerticle),
                        constraints: BoxConstraints(maxWidth: screenWidth * screenWidthRatio),
                        child: InkWell(
                          onTap: () {
                            context.go('/sentence/${sentence.sentenceId}');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(paddingSize),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(sentence.sentenceName,
                                    style: const TextStyle(fontSize: fontSize),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                    child: Text(DateFormat('yyyy/M/d h:m').format(jst),
                                    style: const TextStyle(fontSize: fontSize * 0.7),
                                  ),
                                ),
                                SizedBox(width: sizedBoxWidth,),
                                ElevatedButton(
                                  onPressed: () async {
                                    await downloadFile('${dotenv.get('API_SERVER')}/list/download/${sentence.sentenceId}', sentence.sentenceName);
                                  },
                                  child: const Icon(Icons.download)
                                ),
                                SizedBox(width: sizedBoxWidth,),
                                ElevatedButton(
                                  onPressed: () async {
                                    await ListScreenDelete(sentenceID: sentence.sentenceId).connectToServer();
                                    setState(() {});
                                  }, 
                                  child: const Icon(Icons.delete_forever_outlined)
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Flexible(
                  flex: 1,
                  child: FilePick(),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
