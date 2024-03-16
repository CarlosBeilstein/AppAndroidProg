import 'package:android_prog_app/model/getx_controller.dart';
import 'package:android_prog_app/screens/news/detailed_news_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../screens/news/news_screen_two.dart';

class NewsService extends NewsScreenTwo {

  //Method to prase Data from NewsAPI
  static Future<List<Map<String, dynamic>>> fetchNews(String country, String category, String searchedItem) async {
    //API key used for website (f at the very end after 197 to complete key)
    var apiKey = 'e1eedf371f2642df8eb2d1a0bffc197f';
    //parse following link if searchbar hasn't been used at all
    var uri = Uri.parse('https://newsapi.org/v2/top-headlines?country=$country&category=$category&apiKey=$apiKey');
    if(searchedItem.length > 0) {
      //use this link if searchbar has been used
      uri = Uri.parse('https://newsapi.org/v2/top-headlines?q=$searchedItem&country=$country&category=$category&apiKey=$apiKey');
    }
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      List<dynamic> articles = jsonResponse['articles'];

      // Bring every Listitem into a Map for easier use
      // Modify the parsing logic to add a line break after a comma in the text to prevent spillage over screenedges
      List<Map<String, dynamic>> parsedArticles = articles.map<Map<String, dynamic>>((article) {
        if (article['author'] is String && article['author'].contains(',')) {
          // If 'author' contains a comma, replace it with a comma and a line break (there can be multiple authors which would cause spillage)
          article['author'] = article['author'].replaceAll(',', ',\n');
        }
        //remove time of day the article was published (unnecessary information and can cause spillage)
        if (article['publishedAt'] is String) {
          String originalString = article['publishedAt'];
          int indexOfT = originalString.indexOf('T');

          if (indexOfT != -1) {
            // If 'T' is found, get the substring before 'T'
            article['publishedAt'] = originalString.substring(0, indexOfT);
          } else {
            // 'T' not found in the string, keep the original string
            article['publishedAt'] = originalString;
          }
        }

        return article as Map<String, dynamic>;
      }).toList();

      return parsedArticles;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

}

//to build my own newsContainer
class NewsContainer extends StatelessWidget {

  final _newsController = Get.put(NewsController());

  late String author;
  late String title;
  late String description;
  late String urlToImage;
  late String url;
  late String publishedAt;
  late String content;

  NewsContainer({
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
      //when clicked on any newsContainer
      onTap: () {
        //values passed to new Screen with Get Controller
        _newsController.newsImageLink.value = urlToImage;
        _newsController.newsContent.value = content;
        _newsController.newsWebsiteLink.value = url;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailedNewsScreen()),
        );
      },
      //Layout of the NewsContainer
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              urlToImage,
              fit: BoxFit.fitHeight,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
              child: Row(
                children: [
                  Text(
                    author,
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    publishedAt,
                    style: GoogleFonts.lato(),
                  )
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Title: $title',
              style: GoogleFonts.playfairDisplay(
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ),
            const SizedBox(height: 8),
            Text(
              'Description: $description',
              style: GoogleFonts.lato(),
            ),
          ],
        ),
      ),
    );
  }
}
