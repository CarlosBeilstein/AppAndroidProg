import 'package:android_prog_app/model/getx_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailedFinanceScreen extends StatefulWidget {
  const DetailedFinanceScreen({super.key});

  @override
  State<DetailedFinanceScreen> createState() => _DetailedFinanceState();
}

class _DetailedFinanceState extends State<DetailedFinanceScreen> {

  FinanceController _financeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(_financeController.companyName.value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      ),
      body: Obx( () {
        _financeController.changed();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
            ),
          ],
        );
      }),
    );
  }
}
