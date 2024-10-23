import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../const.dart';
import '../riverpod/PassageTextIsClickedProvider.dart';
import '../riverpod/PassageTextColorProvider.dart';

class PassageText extends ConsumerStatefulWidget {
  final int no;
  final String content;
  final String textColor;
  const PassageText({super.key, required this.no, required this.content, required this.textColor});

  @override
  _PassageTextState createState() => _PassageTextState();
}

class _PassageTextState extends ConsumerState<PassageText> {
  late int no;
  late String content;
  late String textColor;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    no = widget.no;
    content = widget.content;
    textColor = widget.textColor;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final isClicked = ref.watch(clickedPassageTextProvider.select((state) => state.contains(no)));
    final selectedTextColor = ref.watch(textColorProvider.select((state) {
      final map = state.firstWhere(
        (map) => map.containsKey(no), 
        orElse: () => {}
      );
      return map[no];
    }));


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
                  color: selectedTextColor != null ? Color(int.parse("FF$selectedTextColor", radix: 16)) : Color(int.parse("FF$textColor", radix: 16)),
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