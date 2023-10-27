import 'package:feather_jhomlala/core/utils/app_logger.dart';
import 'package:feather_jhomlala/data/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


///Class used to provide location of the device.
class LocationRepository {
  final LocationProvider _locationProvider;
  Position? _lastPosition;

  LocationRepository(this._locationProvider);

  Future<Position?> getLocation() async {
    try {
      if (_lastPosition != null) {
        return _lastPosition;
      }
      _lastPosition = await _locationProvider.providePosition();
      return _lastPosition;
    } catch (exc, stackTrace) {
      Log.e("Exception occurred: $exc in $stackTrace");
      return null;
    }
  }

  Future<bool> isLocationEnabled() {
    return _locationProvider.isLocationEnabled();
  }

  Future<LocationPermission> checkLocationPermission() async{
    return _locationProvider.checkLocationPermission();
  }

  Future<LocationPermission> requestLocationPermission() async{
    return _locationProvider.requestLocationPermission();
  }


  @visibleForTesting
  Position? get lastPosition => _lastPosition;
}