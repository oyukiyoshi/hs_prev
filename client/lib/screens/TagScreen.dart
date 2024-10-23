import 'dart:convert';

import 'package:client/modules/TagScreen/TagScreenPost.dart';
import 'package:client/modules/TagScreen/TextEditingDialog.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:client/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/modules/RightNavigationRail.dart';
import 'package:flutter/material.dart';
import '../const.dart';

class TagScreen extends ConsumerStatefulWidget {
  const TagScreen({super.key});

  @override
  _TagScreenState createState() => _TagScreenState();
}

class _TagScreenState extends ConsumerState<TagScreen> {
  Future<List<Tag>> _connectToServer() async {
    final url = Uri.parse('${dotenv.get('API_SERVER')}/tag');
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
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: FutureBuilder<List<Tag>>(
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
            return const Center(child: Text('No tags available.'));
          } else {
            // 成功
            final tagList = snapshot.data!;
            return Row(
              children: [
                const Flexible(
                  flex: 1,
                  child: RightNavigationRail(),
                ),
                Flexible(
                  flex: 3,
                  child: ListView.builder(
                    itemCount: tagList.length,
                    itemBuilder: (context, index) {
                      final tag = tagList[index];
                      var name = tag.tagName;
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: columnVerticle),
                        constraints: BoxConstraints(maxWidth: screenWidth * screenWidthRatio),
                        child: InkWell(
                          onTap: () async {
                            final result = await showEditingDialog(context, name,);
                            if (result != null && result.isNotEmpty) {
                              Tag newTag = Tag(tagId: tag.tagId, tagColor: tag.tagColor, tagName: result);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TagScreenPost(tag: newTag)),
                              );
                            }
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
                    },
                  ),
                ),
                const Flexible(
                  flex: 1,
                  child: SizedBox(width: 10,)
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
