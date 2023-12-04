import 'package:android_prog_app/screens/drawer.dart';
import 'package:android_prog_app/screens/finance_screen.dart';
import 'package:android_prog_app/screens/homescreen.dart';
import 'package:android_prog_app/model/news_objects.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Center(child: Text("News")),
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph),
            label: 'Finances',
          ),
        ],
        onTap: (index) {
          if(index == 2) {
            //Navigator.pop(context, true);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FinanceScreen())
            );
          } else if(index == 0){
            //Navigator.pop(context, true);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen())
            );
          }
        },
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(onPressed: ActionButtonPressed),
    );
  }

  void ActionButtonPressed() async {
    
    var uri = Uri.parse('https://newsapi.org/v2/everything?domains=wsj.com&apiKey=e1eedf371f2642df8eb2d1a0bffc197f');
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;

      String status = jsonResponse['status'];
      int totalResults = jsonResponse['totalResults'];

      List<dynamic> articles = jsonResponse['articles'];

      if(articles.isNotEmpty) {
        Map<String, dynamic> firstArticle = articles[0];
        Map<String, dynamic> source = firstArticle['source'];
        String sourceId = source['id'];
        String sourceName = source['name'];

        String author = firstArticle['author'];
        print('Author is: ${author}');
      }

    } else {
      print('Request failed with status: ${response.statusCode}');
    } 
  }

}
