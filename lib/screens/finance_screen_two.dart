import 'package:android_prog_app/model/finance_object.dart';
import 'package:android_prog_app/model/getx_controller.dart';
import 'package:android_prog_app/screens/favorite_stocks.dart';
import 'package:android_prog_app/screens/homescreen.dart';
import 'package:android_prog_app/screens/news_screen_two.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/drawer.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({Key? key}) : super(key: key);

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  FinanceController _financeController = Get.find();

  Stock? financeStock;

  @override
  void initState() {
    super.initState();
    //fetchFinances();
  }

  Future<void> fetchFinances(String stockSymbol) async {
    try {
      var result = await FinanceService.fetchFinances(stockSymbol);
      setState(() {
        financeStock = result;
      });
    } catch (e, stackTrace) {
      print('Error fetching finance data: $e');
      print('Stacktrace $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black38,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Finances",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: 2,
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewsScreenTwo()),
            );
          }
        },
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search for Stocksymbols ...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  hintStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
                onSubmitted: (query) {
                  fetchFinances(query);
                },
              ),
            ),
            financeStock != null
                ? StockContainer(
                    stock: financeStock!,
                  )
                : Container(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToFavorites,
        child: Icon(Icons.favorite),
        backgroundColor: Colors.white,
      ),
    );
  }

  void goToFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FavoriteStocks()),
    );
  }
}
