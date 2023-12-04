import 'package:flutter/material.dart';
import 'package:android_prog_app/screens/drawer.dart';
import 'package:android_prog_app/screens/finance_screen.dart';
import 'package:android_prog_app/screens/homescreen.dart';
import 'package:android_prog_app/model/news_objects.dart';

class NewsScreenTwo extends StatefulWidget {
  const NewsScreenTwo({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreenTwo> {
  late List<Map<String, dynamic>> newsList = [];
  int itemsPerPage = 15;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      var result = await NewsService.fetchNews();
      setState(() {
        // Append the new data to the existing list
        newsList.addAll(result);
      });
    } catch (e) {
      print('Error fetching news data: $e');
    }
  }

  void loadMoreItems() {
    // Increment the current page and fetch more data
    currentPage++;
    fetchData();
  }

  void loadPreviousItems() {
    if(currentPage > 0) {
      currentPage--;
      fetchData();
    } else {
      print('No more previous data');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Center(child: Text("News")),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Display loading indicator if newsList is null
            if (newsList.isEmpty)
              Center(child: CircularProgressIndicator())
            else
            // Display news containers
              ...newsList
                  .skip(currentPage * itemsPerPage)
                  .take(itemsPerPage)
                  .map((news) => NewsContainer(
                author: news['author'] ?? 'Unknown',
                title: news['title'] ?? '',
                description: news['description'] ?? '',
              )),
            // Button to load more items
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                onPressed: loadMoreItems,
                child: Text('More'),
              ),
            ),
            ElevatedButton(onPressed: loadPreviousItems, child: Text('Previous'))
          ],
        ),
      ),
      // ... (rest of your Scaffold)
    );
  }
}