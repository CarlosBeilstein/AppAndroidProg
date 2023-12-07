import 'package:android_prog_app/screens/drawer.dart';
import 'package:android_prog_app/screens/news_screen_two.dart';
import 'package:flutter/material.dart';
import 'homescreen.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black38,
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Center(child: Text("Finances")),
        )
      ),
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
          if(index == 0) {
            //Navigator.pop(context, true);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen())
            );
          } else if(index == 1) {
            //Navigator.pop(context, true);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewsScreenTwo())
            );
          }
        },
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          
        ],
      ),
    );
  }
}
