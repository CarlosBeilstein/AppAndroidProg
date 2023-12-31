import 'dart:convert';
import 'package:android_prog_app/model/getx_controller.dart';
import 'package:android_prog_app/screens/detailed_finance_screen.dart';
import 'package:android_prog_app/screens/finance_screen_two.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FinanceService extends FinanceScreen {
  static Future<Stock?> fetchFinances() async {
    try {
      var apiKey = 'pk_3adfacdee30c4a909c0be1dcb6e9c8d8';
      var url =
          'https://api.iex.cloud/v1/data/core/quote/CTTAF?token=${apiKey}';
      var uri = Uri.parse(url);
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        if (jsonResponse != null && jsonResponse is List && jsonResponse.isNotEmpty) {
          var firstObject = jsonResponse[0];

          if (firstObject is Map<String, dynamic>) {
            String companyName = firstObject['companyName'];
            double price = firstObject['latestPrice'];
            double change = firstObject['change'];
            double changePercent = firstObject['changePercent'].toDouble();

            return Stock(
              name: companyName,
              price: price,
              priceMovement: PriceMovement(
                value: change,
                percentage: changePercent * 100,
                movement: change < 0 ? "Down" : "Up",
              ),
            );
          } else {
            throw Exception('Invalid JSON format inside the array');
          }
        } else {
          throw Exception('Invalid JSON format or empty array response');
        }
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

}

class StockContainer extends StatelessWidget {
  var _financeController = Get.put(FinanceController());

  final Stock stock;

  StockContainer({
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    Color movementColor = stock.priceMovement.movement == "Down" ? Colors.red : Colors.green;

    return GestureDetector(
      onTap: () {
        _financeController.name.value = stock.name;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailedFinanceScreen()),
        );
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                child: Text(stock.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15, right: 30),
                child: Text(stock.price.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              ),
              SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Text(
                  "${stock.priceMovement.value}",
                  style: TextStyle(
                    color: movementColor,
                  ),
                ),
              ),
              SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15, right: 20),
                child: Text(
                  "${stock.priceMovement.percentage}%",
                  style: TextStyle(
                    color: movementColor,
                  ),
                ),
              ),
              ElevatedButton(onPressed: addToWatchList, child: Icon(Icons.add)),
            ],
          ),
        ),
      ),
    );
  }

  void addToWatchList() {

  }
}

class Stock {
  late String name;
  late double price;
  late PriceMovement priceMovement;

  Stock({
    required this.name,
    required this.price,
    required this.priceMovement,
  });
}

class PriceMovement {
  late double value;
  late double percentage;
  late String movement;

  PriceMovement({
    required this.value,
    required this.percentage,
    required this.movement,
  });
}