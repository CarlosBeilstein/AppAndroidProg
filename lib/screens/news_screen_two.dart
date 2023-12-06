import 'package:flutter/material.dart';
import 'package:android_prog_app/screens/drawer.dart';
import 'package:android_prog_app/screens/finance_screen.dart';
import 'package:android_prog_app/screens/homescreen.dart';
import 'package:android_prog_app/model/news_objects.dart';
import 'package:get/get.dart';

class NewsScreenTwo extends StatefulWidget {
  const NewsScreenTwo({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreenTwo> {
  late List<Map<String, dynamic>> newsList = [];
  int itemsPerPage = 15;
  int currentPage = 0;
  String? selectedCountry = 'de';
  String? selectedCategory = 'business';
  late String urlToParse = 'https://newsapi.org/v2/everything?domains=wsj.com&apiKey=e1eedf371f2642df8eb2d1a0bffc197f';

  @override
  void initState() {
    super.initState();
    fetchData(selectedCountry!, selectedCategory!);
  }

  Future<void> fetchData(String country, String category) async {
    try {
      var result = await NewsService.fetchNews(country, category);
      setState(() {
        // Append the new data to the existing list
        newsList.addAll(result);
      });
    } catch (e) {
      print('Error fetching news data: $e');
    }
  }

  //reload page with new data
  Future<void> refetchData() async {
    try {
      var result = await NewsService.fetchNews(selectedCountry!, selectedCategory!);
      setState(() {
        newsList = result;
      });
    } catch (e) {
      print('Error refetching news data: $e');
    }
  }

  void loadMoreItems() {
    // Increment the current page and fetch more data
    currentPage++;
    fetchData(selectedCountry!, selectedCategory!);
  }

  void loadPreviousItems() {
    if (currentPage > 0) {
      currentPage--;
      fetchData(selectedCountry!, selectedCategory!);
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
          if (index == 0) {
            //Navigator.pop(context, true);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          } else if (index == 2) {
            //Navigator.pop(context, true);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FinanceScreen()));
          }
        },
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Row(
                children: [
                  Column(
                    children: [
                      const Text("Choose Country"),
                      Radio<String>(
                        value: 'us',
                        groupValue: selectedCountry,
                        onChanged: (value) {
                          setState(() {
                            selectedCountry = value;
                          });
                          // logic to reload page
                          refetchData();
                        },
                      ),
                      const Text('USA'),
                      Radio<String>(
                        value: 'de',
                        groupValue: selectedCountry,
                        onChanged: (value) {
                          setState(() {
                            selectedCountry = value;
                          });
                          refetchData();
                        },
                      ),
                      const Text('German'),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Choose Category"),
                      Radio<String>(
                        value: 'business',
                        groupValue: selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                          refetchData();
                        },
                      ),
                      const Text('Business'),
                      Radio<String>(
                        value: 'technology',
                        groupValue: selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                          refetchData();
                        },
                      ),
                      const Text('Technology'),
                      Radio<String>(
                        value: 'sports',
                        groupValue: selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                          refetchData();
                        },
                      ),
                      const Text('Sports'),
                      Radio<String>(
                        value: 'general',
                        groupValue: selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                          refetchData();
                        },
                      ),
                      const Text('General'),
                    ],
                  )
                ],
              ),
            ),
            // Display loading indicator if newsList is null
            if (newsList.isEmpty)
              const Center(child: CircularProgressIndicator())
            else
              // Display news containers
              ...newsList
                  .skip(currentPage * itemsPerPage)
                  .take(itemsPerPage)
                  .map((news) => NewsContainer(
                        author: news['author'] ?? 'Unknown',
                        title: news['title'] ?? '',
                        description: news['description'] ?? '',
                        urlToImage: news['urlToImage'] ??
                            'https://imgs.search.brave.com/XirYFvHdKk-Jn7nAzfal3dRlYqmsiSdEH1IkC74zBHA/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9wbHVz/cG5nLmNvbS9pbWct/cG5nL3NocmVrLWRv/bmtleS1wbmctc2Nv/cmUtMC1jYXRjaC1z/aHJlay0xODkucG5n',
                        url: news['url'] ?? '',
                        publishedAt:
                            news['publishedAt'] ?? 'Publishdate unknown',
                        content: news['content'] ?? '',
                      )),
            // Button to load more or previous items
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, right: 18.0, left: 18.0),
              child: ElevatedButton(
                onPressed: loadMoreItems,
                child: Text('More'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                  onPressed: loadPreviousItems, child: Text('Previous')),
            )
          ],
        ),
      ),
    );
  }
}
