import 'package:android_prog_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      backgroundColor: Color.fromARGB(255, 73, 73, 73),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Text(
              "Carlos Beilstein",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
            SizedBox(height: 15),
            Text(
              "Email: carlos.beilstein@informatik.hs-fulda.de",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            SizedBox(height: 15),
            Text(
              "Settings",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            SizedBox(height: 15),
            Text(
              "Account Info",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      )
    );
  }
}

class ProfileFloatingButton extends StatelessWidget {
  const ProfileFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
      backgroundColor: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: const Icon(Icons.person, color: Colors.white, size: 16),
    );
  }
}
