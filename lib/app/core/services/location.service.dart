import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {

  /// ===== LOKASI LAUNDRY (1 TITIK) =====
  final LatLng _laundryPosition =
      const LatLng(-7.966620, 112.632632); 

  LatLng getLaundryLocation() {
    return _laundryPosition;
  }

  /// ===== PERMISSION & USER LOCATION =====
  Future<bool> _checkPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;

    var status = await Permission.location.status;
    if (status.isDenied) {
      status = await Permission.location.request();
    }

    if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }
    return status.isGranted;
  }

  Future<LatLng> getUserLocation() async {
    final granted = await _checkPermission();
    if (!granted) {
      throw Exception('Location permission denied');
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return LatLng(position.latitude, position.longitude);
  }

  /// ===== HITUNG JARAK USER → LAUNDRY =====
  Future<double> getDistanceToLaundry() async {
    final user = await getUserLocation();

    return Geolocator.distanceBetween(
      user.latitude,
      user.longitude,
      _laundryPosition.latitude,
      _laundryPosition.longitude,
    );
  }
}
