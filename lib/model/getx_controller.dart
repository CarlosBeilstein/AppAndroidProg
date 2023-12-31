import 'package:android_prog_app/model/finance_object.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

//Controller that helps to move towards the detailed NewsScreen
class NewsController extends GetxController {

  //values that the controller uses
  var urlToParse = ''.obs;
  var newsImageLink = ''.obs;
  var newsContent = ''.obs;
  var newsWebsiteLink = ''.obs;
  var newsTitle = ''.obs;
  var change = 0.obs;

  //method to prevent mistakes -> any time controller is used smth happens
  void changed() {
    change++;
  }
}

class FinanceController extends GetxController {

  //values that the controller uses
  var name = ''.obs;
  var companyName = ''.obs;
  var value = ''.obs;
  var change = 0.obs;
  var favoritesList = [].obs;

  //method to prevent mistakes -> any time controller is used smth happens
  void changed(){
    change++;
  }

}