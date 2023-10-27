import 'package:feather_jhomlala/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather_jhomlala/data/model/remote/weather_response.dart';
import 'package:feather_jhomlala/data/providers/weather_api_provider.dart';

class WeatherRemoteRepository {
  final WeatherApiProvider _weatherApiProvider;

  WeatherRemoteRepository(this._weatherApiProvider);

  Future<WeatherResponse> fetchWeather(double? latitude, double? longitude) {
    return _weatherApiProvider.fetchWeather(latitude, longitude);
  }

  Future<WeatherForecastListResponse> fetchWeatherForecast(
    double? latitude,
    double? longitude,
  ) {
    return _weatherApiProvider.fetchWeatherForecast(latitude, longitude);
  }
}
