import 'package:get/get.dart';

import '../controllers/admin_dashboard_controller.dart';

class AdminDashboradBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminDashboradController>(
      () => AdminDashboradController(),
    );
  }
}
