import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            child: Text("Test"),
          ),
          Container(
            child: Text("Test2"),
          )
        ],
      ),
    );
  }
}
