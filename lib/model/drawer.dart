import 'package:android_prog_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(

      child: Column(
        children: [],
      ),
    );
  }
}

class ProfileFloatingButton extends StatelessWidget {
  const ProfileFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      },

      backgroundColor: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: const Icon(Icons.person, color: Colors.white, size: 16),
    );
  }
}
