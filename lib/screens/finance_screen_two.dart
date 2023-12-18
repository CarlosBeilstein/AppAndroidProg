import 'package:android_prog_app/model/finance_object.dart';
import 'package:android_prog_app/screens/homescreen.dart';
import 'package:android_prog_app/screens/news_screen_two.dart';
import 'package:flutter/material.dart';

import '../model/drawer.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  late List<Map<String, dynamic>> financeList = [];

  String? trend = 'indexes';
  String? index_market = 'americas';

  @override
  void initState() {
    super.initState();
    fetchFinances(trend!, index_market!);
  }

  Future<void> fetchFinances(String trend, String index_market) async {
    try {
      var result = await FinanceService.fetchFinances(trend, index_market);
      setState(() {
        // Append the new data to the existing list
        financeList.addAll(result);
      });
    } catch (e, stackTrace) {
      print('Error fetching news data: $e');
      print('Stacktrace $stackTrace');
    }
  }

  Future<void> reFetchFinances() async {
    try {
      var result = await FinanceService.fetchFinances(trend!, index_market!);
      setState(() {
        financeList.addAll(result);
      });
    } catch (e) {
      print('Du bist zu dumm um es richtig hinzubekommmen! Problem: $e');
    }
  }

  void loadStocks() {
    reFetchFinances();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black38,
          title: Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Center(child: Text("Finances")),
          )),
      bottomNavigationBar: BottomNavigationBar(
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
        onTap: (index) {
          if (index == 0) {
            //Navigator.pop(context, true);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          } else if (index == 1) {
            //Navigator.pop(context, true);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewsScreenTwo()));
          }
        },
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: loadStocks, child: Text("Hole Aktien")),

            if (financeList.isEmpty)
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Finance list is empty',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
              )
            else
              ...financeList
                  .take(10)
                  .map((finances) => StockContainer(
                name: finances['name'],
                price: finances['price'],
                priceMovement: PriceMovement(
                  percentage: finances['price_movement']['percentage'],
                  value: finances['price_movement']['value'],
                  movement: finances['price_movement']['movement'],
                ),
                stocks: finances['stocks'],
              ))

          ],
        ),
      ),
    );
  }
}
