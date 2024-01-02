import 'package:android_prog_app/model/drawer.dart';
import 'package:android_prog_app/model/getx_controller.dart';
import 'package:android_prog_app/screens/finance_screen_two.dart';
import 'package:android_prog_app/screens/news_screen_two.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  var _financeController = Get.put(FinanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Padding(
          padding: const EdgeInsets.only(right: 50.0),
          child: Center(child: Text("Home", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: 0,
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
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
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
      floatingActionButton: ProfileFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      drawer: MyDrawer(),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
