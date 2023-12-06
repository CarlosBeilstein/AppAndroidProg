import 'package:android_prog_app/model/getx_controller.dart';
import 'package:android_prog_app/screens/detailed_news_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class NewsService {
  static Future<List<Map<String, dynamic>>> fetchNews() async {
    var uri = Uri.parse('https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=e1eedf371f2642df8eb2d1a0bffc197f');
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      List<dynamic> articles = jsonResponse['articles'];

      // Modify the parsing logic to add a line break after a comma in the text
      List<Map<String, dynamic>> parsedArticles = articles.map<Map<String, dynamic>>((article) {
        if (article['author'] is String && article['author'].contains(',')) {
          // If 'author' contains a comma, replace it with a comma and a line break
          article['author'] = article['author'].replaceAll(',', ',\n');
        }
        if (article['publishedAt'] is String) {
          article['publishedAt'] = article['publishedAt'].replaceAll('T', ' at ');
        }
        return article as Map<String, dynamic>;
      }).toList();

      return parsedArticles;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }
}

class TechNewsContainer extends StatelessWidget {

  var _controller = Get.put(NewsController());

  late String author;
  late String title;
  late String description;
  late String urlToImage;
  late String url;
  late String publishedAt;
  late String content;

  TechNewsContainer({
    required this.author,
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.url,
    required this.publishedAt,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.newsImageLink.value = urlToImage;
        _controller.newsContent.value = content;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailedNewsScreen()),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(urlToImage),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  Text(
                    '$author',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Spacer(),
                  Text(
                    '$publishedAt',
                    style: GoogleFonts.lato(),
                  )
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Title: $title',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Description: $description',
            ),
          ],
        ),
      ),
    );
  }
}
