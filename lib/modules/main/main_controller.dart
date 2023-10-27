import 'dart:async';

import 'package:feather_jhomlala/core/utils/app_logger.dart';
import 'package:feather_jhomlala/core/utils/date_time_helper.dart';
import 'package:feather_jhomlala/data/model/internal/application_error.dart';
import 'package:feather_jhomlala/data/model/internal/geo_position.dart';
import 'package:feather_jhomlala/data/model/internal/overflow_menu_element.dart';
import 'package:feather_jhomlala/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather_jhomlala/data/model/remote/weather_response.dart';
import 'package:feather_jhomlala/data/repositories/app_local_repository.dart';
import 'package:feather_jhomlala/data/repositories/location_repository.dart';
import 'package:feather_jhomlala/data/repositories/weather_local_repository.dart';
import 'package:feather_jhomlala/data/repositories/weather_repository.dart';
import 'package:feather_jhomlala/routes/app_pages.dart';
import 'package:feather_jhomlala/widgets/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'main_state.dart';

class MainController extends GetxController with StateMixin<MainState> {
  final WeatherLocalRepository weatherLocalRepository;
  final AppLocalRepository applicationLocalRepository;

  final LocationRepository locationRepository;
  final WeatherRemoteRepository weatherRemoteRepository;

  Timer? _refreshTimer;

  // 页面缓存
  final Map<String, Widget?> pageMap = <String, Widget?>{};

  MainController({
    required this.locationRepository,
    required this.weatherLocalRepository,
    required this.weatherRemoteRepository,
    required this.applicationLocalRepository,
  });

  void _saveLastRefreshTime() {
    applicationLocalRepository.saveLastRefreshTime(
      DateTimeHelper.getCurrentTime(),
    );
  }

  void _setupRefreshTimer() {
    Log.i("Setup refresh data timer");
    _refreshTimer?.cancel();
    int refreshTime = applicationLocalRepository.getSavedRefreshTime();
    var duration = Duration(milliseconds: refreshTime);
    // 定时刷新数据
    _refreshTimer = Timer(duration, () {
      selectWeatherData();
    });
  }

  Future<GeoPosition?> _getPosition() async {
    try {
      final position = await locationRepository.getLocation();
      if (position != null) {
        Log.i("Position is present!");
        final GeoPosition geoPosition = GeoPosition.fromPosition(position);
        weatherLocalRepository.saveLocation(geoPosition);
        return geoPosition;
      } else {
        Log.i("Position is not present!");
        return weatherLocalRepository.getLocation();
      }
    } catch (error, stackTrace) {
      Log.e("getPosition failed", error: error, stackTrace: stackTrace);
      return null;
    }
  }

  Future<WeatherResponse?> _fetchWeather(double? latitude,
      double? longitude,) async {
    Log.i("Fetch weather");
    final WeatherResponse weatherResponse =
    await weatherRemoteRepository.fetchWeather(latitude, longitude);
    if (weatherResponse.errorCode == null) {
      weatherLocalRepository.saveWeather(weatherResponse);
      return weatherResponse;
    } else {
      Log.i("Selected weather from storage");
      final WeatherResponse? weatherResponseStorage =
      await weatherLocalRepository.getWeather();
      if (weatherResponseStorage != null) {
        return weatherResponseStorage;
      } else {
        return weatherResponse;
      }
    }
  }

  Future<WeatherForecastListResponse?> _fetchWeatherForecast(double? latitude,
      double? longitude,) async {
    //lastRequestTime = DateTime.now().millisecondsSinceEpoch;

    WeatherForecastListResponse weatherForecastResponse =
    await weatherRemoteRepository.fetchWeatherForecast(latitude, longitude);
    if (weatherForecastResponse.errorCode == null) {
      weatherLocalRepository.saveWeatherForecast(weatherForecastResponse);
    } else {
      final WeatherForecastListResponse? weatherForecastResponseStorage =
      await weatherLocalRepository.getWeatherForecast();
      if (weatherForecastResponseStorage != null) {
        weatherForecastResponse = weatherForecastResponseStorage;
        //_logger.info("Using weather forecast data from storage");
      }
    }
    return weatherForecastResponse;
  }

