import 'package:android_prog_app/model/drawer.dart';
import 'package:android_prog_app/screens/news/news_screen_two.dart';
import 'package:android_prog_app/screens/stocks/finance_screen_two.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('MMMM dd, yyyy').format(now);
    final formattedTime = DateFormat('HH:mm:ss').format(now);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        //To Hide the Hamburger Drawer Icon since I'm using the profile button
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Padding(
          padding: EdgeInsets.only(right: 50.0),
          child: Center(child: Text("", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: 0,
        items: const [
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
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewsScreenTwo())
            );
          } else if(index == 2) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FinanceScreen())
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: const ProfileFloatingButton(),
      drawer: const MyDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Today is $formattedDate',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Time logged on: $formattedTime',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 150),
            const Text(
              'Stay up-to-date with the latest\n      news and stock prices',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
