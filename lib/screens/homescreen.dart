import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: Center(
          child: Container(
        child: Column(
          children: [
            Text("LOL"),
            Container(
              child: Column(
                children: [
                  Text("Test"),
                  Text("Test2"),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
