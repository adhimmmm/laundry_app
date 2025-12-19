import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/laundry_map_controller.dart';

class LaundryMapView extends GetView<LaundryMapController> {
  const LaundryMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laundry Location')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final LatLng center =
            controller.userPosition.value ??
            controller.laundryPosition.value!;

        return FlutterMap(
          options: MapOptions(
            initialCenter: center,
            initialZoom: 16,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            MarkerLayer(
              markers: [
                /// Laundry marker
                Marker(
                  point: controller.laundryPosition.value!,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.local_laundry_service,
                    color: Colors.purple,
                    size: 40,
                  ),
                ),

                /// User marker
                if (controller.userPosition.value != null)
                  Marker(
                    point: controller.userPosition.value!,
                    width: 36,
                    height: 36,
                    child: const Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                      size: 36,
                    ),
                  ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
