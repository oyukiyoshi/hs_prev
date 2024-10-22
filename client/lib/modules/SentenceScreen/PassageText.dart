import 'package:client/modules/riverpod/PassageTextColorProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../const.dart';
import '../riverpod/PassageTextIsClickedProvider.dart';

class PassageText extends ConsumerStatefulWidget {
  final int no;
  final String content;
  final String textColorI;
  const PassageText({super.key, required this.no, required this.content, required this.textColorI});

  @override
  _PassageTextState createState() => _PassageTextState();
}

class _PassageTextState extends ConsumerState<PassageText> {
  late int no;
  late String content;
  late String textColorI;
  bool _isHovered = false;

  bool initBuild = true;

  @override
  void initState() {
    super.initState();
    no = widget.no;
    content = widget.content;
    textColorI = widget.textColorI;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final isClicked = ref.watch(clickedPassageTextProvider.select((state) => state.contains(no)));
    final textColorP = ref.watch(textColorSelectorProvider(no));

    return Padding(
      padding: const EdgeInsets.all(paddingSize),
      child: Row(
        children: [
          Text(no.toString()),
          const SizedBox(width: sizedBoxWidth),
          GestureDetector(
            onTap: () {
              if (isClicked) {
                ref.read(clickedPassageTextProvider.notifier).removeNo(no);
              } else {
                ref.read(clickedPassageTextProvider.notifier).addNo(no);
              }
            },
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isHovered = true;
                  // ここの実装は割とひどい
                  // 初めてのビルドに状態管理をもってこれない
                  // 初めてマウスオーバしたときだけ setColor
                  if (initBuild) {
                    ref.read(textColorProvider.notifier).setColor(no, textColorI);
                  }
                  initBuild = false;
                });
              },
              onExit: (_) {
                setState(() {
                  _isHovered = false;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: initBuild ?  Color(int.parse('FF${textColorI}', radix: 16)) : (textColorP != null ? Color(int.parse('FF${textColorP}', radix: 16)) : Colors.black),
                  border: (isClicked || _isHovered) 
                    ? Border.all(color: Colors.grey, width: borderWidth) 
                    : Border.all(color: Colors.transparent, width: borderWidth),
                ),
                constraints: BoxConstraints(maxWidth: screenWidth * screenWidthRatio),
                child: Text(
                  content,
                  softWrap: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}