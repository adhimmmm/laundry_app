import 'package:get/get.dart';

import '../controllers/main_view_controller.dart';

class MainViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainViewController>(
      () => MainViewController(),
    );
  }
}
