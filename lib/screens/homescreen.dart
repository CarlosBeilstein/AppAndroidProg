import 'package:flutter/material.dart';

import 'news_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text("Home"),
            ),
            Spacer(), // Add Spacer widget to push the Image to the right
            Image.asset(
              'lib/assets/images/Logo.png',
              height: 50,
              width: 50,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if(index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewsScreen())
            );
          }
        },
      ),
      drawer: Drawer(),
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
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Center(
              child: Container(
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    'lib/assets/images/QRTest.png',
                    height: 300,
                    width: 300,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
