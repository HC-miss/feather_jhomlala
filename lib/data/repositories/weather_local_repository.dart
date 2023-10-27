import 'package:feather_jhomlala/data/model/internal/geo_position.dart';
import 'package:feather_jhomlala/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather_jhomlala/data/model/remote/weather_response.dart';
import 'package:feather_jhomlala/data/providers/app_local_provider.dart';

class WeatherLocalRepository {
  final AppLocalProvider appLocalProvider;

  WeatherLocalRepository(this.appLocalProvider);

  Future saveLocation(GeoPosition geoPosition) async {
    await appLocalProvider.saveLocation(geoPosition);
  }

  Future<GeoPosition?> getLocation() async {
    return appLocalProvider.getLocation();
  }

  Future saveWeather(WeatherResponse response) async {
    await appLocalProvider.saveWeather(response);
  }

  Future<WeatherResponse?> getWeather() async {
    return appLocalProvider.getWeather();
  }

  Future saveWeatherForecast(WeatherForecastListResponse response) async {
    await appLocalProvider.saveWeatherForecast(response);
  }

  Future<WeatherForecastListResponse?> getWeatherForecast() async {
    return appLocalProvider.getWeatherForecast();
  }
}