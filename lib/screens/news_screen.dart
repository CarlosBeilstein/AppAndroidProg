import 'package:android_prog_app/screens/drawer.dart';
import 'package:android_prog_app/screens/finance_screen.dart';
import 'package:android_prog_app/screens/homescreen.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Center(child: Text("News")),
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
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
          if(index == 2) {
            Navigator.pop(context, true);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FinanceScreen())
            );
          } else if(index == 0){
            Navigator.pop(context, true);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen())
            );
          }
        },
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Center(
              child: Container(
                color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text("Test"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
