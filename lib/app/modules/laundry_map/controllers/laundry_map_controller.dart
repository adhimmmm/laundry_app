import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:loundry_app/app/core/services/location.service.dart';

class LaundryMapController extends GetxController {
  final LocationService _locationService = Get.find();

  final userPosition = Rxn<LatLng>();
  final laundryPosition = Rxn<LatLng>();
  final distanceToLaundry = RxnDouble();

  final isLoading = true.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadMapData();
  }

  Future<void> loadMapData() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final laundry = _locationService.getLaundryLocation();
      final user = await _locationService.getUserLocation();

      laundryPosition.value = laundry;
      userPosition.value = user;

      distanceToLaundry.value =
          _locationService.calculateDistance(
        user: user,
        laundry: laundry,
      );
    } catch (e) {
      errorMessage.value = 'Gagal mendapatkan lokasi pengguna';
      userPosition.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}
