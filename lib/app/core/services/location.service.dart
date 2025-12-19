import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  static const LatLng _laundryPosition =LatLng(-7.966620, 112.632632);

  LatLng getLaundryLocation() => _laundryPosition;

  Future<bool> _handlePermission() async {
    final serviceEnabled =
        await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<LatLng> getUserLocation() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) {
      throw Exception('Location permission not granted');
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10),
    );

    return LatLng(position.latitude, position.longitude);
  }

  double calculateDistance({
    required LatLng user,
    required LatLng laundry,
  }) {
    return Geolocator.distanceBetween(
      user.latitude,
      user.longitude,
      laundry.latitude,
      laundry.longitude,
    );
  }
}
