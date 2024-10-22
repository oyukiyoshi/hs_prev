import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../../const.dart';

class PassageMath extends StatelessWidget {
  const PassageMath({super.key, required this.content});
  final String content;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(paddingSize),
        child: Math.tex(
          content,
          textStyle: const TextStyle(fontSize: texFontSize),
        ),
      ),
    );
  }
}