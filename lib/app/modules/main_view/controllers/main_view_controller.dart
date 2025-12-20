import 'package:get/get.dart';

class MainViewController extends GetxController {
  //TODO: Implement MainViewController

   var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

}
