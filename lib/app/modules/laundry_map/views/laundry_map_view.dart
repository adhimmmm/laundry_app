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
      floatingActionButton: FloatingActionButton(
        onPressed: controller.loadMapData,
        child: const Icon(Icons.my_location),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value != null) {
          return Center(
            child: Text(controller.errorMessage.value!),
          );
        }

        final LatLng center =
            controller.userPosition.value ??
                controller.laundryPosition.value!;

        return Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: center,
                initialZoom: 16,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),

                /// ===== ROUTE LINE =====
                if (controller.userPosition.value != null)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: [
                          controller.userPosition.value!,
                          controller.laundryPosition.value!,
                        ],
                        strokeWidth: 4,
                        color: Colors.purple,
                      ),
                    ],
                  ),

                /// ===== MARKERS =====
                MarkerLayer(
                  markers: [
                    Marker(
                      point:
                          controller.laundryPosition.value!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.local_laundry_service,
                        color: Colors.purple,
                        size: 40,
                      ),
                    ),
                    if (controller.userPosition.value != null)
                      Marker(
                        point:
                            controller.userPosition.value!,
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
            ),

            /// ===== DISTANCE INFO =====
            if (controller.distanceToLaundry.value != null)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'Jarak ke laundry: '
                      '${(controller.distanceToLaundry.value! / 1000).toStringAsFixed(2)} km',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
