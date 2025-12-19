import 'package:get/get.dart';
import 'package:loundry_app/app/core/services/location.service.dart';
import '../controllers/laundry_map_controller.dart';

class LaundryMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationService>(() => LocationService());
    Get.lazyPut<LaundryMapController>(
        () => LaundryMapController());
  }
}
