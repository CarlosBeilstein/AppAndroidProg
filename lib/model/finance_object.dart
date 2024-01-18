import 'dart:convert';
import 'package:android_prog_app/model/getx_controller.dart';
import 'package:android_prog_app/screens/stocks/detailed_finance_screen.dart';
import 'package:android_prog_app/screens/stocks/finance_screen_two.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FinanceService extends FinanceScreen {
  static Future<Stock?> fetchFinances(String stockSymbol) async {
    try {
      var apiKey = 'sk_7b9182ea04824f24b2518ddad1a94ddf';
      var url = 'https://api.iex.cloud/v1/data/core/quote/MSFT?token=$apiKey';
      if (stockSymbol.length > 0) {
        url =
            'https://api.iex.cloud/v1/data/core/quote/$stockSymbol?token=$apiKey';
      }
      var uri = Uri.parse(url);
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        if (jsonResponse != null &&
            jsonResponse is List &&
            jsonResponse.isNotEmpty) {
          var firstObject = jsonResponse[0];

          if (firstObject is Map<String, dynamic>) {
            String companyName = firstObject['companyName'];
            String companySymbol = companyName;
            if (companyName.length >= 10) companySymbol = stockSymbol.toUpperCase();
            double price = firstObject['latestPrice'];
            double change = firstObject['change'];
            //double changePercent = firstObject['changePercent'].toDouble();

            return Stock(
              name: companySymbol,
              companyName: companyName,
              price: price,
              added: false,
              priceMovement: PriceMovement(
                value: change,
                //percentage: lastChangePercent * 100,
                movement: change < 0 ? "Down" : "Up",
              ),
            );
          } else {
            return Stock(
                name: 'Unknown Stock Symbol',
                companyName: '',
                added: false,
                price: 0,
                priceMovement:
                    PriceMovement(value: 0, /*percentage: 0,*/ movement: 'Down'));
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
  FinanceController _financeController = Get.find();

  final Stock stock;
  //ServerCall
  String authToken = 'b54494753f08165db6b3d796d5925cf85ae0990e';
  //Size of String 'companyName' before Line break in Row
  int LINEBREAKINTERVAL = 20;

  StockContainer({
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    Color movementColor =
        stock.priceMovement.movement == "Down" ? Colors.red : Colors.green;
    return GestureDetector(
      onTap: () {
        if (_financeController.companyName.value.length <= 30) {
          _financeController.companyName.value = stock.companyName;
        } else {
          _financeController.companyName.value =
              stock.companyName.substring(0, 30);
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailedFinanceScreen()),
        );
      },
      //Container description
      child: Column(
        children: [
          const Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  "Name",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),//Name
              Spacer(),
              Text(
                "Last sold Price",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ), //Price
              SizedBox(width:20),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Text(
                  "Add to Fav",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ), //Button
            ],
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white)),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                  child: Text(
                    insertLineBreaks(stock.companyName, LINEBREAKINTERVAL),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ), //Name
                const Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 15, bottom: 15, right: 30),
                  child: Text(
                    stock.price.toString(),
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ), //Price
                const SizedBox(width: 8),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 15, bottom: 15),
                  child: Container(
                    width: 40,
                    child: Text(
                      "${stock.priceMovement.value}",
                      style: TextStyle(
                        color: movementColor,
                      ),
                    ),
                  ),
                ),//Change Value
                const SizedBox(width: 8),
                /*
                Padding(
                  padding:
                      const EdgeInsets.only(top: 15, bottom: 15, right: 20),
                  child: Text(
                    "${stock.priceMovement.percentage}%",
                    style: TextStyle(
                      color: movementColor,
                    ),
                  ),
                ), */ //Change percentage that was in for testing (maybe will become important again)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    width: 40,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: addToWatchList,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            // Adjust the border radius as needed
                          ),
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.favorite,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),//AddButton
              ],
            ),
          ),
        ],
      ),
    );
  }

  String insertLineBreaks(String text, int breakInterval) {
    StringBuffer result = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      result.write(text[i]);
      if ((i + 1) % breakInterval == 0 && i + 1 != text.length) {
        result.write('...');
        break;
      }
    }
    return result.toString();
  }
  
  void addToWatchList() {
    // to remember whether the backend call has been done or not so the
    // list wont build multiple times
    _financeController.called.value = false;

    if (stock.added == false) {
      stock.added = true;
    } else {
      stock.added = false;
    }

    for (int i = 0; i < _financeController.favoritesList.length; i++) {
      if (_financeController.favoritesList[i].name == stock.name) {
        print('already in list');
        return;
      }
    }

    if (stock.name == 'Unknown Stock Symbol' || stock.name == '') return;
    sendDataToServer();
    _financeController.favoritesList.add(stock);
    print('added: ' +
        _financeController
            .favoritesList[_financeController.favoritesList.length - 1].name +
        ' to favs');
  }

  Future<void> sendDataToServer() async {

    String host = '192.168.0.244:8000';
    String path = '/api/FavStocks/';
    var uri = Uri.http(host, path);

    try {

      var requestData = stock.toJson();

      final response = await http.post(
        uri,
        headers: <String, String> {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $authToken'
        },
        body: jsonEncode(requestData),
      );
      if(response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return;//print('Server response: $responseData');
      }
      if(response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Server response: $responseData');
      } else {
        throw Exception('Daten wurden nicht gesendet. Status code: ${response.statusCode}');
      }

    } catch (error) {
      throw Exception('Fehler beim senden der Daten: $error');
    }
  }
}

class Stock {
  late String name;
  late String companyName;
  late double price;
  late PriceMovement priceMovement;
  late bool added = false;

  Stock({
    required this.name,
    required this.companyName,
    required this.price,
    required this.priceMovement,
    required this.added,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
        name: json['companyName'] ?? 'Unknown Stock symbol',
        companyName: json['companyName'] ?? '',
        price: json['price']?.toDouble() ?? 0.0,
        added: json['added'] ?? false,
        priceMovement: PriceMovement(
          value: json['change']?.toDouble() ?? 0.0,
          //percentage: json['changePer']?.toDouble() ?? 0.0,
          movement: json['movement'] ?? 'Down',
        ));
  }

  Map<String, dynamic> toJson() {
    return {
      'name': companyName,
      'companyName': companyName,
      'price': price,
      'added': added,
      'change': priceMovement.value,
      //'changePer': priceMovement.percentage,
      'movement': priceMovement.movement,
    };
  }
}

class PriceMovement {
  late double value;
  //late double percentage;
  late String movement;

  PriceMovement({
    required this.value,
    //required this.percentage,
    required this.movement,
  });
}
