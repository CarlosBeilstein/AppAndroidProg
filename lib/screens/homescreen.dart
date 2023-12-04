import 'package:android_prog_app/screens/drawer.dart';
import 'package:android_prog_app/screens/finance_screen.dart';
import 'package:android_prog_app/screens/news_screen_two.dart';
import 'package:flutter/material.dart';

import 'news_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 50.0),
          child: Center(child: Text("Home")),
        ),
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
          if(index == 1) {
            //Navigator.pop(context, true);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewsScreenTwo())
            );
          } else if(index == 2) {
            //Navigator.pop(context, true);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FinanceScreen())
            );
          }
        },
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [

        ],
      ),
      floatingActionButton: MyFloatingActionButton(),
    );
  }
}
