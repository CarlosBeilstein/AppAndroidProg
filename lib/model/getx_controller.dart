import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class NewsController extends GetxController {

  static Future<List<Map<String, dynamic>>> fetchNews() async {
    var uri = Uri.parse('https://newsapi.org/v2/everything?domains=wsj.com&apiKey=e1eedf371f2642df8eb2d1a0bffc197f');
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      List<dynamic> articles = jsonResponse['articles'];
      return articles.map<Map<String, dynamic>>((article) => article as Map<String, dynamic>).toList();
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  var newsImageLink = ''.obs;
  var newsContent = ''.obs;
  var newsWebsiteLink = ''.obs;
  var newsTitle = ''.obs;
  var change = 0.obs;

  void changed() {
    change++;
  }
}