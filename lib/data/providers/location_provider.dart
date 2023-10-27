import 'package:geolocator/geolocator.dart';

class LocationProvider {
  Future<Position> providePosition() async {
    return Geolocator.getCurrentPosition(
      // 期望的准确度: 高精度
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<bool> isLocationEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> checkLocationPermission() async {
    return Geolocator.checkPermission();
  }

  Future<LocationPermission> requestLocationPermission() async {
    return Geolocator.requestPermission();
  }
}
