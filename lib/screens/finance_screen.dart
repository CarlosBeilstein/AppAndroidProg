import 'package:android_prog_app/screens/drawer.dart';
import 'package:flutter/material.dart';
import 'homescreen.dart';
import 'news_screen.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Center(child: Text("Finances")),
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
          if(index == 0) {
            Navigator.pop(context, true);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen())
            );
          } else if(index == 1) {
            Navigator.pop(context, true);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewsScreen())
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