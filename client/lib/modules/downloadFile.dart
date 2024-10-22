import 'dart:html' as html;
import 'package:http/http.dart' as http;

Future<void> downloadFile(String url, String fileName) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final blob = html.Blob([response.bodyBytes]);
    final urlBlob = html.Url.createObjectUrlFromBlob(blob);

    // aタグ作成 → クリック
    html.AnchorElement(href: urlBlob)
      ..setAttribute('download', fileName)
      ..click();

    html.Url.revokeObjectUrl(urlBlob);
  } else {
    print('${response.statusCode}');
  }
}
