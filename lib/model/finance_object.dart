import 'dart:convert';
import 'package:android_prog_app/model/getx_controller.dart';
import 'package:android_prog_app/screens/detailed_finance_screen.dart';
import 'package:android_prog_app/screens/finance_screen_two.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FinanceService extends FinanceScreen {
  static Future<List<Map<String, dynamic>>> fetchFinances(String trend, String index_market) async {
    //API key used for website
    var apiKey = 'e59d46616ea3f01345fea60f723844ca7a2e8b3028c2ac6b69fa29332c1889b6';
    var url = 'https://serpapi.com/search.html?engine=google_finance_markets&trend=cryptocurrencies&hl=en&api_key=${apiKey}';

    /*
    if (trend.length > 0) {
      if (trend == "indexes" && index_market.length > 0) {
        url =
            'https://serpapi.com/search.html?engine=google_finance_markets&trend=${trend}&hl=en&index_markets=${index_market}&api_key=${apiKey}';
      } else {
        url =
            'https://serpapi.com/search.html?engine=google_finance_markets&trend=${trend}&hl=en&api_key=${apiKey}';
      }
    }
    */

    var uri = Uri.parse(url);
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List<Map<String, dynamic>> stocks = [];

      if (jsonResponse.containsKey('market_trends')) {
        List<dynamic> marketTrends = jsonResponse['market_trends'];

        for (var trend in marketTrends) {
          if (trend.containsKey('results')) {
            List<dynamic> results = trend['results'];

            for (var result in results) {
              stocks.add(result as Map<String, dynamic>);
            }
          }
        }
        // Bring every Listitem into a Map for easier use
        List<Map<String, dynamic>> stockList = stocks.map((stock) {
          return stock as Map<String, dynamic>;
        }).toList();

        return stockList;
      } else {
        throw Exception('Missing expected keys in the JSON response');
      }
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }
}

class StockContainer extends StatelessWidget {
  var _financeController = Get.put(FinanceController());

  late String stocks;
  late String name;
  late String price;
  late PriceMovement priceMovement;

  StockContainer({
    required this.stocks,
    required this.name,
    required this.price,
    required this.priceMovement,
  });

  @override
  Widget build(BuildContext context) {
    Color movementColor =
        priceMovement.movement == "Down" ? Colors.red : Colors.green;

    return GestureDetector(
      onTap: () {
        _financeController.name.value = name;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailedFinanceScreen()),
        );
      },
      child: Container(
        child: Row(
          children: [
            Text(name),
            SizedBox(width: 8),
            Text(price),
            SizedBox(width: 8),
            Text(
              "${priceMovement.value}",
              style: TextStyle(
                color: movementColor,
              ),
            ),
            SizedBox(width: 4),
            Text(
              "${priceMovement.percentage}",
              style: TextStyle(
                color: movementColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PriceMovement {
  late double percentage;
  late double value;
  late String movement;

  PriceMovement({
    required this.percentage,
    required this.value,
    required this.movement,
  });
}
