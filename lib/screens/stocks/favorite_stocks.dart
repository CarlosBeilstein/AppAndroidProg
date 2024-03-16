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
  //Size of String of name on detailed Finance Screen
  int NAMESIZE = 20;
  //Size of String 'companyName' before Line break in Row
  int LINEBREAKINTERVAL = 20;

  String authToken = 'b54494753f08165db6b3d796d5925cf85ae0990e';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black38,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("My favorites to watch",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      drawer: const MyDrawer(),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: _financeController.missingServer == true
            ? const Center(
                child: Text('Server is not online', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
              )
          : _financeController.favoritesList != null
            ? ListView.builder(
                itemCount: _financeController.favoritesList.length,
                itemBuilder: (context, index) {
                  _financeController.favoritesList.sort((a, b) {
                    return b.price.compareTo(a.price);
                  });
                  Stock favoriteStock = _financeController.favoritesList[index];
                  Color movementColor =
                      favoriteStock.priceMovement.movement == "Down"
                          ? Colors.red
                          : Colors.green;
                  return GestureDetector(
                    //Padding of the Favorite Stock Container Row
                    child: Padding(
                      padding: const EdgeInsets.only(top: 14.0),
                      child: Container(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 15, bottom: 15),
                              child: Text(
                                insertLineBreaks(favoriteStock.companyName, LINEBREAKINTERVAL),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ), //Name
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, bottom: 15, right: 30),
                              child: Text(
                                favoriteStock.price.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ), //Price
                            Padding(
                              padding: const EdgeInsets.only(top: 15, bottom: 15),
                              child: Container(
                                width: 40,
                                child: Text(
                                  "${favoriteStock.priceMovement.value}",
                                  style: TextStyle(
                                    color: movementColor,
                                  ),
                                ),
                              ),
                            ), //Price Change
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
                            ), //RemoveButton
                          ],
                        ),
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
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
    );
  }

  String insertLineBreaks(String text, int breakInterval) {
    StringBuffer result = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      result.write(text[i]);
      if ((i + 1) % breakInterval == 0 && i + 1 != text.length) {
        result.write(' ...');
        break;
      }
    }
    return result.toString();
  }

  void removeFromFavList(Stock stock) async {
    _financeController.called.value = false;
    setState(() {
      _financeController.favoritesList.remove(stock);
      //print(stock.name);
    });

    await removeDataOnServer(stock);
  }

  Future<void> removeDataOnServer(Stock stock) async {
    String host = '192.168.0.246:8000';
    String path = '/update/${stock.companyName}/';
    //print(host + path);
    var uri = Uri.http(host, path);

    try {
      var requestData = stock.toJson();
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
          //'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(requestData),
      );
      if (response.statusCode == 204) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        //print('Server response: $responseData');
      } else if(response.statusCode == 200) {
        //final Map<String, dynamic> responseData = jsonDecode(response.body);
        return; //print('Server response: $responseData');
      } else {
        throw Exception('Daten wurden nicht gesendet. Status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Fehler beim senden: $error');
    }
  }

  void pageBack() {
    Navigator.pop(context);
  }
}
