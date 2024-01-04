import 'package:android_prog_app/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'model/getx_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  var _financeController = Get.put(FinanceController());

  MyApp({Key? key}) : super(key: key) {
    _financeController.called.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

