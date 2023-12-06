import 'package:flutter/material.dart';
import 'package:android_prog_app/screens/drawer.dart';
import 'package:android_prog_app/screens/finance_screen.dart';
import 'package:android_prog_app/screens/homescreen.dart';
import 'package:android_prog_app/model/news_objects.dart';
import 'package:get/get.dart';

//Screen displaying the parsed News
class NewsScreenTwo extends StatefulWidget {
  const NewsScreenTwo({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreenTwo> {

  //List that saves the news
  late List<Map<String, dynamic>> newsList = [];

  //In order not to load too much data onto the Screen at a time
  int itemsPerPage = 15;
  int currentPage = 0;

  //Search variables for Radio selection and Searchbar
  String? selectedCountry = 'de';
  String? selectedCategory = 'general';
  String? searchedItem = '';

  @override
  void initState() {
    super.initState();
    fetchData(selectedCountry!, selectedCategory!, searchedItem!);
  }

  //Fetching Data from API for the first time
  Future<void> fetchData(
      String country, String category, String searchItem) async {
    try {
      var result = await NewsService.fetchNews(country, category, searchItem);
      setState(() {
        // Append the new data to the existing list
        newsList.addAll(result);
      });
    } catch (e) {
      print('Error fetching news data: $e');
    }
  }

  //refetching changed data after changing search option (through radio or search bar)
  Future<void> refetchData() async {
    try {
      var result =
          await NewsService.fetchNews(selectedCountry!, selectedCategory!, searchedItem!);
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
    fetchData(selectedCountry!, selectedCategory!, searchedItem!);
  }

  void loadPreviousItems() {
    if (currentPage > 0) {
      currentPage--;
      fetchData(selectedCountry!, selectedCategory!, searchedItem!);
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
      //Route through the 3 Pages with NavBar
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
      //Display of the newsContainer
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              //Displaying the Search Options (Radio and Searchbar)
              child: Row(
                children: [
                  //Radio to select which country to choose from
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
                  //Radio to select which Category to select
                  Column(
                    children: [
                      const Text("Choose Category"),
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
                    ],
                  ),
                  //Searchbar
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (query) {
                          searchedItem = query;
                          print(searchedItem?.length);
                          refetchData();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Display loading indicator if newsList is null
            if (newsList.isEmpty)
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: const Center(child: Text("No Search matches \nPlease look for a different topic", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)),
              )
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

            //If the list is empty theres no reason to show the Buttons that load more or previous News
            if(newsList.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, right: 18.0, left: 18.0),
                child: ElevatedButton(
                  onPressed: loadMoreItems,
                  child: Text('More'),
                ),
              ),
            if(newsList.isNotEmpty)
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
