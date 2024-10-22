import 'dart:convert';
import 'package:client/data.dart';
import 'package:client/modules/SentenceScreen/SentenceScreenPost.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../modules/SentenceScreen/PassageMath.dart';
import '../modules/SentenceScreen/PassageText.dart';
import '../modules/riverpod/PassageTextIsClickedProvider.dart';
import '../const.dart';
import '../modules/RightNavigationRail.dart';

class SentenceScreen extends ConsumerStatefulWidget {
  final String sentenceID;
  const SentenceScreen({super.key, required this.sentenceID});

  @override
  _SentenceScreenState createState() => _SentenceScreenState();
}

class _SentenceScreenState extends ConsumerState<SentenceScreen> {
  late String sentenceID;
  late Future<List<Passage>> _futurePassages;
  late Future<List<Tag>> _futureTag;

  Future<List<Passage>> _getFromServerSentence() async {
    final url = Uri.parse('$baseURL/sentence/$sentenceID');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List<dynamic> passages = jsonDecode(res.body) as List<dynamic>;
      return passages
          .map((json) => Passage.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load passages');
    }
  }

  Future<List<Tag>> _getFromServerTag() async {
    final url = Uri.parse('$baseURL/tag');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List<dynamic> tags = jsonDecode(res.body) as List<dynamic>;
      return tags
          .map((json) => Tag.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load tags');
    }
  }

  @override
  void initState() {
    super.initState();
    sentenceID = widget.sentenceID;
    _futurePassages = _getFromServerSentence();
    _futureTag = _getFromServerTag();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final clickedPassageText = ref.watch(clickedPassageTextProvider);

    // tag 読み込み終了後、passages を読み込む
    return FutureBuilder<List<Tag>>(
      future: _futureTag,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // データ取得中
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // エラー発生
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // データなし
          return const Center(child: Text('No tags available.'));
        } else {
          // 成功
          final tagList = snapshot.data!;
          return Scaffold(
            body: Row(
              children: [
                const Flexible(
                  flex: 1,
                  child: RightNavigationRail(),
                ),
                Flexible(
                  flex: 3,
                  child: FutureBuilder<List<Passage>>(
                    future: _futurePassages, 
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // データ取得中
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        // エラー発生
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        // データなし
                        return const Center(child: Text('No passages available.'));
                      } else {
                        // 成功
                        final passageList = snapshot.data!;
                        return ListView.builder(
                          itemCount: passageList.length,
                          itemBuilder: (context, index) {
                            final passage = passageList[index];
                            switch(passage.textType) {
                              case 'text':
                                late String textColor;
                                for (var i = 0; i < tagList.length; i++) {
                                  if (passage.tagId == tagList[i].tagId) {
                                    textColor = tagList[i].tagColor;
                                  }
                                }
                                return PassageText(no: passage.lineNo, content: passage.passageContent, textColorI: textColor);
                              case 'tex':
                                return PassageMath(content: passage.passageContent);
                              default:
                                return Container(height: 10000,);
                            }
                          }
                        );
                      }
                    }
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(paddingSize),
                    child: ListView.builder(
                      itemCount: tagList.length,
                      itemBuilder: (context, index) {
                        final tag = tagList[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: columnVerticle),
                          constraints: BoxConstraints(maxWidth: screenWidth * screenWidthRatio),
                          child: InkWell(
                            onTap: () async {
                              List<Passage> passageList = [];
                              for (var i = 0; i < clickedPassageText.length; i++) {
                                Passage passage = Passage(
                                  sentenceId: int.parse(sentenceID), 
                                  lineNo: clickedPassageText[i], 
                                  tagId: tag.tagId, 
                                  textType: "", 
                                  passageContent: ""
                                );
                                passageList.add(passage);
                              }
                              SentenceScreenPost sentenceScreenPost = SentenceScreenPost(passageList: passageList, tag: tag, ref: ref);
                              await sentenceScreenPost.connectToServerSequentially();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(paddingSize),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.square,
                                    color: Color(int.parse('FF${tag.tagColor}', radix: 16)),
                                  ),
                                  const SizedBox(width: 10,),
                                  Text(tag.tagName,
                                    style: const TextStyle(fontSize: fontSize),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }
    );
  }
}