import 'package:get/get.dart';

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

  //values to check for Server
  var called = false.obs;
  var missingServer = false.obs;
  //values that the controller uses
  var name = ''.obs;
  var companyName = ''.obs;
  var value = ''.obs;
  var change = 0.obs;
  var favoritesList = [].obs;

  //values for detailedFinanceScreen
  var ceo = ''.obs;
  var location = ''.obs;
  var country = ''.obs;
  var exchange = ''.obs;
  var industry = ''.obs;
  var sector = ''.obs;

  //method to prevent mistakes -> any time controller is used smth happens
  void changed(){
    change++;
  }

}