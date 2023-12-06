import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class NewsController extends GetxController {

  var urlToParse = ''.obs;
  var newsImageLink = ''.obs;
  var newsContent = ''.obs;
  var newsWebsiteLink = ''.obs;
  var newsTitle = ''.obs;
  var change = 0.obs;

  void changed() {
    change++;
  }
}