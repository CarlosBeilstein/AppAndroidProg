import 'dart:convert';

import 'package:android_prog_app/model/finance_object.dart';
import 'package:android_prog_app/model/getx_controller.dart';
import 'package:android_prog_app/screens/news/news_screen_two.dart';
import 'package:android_prog_app/screens/stocks/favorite_stocks.dart';
import 'package:android_prog_app/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../model/drawer.dart';

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
        backgroundColor: Colors.white,
        child: Icon(Icons.favorite, color: Colors.black,),

      ),
    );
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

  Future<void> fetchDataFromApi() async {
    try {
      if (!_financeController.called.value) {
        _financeController.called.value = true;
        String host = '192.168.0.244:8000';
        String path = '/api/FavStocks/';

        var uri = Uri.http(host, path);

        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);

          List<Stock> stockList = [];

          for (var stockData in data) {
            Stock stock = Stock.fromJson(stockData);
            stockList.add(stock);

            bool stockExists = _financeController.favoritesList.any(
                    (existingStock) =>
                existingStock.companyName == stock.companyName);

            if (!stockExists) _financeController.favoritesList.add(stock);
          }

          print('Fetched data: $data');
        } else {
          print('Failed to fetch data. Status code: ${response.statusCode}');
        }
      }
    } catch (error) {
      throw Exception('Server has probably not been started yet: $error');
    }
  }

  void goToFavorites() async {
    try {
      await fetchDataFromApi();
    } catch(error) {
      _financeController.missingServer.value = true;
      throw Exception('Server ist zur Zeit nicht online. Fehler: $error');
    } finally {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FavoriteStocks()),
      );
    }
  }
}
