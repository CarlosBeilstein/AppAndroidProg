import 'package:android_prog_app/model/drawer.dart';
import 'package:android_prog_app/screens/detailed_finance_screen.dart';
import 'package:flutter/material.dart';
import 'package:android_prog_app/model/finance_object.dart';
import 'package:get/get.dart';
import 'package:mysql1/mysql1.dart';
import '../model/getx_controller.dart';

class FavoriteStocks extends StatefulWidget {
  const FavoriteStocks({super.key});

  @override
  State<FavoriteStocks> createState() => _FavoriteStocksState();
}

class _FavoriteStocksState extends State<FavoriteStocks> {
  FinanceController _financeController = Get.find();
  List<Stock> favStocks = [];
  int sizeList = 0;
  String listTest = '';

  Future<void> test() async {
    var settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: '\$SeRverPswt0182',
      db: 'appdb',
    );

    MySqlConnection conn;

    try {
      conn = await MySqlConnection.connect(settings);

      // Now you can perform database operations using the 'conn' object

      // For example, you can execute a query to fetch data
      var results = await conn.query('SELECT * FROM stockfavs');
      for (var row in results) {
        // Process the row data
        print(row);
      }
    } catch (e) {
      // Handle any errors that occurred during the database connection
      print('Error: $e');
    }
  }

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
      body: Column(
        children: [
          ElevatedButton(onPressed: test, child: Text("Penis")),
          /*
          Container(
            padding: EdgeInsets.all(8.0),
            child: _financeController.favoritesList != null ? ListView.builder(
                    itemCount: _financeController.favoritesList.length,
                    itemBuilder: (context, index) {
                      Stock favoriteStock = _financeController.favoritesList[index];
                      Color movementColor =
                          favoriteStock.priceMovement.movement == "Down" ? Colors.red : Colors.green;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DetailedFinanceScreen()),
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
                                  favoriteStock.name,
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
                              SizedBox(width: 8),
                              Padding(
                                padding: const EdgeInsets.only(top: 15, bottom: 15),
                                child: Text(
                                  "${favoriteStock.priceMovement.value}",
                                  style: TextStyle(
                                    color: movementColor,
                                  ),
                                ),
                              ),
                              SizedBox(width: 4),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 15, bottom: 15, right: 20),
                                child: Text(
                                  "${favoriteStock.priceMovement.percentage}%",
                                  style: TextStyle(
                                    color: movementColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ) : Center(
                    child: Text(
                      'Favorites list is null',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ),

           */
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pageBack,
        child: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  void pageBack() {
    Navigator.pop(context);
  }
}
