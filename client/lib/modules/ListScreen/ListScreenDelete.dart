import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ListScreenDelete {
  final int sentenceID;
  ListScreenDelete({required this.sentenceID});

  Future<void> connectToServer() async {
    final url = Uri.parse('${dotenv.get('API_SERVER')}/list/$sentenceID');

    final res = await http.delete(url,);

    if (res.statusCode != 200) {
      throw Exception('Failed to delete');
    }
  }
}