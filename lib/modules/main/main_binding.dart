import 'package:feather_jhomlala/data/providers/app_local_provider.dart';
import 'package:feather_jhomlala/data/providers/location_provider.dart';
import 'package:feather_jhomlala/data/providers/weather_api_provider.dart';
import 'package:feather_jhomlala/data/repositories/app_local_repository.dart';
import 'package:feather_jhomlala/data/repositories/location_repository.dart';
import 'package:feather_jhomlala/data/repositories/weather_local_repository.dart';
import 'package:feather_jhomlala/data/repositories/weather_repository.dart';
import 'package:get/get.dart';

import 'main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => MainController(
        locationRepository: LocationRepository(LocationProvider()),
        weatherRemoteRepository: WeatherRemoteRepository(WeatherApiProvider()),
        applicationLocalRepository: AppLocalRepository(AppLocalProvider()),
        weatherLocalRepository: WeatherLocalRepository(AppLocalProvider()),
      ),
    );
  }
}
