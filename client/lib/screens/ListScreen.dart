import 'dart:convert';
import 'dart:html' as html;

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
      return [];
    }
  }

  void changeTabTitle(String newTitle) {
    html.document.title = newTitle;
  }
  @override
  void initState() {
    super.initState();
    changeTabTitle(constAppTabPrefix + constSentences);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(constSentences),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Sentence>>(
        future: _connectToServer(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // データ取得中
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // エラー発生
            return Center(child: Text('Error: ${snapshot.error}'));
          } 
            // 成功
            final sentenceList = snapshot.data!;
            return Row(
              children: [
                const Flexible(
                  flex: 1,
                  child: RightNavigationRail(selectedIndexI: 0,),
                ),
                Flexible(
                  flex: 3,
                  child: ListView.builder(
                    itemCount: sentenceList.length,
                    itemBuilder: (context, index) {
                      if (sentenceList.isEmpty) {
                        return Container();
                      }
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
                                    child: Text(DateFormat('yyyy/M/d HH:mm').format(jst),
                                    style: const TextStyle(fontSize: fontSize * 0.7),
                                  ),
                                ),
                                const SizedBox(width: sizedBoxWidth,),
                                ElevatedButton(
                                  onPressed: () async {
                                    await downloadFile('${dotenv.get('API_SERVER')}/list/download/${sentence.sentenceId}', '${sentence.sentenceName}.md');
                                  },
                                  child: const Icon(Icons.download)
                                ),
                                const SizedBox(width: sizedBoxWidth,),
                                ElevatedButton(
                                  child: const Icon(Icons.delete_forever_outlined),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            fileDeleteCheck,
                                            style: const TextStyle(fontSize: fontSize),
                                          ),
                                          actions: <Widget>[
                                            InkWell(
                                              child: Padding(
                                                padding: EdgeInsets.all(paddingSize),
                                                child: Text(
                                                  userReactionNo,
                                                  style: const TextStyle(fontSize: fontSize),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            InkWell(
                                              child: Padding(
                                                padding: EdgeInsets.all(paddingSize),
                                                child: Text(
                                                  userReactionYes,
                                                  style: const TextStyle(fontSize: fontSize),
                                                ),
                                              ),
                                              onTap: () async {
                                                await ListScreenDelete(sentenceID: sentence.sentenceId).connectToServer();
                                                setState(() {});
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      }
                                    );
                                  }
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
      ),
    );
  }
}
