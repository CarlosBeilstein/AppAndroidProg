import 'package:android_prog_app/screens/stocks/finance_screen_two.dart';
import 'package:flutter/material.dart';
import 'package:android_prog_app/model/drawer.dart';
import 'package:android_prog_app/screens/homescreen.dart';
import 'package:android_prog_app/model/news_objects.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
  int itemsPerPage = 20;
  int currentPage = 0;

  //Search variables for Radio selection and Searchbar
  String? selectedCountry = 'us';
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
      var result = await NewsService.fetchNews(
          selectedCountry!, selectedCategory!, searchedItem!);
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Text("News", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
      //Route through the 3 Pages with NavBar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
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
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Displaying the Search Options (Radio and Searchbar)
            Column(children: [
              //Search bar
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search for keywords...',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        style: TextStyle(color: Colors.white,),
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
              // Choose Country Section
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Choose Country", style: GoogleFonts.lato(textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'us',
                          groupValue: selectedCountry,
                          onChanged: (value) {
                            setState(() {
                              selectedCountry = value;
                            });
                          },
                        ),
                        Text('USA', style: GoogleFonts.lato(textStyle: const TextStyle(color: Colors.white))),
                        Radio<String>(
                          value: 'de',
                          groupValue: selectedCountry,
                          onChanged: (value) {
                            setState(() {
                              selectedCountry = value;
                            });
                          },
                        ),
                        Text('Germany', style: GoogleFonts.lato(textStyle: const TextStyle(color: Colors.white))),
                        Radio<String>(
                          value: 'jp',
                          groupValue: selectedCountry,
                          onChanged: (value) {
                            setState(() {
                              selectedCountry = value;
                            });
                          },
                        ),
                        Text('Japan', style: GoogleFonts.lato(textStyle: const TextStyle(color: Colors.white))),
                      ],
                    ),
                  ],
                ),
              ),
              //Radio to select which Category to select
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Choose Category', style: GoogleFonts.lato(textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    Row(
                      children: [
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
                        Text('General', style: GoogleFonts.lato(textStyle: const TextStyle(color: Colors.white))),
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
                        Text('Business', style: GoogleFonts.lato(textStyle: const TextStyle(color: Colors.white))),
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
                        Text('Tech', style: GoogleFonts.lato(textStyle: const TextStyle(color: Colors.white))),
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
                        Text('Sports', style: GoogleFonts.lato(textStyle: const TextStyle(color: Colors.white))),
                      ],
                    ),
                  ]
                ),
              ),
            ]),

            // Display loading indicator if newsList is null
            if (newsList.isEmpty)
              const Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(
                    child: Text(
                  "No Search matches \nPlease look for a different topic",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                )),
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
            if (newsList.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, right: 18.0, left: 18.0),
                child: ElevatedButton(
                  onPressed: loadMoreItems,
                  child: Text('More'),
                ),
              ),
            if (newsList.isNotEmpty)
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
