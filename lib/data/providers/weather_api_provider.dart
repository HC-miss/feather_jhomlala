import 'package:dio/dio.dart';
import 'package:feather_jhomlala/core/config/open_weather.dart';
import 'package:feather_jhomlala/core/utils/app_logger.dart';
import 'package:feather_jhomlala/data/model/internal/application_error.dart';
import 'package:feather_jhomlala/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather_jhomlala/data/model/remote/weather_response.dart';
import 'package:feather_jhomlala/data/services/dio_service.dart';

Uri _buildUri(String endpoint, double? latitude, double? longitude) {
  return Uri(
    path: endpoint,
    queryParameters: <String, dynamic>{
      "lat": latitude.toString(),
      "lon": longitude.toString(),
      "apiKey": OpenWeatherConfig.apiKey,
      "units": "metric"
    },
  );
}

class WeatherApiProvider {
  final DioService dioService = DioService.to;

  final String _apiWeatherEndpoint = "/data/2.5/weather";
  final String _apiWeatherForecastEndpoint = "/data/2.5/forecast";

  Future<WeatherResponse> fetchWeather(
    double? latitude,
    double? longitude,
  ) async {
    try {
      final Uri uri = _buildUri(_apiWeatherEndpoint, latitude, longitude);
      final Response<Map<String, dynamic>> response =
          await dioService.client.get(uri.toString());
      if (response.statusCode == 200) {
        return WeatherResponse.fromJson(response.data!);
      } else {
        return WeatherResponse.withErrorCode(ApplicationError.apiError);
      }
    } catch (exc, stacktrace) {
      Log.e("Exception occurred: $exc stack trace: ${stacktrace.toString()}");

      return WeatherResponse.withErrorCode(ApplicationError.connectionError);
    }
  }

  Future<WeatherForecastListResponse> fetchWeatherForecast(
    double? latitude,
    double? longitude,
  ) async {
    try {
      final Uri uri = _buildUri(
        _apiWeatherForecastEndpoint,
        latitude,
        longitude,
      );
      final Response<Map<String, dynamic>> response =
          await dioService.client.get(uri.toString());
      if (response.statusCode == 200) {
        return WeatherForecastListResponse.fromJson(response.data!);
      } else {
        return WeatherForecastListResponse.withErrorCode(
          ApplicationError.apiError,
        );
      }
    } catch (exc, stackTrace) {
      Log.e("Exception occurred: $exc $stackTrace");
      return WeatherForecastListResponse.withErrorCode(
        ApplicationError.connectionError,
      );
    }
  }
}
