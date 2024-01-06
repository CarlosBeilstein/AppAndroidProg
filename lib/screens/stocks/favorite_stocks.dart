import 'dart:convert';

import 'package:android_prog_app/model/drawer.dart';
import 'package:flutter/material.dart';
import 'package:android_prog_app/model/finance_object.dart';
import 'package:get/get.dart';
import '../../model/getx_controller.dart';
import 'detailed_finance_screen.dart';
import 'package:http/http.dart' as http;

class FavoriteStocks extends StatefulWidget {
  const FavoriteStocks({super.key});

  @override
  State<FavoriteStocks> createState() => _FavoriteStocksState();
}

class _FavoriteStocksState extends State<FavoriteStocks> {
  FinanceController _financeController = Get.find();
  List<Stock> favStocks = [];
  int sizeList = 0;

  String authToken = 'b54494753f08165db6b3d796d5925cf85ae0990e';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black38,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("My favorites to watch",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      drawer: MyDrawer(),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: _financeController.favoritesList != null
            ? ListView.builder(
                itemCount: _financeController.favoritesList.length,
                itemBuilder: (context, index) {
                  Stock favoriteStock = _financeController.favoritesList[index];
                  Color movementColor =
                      favoriteStock.priceMovement.movement == "Down"
                          ? Colors.red
                          : Colors.green;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailedFinanceScreen()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 15, bottom: 15),
                            child: Text(
                              insertLineBreaks(favoriteStock.name, 20),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, bottom: 15, right: 30),
                            child: Text(
                              favoriteStock.price.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
                            child: Text(
                              "${favoriteStock.priceMovement.value}",
                              style: TextStyle(
                                color: movementColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Padding(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            child: Container(
                              width: 40,
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    removeFromFavList(favoriteStock);
                                  },
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
                                      Icons.remove,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: Text(
                  'Favorites list is null',
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pageBack,
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
    );
  }

  String insertLineBreaks(String text, int breakInterval) {
    StringBuffer result = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      result.write(text[i]);
      if ((i + 1) % breakInterval == 0 && i + 1 != text.length) {
        result.write('\n');
      }
    }
    return result.toString();
  }

  void removeFromFavList(Stock stock) async {
    _financeController.called.value = false;
    setState(() {
      _financeController.favoritesList.remove(stock);
      print(stock.name);
    });

    await removeDataOnServer(stock);

  }

  Future<void> removeDataOnServer(Stock stock) async {

    String host = 'localhost:8000';
    String path = '/update/${stock.companyName}/';
    print(host + path);
    var uri = Uri.http(host, path);

    try {

      var requestData = stock.toJson();
      final response = await http.post(
        uri,
        headers: <String, String> {
          'Content-Type': 'application/json; charset=utf-8',
          //'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(requestData),
      );
      if(response.statusCode == 204) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Server response: $responseData');
      } else {
        throw Exception('Daten wurden nicht gesendet. Status code ${response.statusCode}');
      }
    } catch(error) {
      throw Exception('Fehler beim senden: $error');
    }

  }

  void pageBack() {
    Navigator.pop(context);
  }
}
