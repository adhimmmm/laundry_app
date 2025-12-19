import 'package:get/get.dart';

import '../controllers/laundry_map_controller.dart';

class LaundryMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LaundryMapController>(
      () => LaundryMapController(),
    );
  }
}
