import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:loundry_app/app/core/services/location.service.dart';

class LaundryMapController extends GetxController {
  final LocationService _locationService = LocationService();

  final userPosition = Rxn<LatLng>();
  final laundryPosition = Rxn<LatLng>();
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadMapData();
  }

  Future<void> loadMapData() async {
    try {
      laundryPosition.value =
          _locationService.getLaundryLocation();

      userPosition.value =
          await _locationService.getUserLocation();
    } catch (_) {
      userPosition.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}
