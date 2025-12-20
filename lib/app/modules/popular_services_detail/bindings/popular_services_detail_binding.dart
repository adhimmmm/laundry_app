import 'package:get/get.dart';

import '../controllers/popular_services_detail_controller.dart';

class PopularServicesDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PopularServicesDetailController>(
      () => PopularServicesDetailController(),
    );
  }
}
