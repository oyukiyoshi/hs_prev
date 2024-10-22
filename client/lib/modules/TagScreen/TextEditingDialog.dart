import 'package:flutter/material.dart';
import '../../const.dart';

/// 状態を持ったダイアログ
class TextEditingDialog extends StatefulWidget {
  const TextEditingDialog({super.key, required this.text});
  final String? text;

  @override
  State<TextEditingDialog> createState() => _TextEditingDialogState();
}

class _TextEditingDialogState extends State<TextEditingDialog> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // TextFormFieldに初期値を代入する
    controller.text = widget.text ?? '';
    focusNode.addListener(
      () {
        // フォーカスが当たったときに文字列が選択された状態にする
        if (focusNode.hasFocus) {
          controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextFormField(
        autofocus: true, // ダイアログが開いたときに自動でフォーカスを当てる
        focusNode: focusNode,
        controller: controller,
        onFieldSubmitted: (_) {
          // エンターを押したときに実行される
          Navigator.of(context).pop(controller.text);
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(controller.text);
          },
          child: const Text(changeText),
        )
      ],
    );
  }
}

Future<String?> showEditingDialog (BuildContext context, String text) async {
  return showDialog<String>(
    context: context,
    builder: (context) => TextEditingDialog(text: text,),
  );
}

// [ダイアログでもテキスト入力がしたい](https://zenn.dev/pressedkonbu/books/flutter-reverse-lookup-dictionary/viewer/016-input-text-on-dialog)