  selectWeatherData() async {
    // 显示加载页面
    if (!status.isLoading) {
      change(null, status: RxStatus.loading());
    }

    final GeoPosition? position = await _getPosition();
    Log.i("Got geo position: $position");
    if (position != null) {
      // final WeatherResponse? weatherResponse = await _fetchWeather(
      //   position.lat,
      //   position.long,
      // );
      //
      // final WeatherForecastListResponse? weatherForecastListResponse =
      //     await _fetchWeatherForecast(
      //   position.lat,
      //   position.long,
      // );

      var [
      weatherResponse as WeatherResponse?,
      weatherForecastListResponse as WeatherForecastListResponse?
      ] = await Future.wait(
        [
          _fetchWeather(
            position.lat,
            position.long,
          ),
          _fetchWeatherForecast(
            position.lat,
            position.long,
          ),
        ],
      );
      // 设置最后刷新时间
      _saveLastRefreshTime();

      // 处理数据以及页面切换逻辑
      if (weatherResponse != null && weatherForecastListResponse != null) {
        if (weatherResponse.errorCode != null) {
          change(
            FailedLoadMainScreenState(weatherResponse.errorCode!),
            status: RxStatus.success(),
          );
        } else if (weatherForecastListResponse.errorCode != null) {
          change(
            FailedLoadMainScreenState(weatherResponse.errorCode!),
            status: RxStatus.success(),
          );
        } else {
          change(
            SuccessLoadMainScreenState(
              weatherResponse,
              weatherForecastListResponse,
            ),
            status: RxStatus.success(),
          );
          // 数据刷新成功 则重置定时器
          _setupRefreshTimer();
        }
      } else {
        change(
          const FailedLoadMainScreenState(ApplicationError.connectionError),
          status: RxStatus.success(),
        );
      }
    } else {
      change(
        const FailedLoadMainScreenState(
          ApplicationError.locationNotSelectedError,
        ),
        status: RxStatus.success(),
      );
    }
  }

  Future<bool> _checkLocationServiceEnabled() async {
    return locationRepository.isLocationEnabled();
  }

  Future<PermissionNotGrantedMainScreenState?> _checkPermission() async {
    final permissionCheck = await locationRepository.checkLocationPermission();
    if (permissionCheck == LocationPermission.denied) {
      // 申请位置权限
      final permissionRequest =
      await locationRepository.requestLocationPermission();

      if (permissionRequest == LocationPermission.always ||
          permissionRequest == LocationPermission.whileInUse) {
        return null;
      } else {
        // 未获取权限
        return PermissionNotGrantedMainScreenState(
          permissionRequest == LocationPermission.deniedForever,
        );
      }
    } else if (permissionCheck == LocationPermission.deniedForever) {
      // 未永久赋予权限
      return const PermissionNotGrantedMainScreenState(true);
    } else {
      return null;
    }
  }

  @override
  void onReady() {
    super.onReady();

    // todo 用户的配置未使用
    // applicationLocalRepository.getSavedUnit();

    locationInit();
  }

  Future<void> locationInit() async {
    if (!status.isLoading) {
      change(null, status: RxStatus.loading());
    }

    // 位置初始化
    if (!await _checkLocationServiceEnabled()) {
      change(
        LocationServiceDisabledMainScreenState(),
        status: RxStatus.success(),
      );
    } else {
      final permissionState = await _checkPermission();
      // 已获取权限 加载数据
      if (permissionState == null) {
        selectWeatherData();
      } else {
        // 未获取权限
        change(
          permissionState,
          status: RxStatus.success(),
        );
      }
    }
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
    super.onClose();
  }

  void onMenuElementClicked(PopupMenuElement value) {
    List<Color> startGradientColors = [];
    if (state is SuccessLoadMainScreenState) {
      final weatherResponse =
          (state as SuccessLoadMainScreenState).weatherResponse;
      final LinearGradient gradient = WidgetHelper.getGradient(
        sunriseTime: weatherResponse.system!.sunrise,
        sunsetTime: weatherResponse.system!.sunset,
      );
      startGradientColors = gradient.colors;
    }

    if (value.key == const Key("menu_overflow_settings")) {
      Get.toNamed(AppRoutes.settingsPage, arguments: startGradientColors);
    }
    if (value.key == const Key("menu_overflow_about")) {
      Get.toNamed(AppRoutes.aboutPage, arguments: startGradientColors);
    }
  }
}
