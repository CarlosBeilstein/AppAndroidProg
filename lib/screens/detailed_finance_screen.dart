import 'package:android_prog_app/model/getx_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailedFinanceScreen extends StatelessWidget {
  DetailedFinanceScreen({super.key});

  FinanceController _financeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_financeController.name.value),
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
