import 'dart:convert';

import 'package:feather_jhomlala/core/utils/app_logger.dart';
import 'package:feather_jhomlala/core/utils/date_time_helper.dart';
import 'package:feather_jhomlala/core/values/constant.dart';
import 'package:feather_jhomlala/data/model/internal/geo_position.dart';
import 'package:feather_jhomlala/data/model/internal/unit.dart';
import 'package:feather_jhomlala/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather_jhomlala/data/model/remote/weather_response.dart';
import 'package:feather_jhomlala/data/services/storage_service.dart';

class AppLocalProvider {
  final StorageService storageService = StorageService.to;

  AppLocalProvider();

  Unit getUnit() {
    try {
      final int? unit = storageService.getInt(Constant.storageUnitKey);
      if (unit == null) {
        return Unit.metric;
      } else {
        if (unit == 0) {
          return Unit.metric;
        } else {
          return Unit.imperial;
        }
      }
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return Unit.metric;
    }
  }

  Future<bool> saveUnit(Unit unit) async {
    try {
      Log.d("Store unit $unit");
      int unitValue = 0;
      if (unit == Unit.metric) {
        unitValue = 0;
      } else {
        unitValue = 1;
      }

      final result =
          await storageService.setInt(Constant.storageUnitKey, unitValue);
      Log.d("Saved with result: $result");

      return result;
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return false;
    }
  }

  Future<bool> saveRefreshTime(int refreshTime) async {
    try {
      Log.d("Save refresh time: $refreshTime");
      final result = await storageService.setInt(
          Constant.storageRefreshTimeKey, refreshTime);
      Log.d("Saved with result: $result");
      return result;
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return false;
    }
  }

  int getRefreshTime() {
    try {
      int? refreshTime = storageService.getInt(Constant.storageRefreshTimeKey);
      if (refreshTime == null || refreshTime == 0) {
        refreshTime = 600000;
      }
      return refreshTime;
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return 600000;
    }
  }

  Future<bool> saveLastRefreshTime(int lastRefreshTime) async {
    try {
      Log.d("Save refresh time: $lastRefreshTime");
      final result = await storageService.setInt(
        Constant.storageLastRefreshTimeKey,
        lastRefreshTime,
      );
      Log.d("Saved with result: $result");
      return result;
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return false;
    }
  }

  int getLastRefreshTime() {
    try {
      int? lastRefreshTime = storageService.getInt(
        Constant.storageLastRefreshTimeKey,
      );
      if (lastRefreshTime == null || lastRefreshTime == 0) {
        lastRefreshTime = DateTimeHelper.getCurrentTime();
      }
      return lastRefreshTime;
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return DateTimeHelper.getCurrentTime();
    }
  }

  Future<bool> saveLocation(GeoPosition geoPosition) async {
    try {
      Log.d("Store location: $geoPosition");
      final result = await storageService.setString(
        Constant.storageLocationKey,
        json.encode(geoPosition),
      );
      Log.d("Saved with result: $result");
      return result;
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return false;
    }
  }

  Future<GeoPosition?> getLocation() async {
    try {
      final jsonData = storageService.getJSON(Constant.storageLocationKey);
      Log.d("Returned user location: $jsonData");
      if (jsonData != null) {
        return GeoPosition.fromJson(jsonData as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return null;
    }
  }

  Future<bool> saveWeather(WeatherResponse response) async {
    try {
      Log.d("Store weather: ${json.encode(response)}");
      final result = await storageService.setString(
        Constant.storageWeatherKey,
        json.encode(response),
      );
      Log.d("Saved with result: $result");
      return result;
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return false;
    }
  }

  Future<WeatherResponse?> getWeather() async {
    try {
      final String jsonData = storageService.getString(
        Constant.storageWeatherKey,
      );
      Log.d("Returned weather data: $jsonData");
      if (jsonData.isNotEmpty) {
        return WeatherResponse.fromJson(
            jsonDecode(jsonData) as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return null;
    }
  }

  Future<bool> saveWeatherForecast(WeatherForecastListResponse response) async {
    try {
      Log.d("Store weather forecast ${json.encode(response)}");
      final result = await storageService.setString(
          Constant.storageWeatherForecastKey, json.encode(response));
      Log.d("Saved with result: $result");
      return result;
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return false;
    }
  }

  Future<WeatherForecastListResponse?> getWeatherForecast() async {
    try {
      final String jsonData = storageService.getString(
        Constant.storageWeatherForecastKey,
      );
      Log.d("Returned weather forecast data: $jsonData");
      if (jsonData.isNotEmpty) {
        return WeatherForecastListResponse.fromJson(
            jsonDecode(jsonData) as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (exc, stackTrace) {
      Log.e("Exception: $exc stack trace: $stackTrace");
      return null;
    }
  }
}
