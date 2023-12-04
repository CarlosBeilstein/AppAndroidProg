import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class NewsService {
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
}

class NewsContainer extends StatelessWidget {

  late String author;
  late String title;
  late String description;

  NewsContainer({
    required this.author,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            'Author: $author',
            style: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}
