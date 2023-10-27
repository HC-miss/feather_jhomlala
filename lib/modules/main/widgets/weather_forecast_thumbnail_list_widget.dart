import 'dart:developer';

import 'package:feather_jhomlala/core/utils/weather_helper.dart';
import 'package:feather_jhomlala/data/model/internal/weather_forecast_holder.dart';
import 'package:feather_jhomlala/data/model/remote/system.dart';
import 'package:feather_jhomlala/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather_jhomlala/data/model/remote/weather_forecast_response.dart';
import 'package:feather_jhomlala/data/services/setting_service.dart';
import 'package:flutter/material.dart';

import 'weather_forecast_thumbnail_widget.dart';

class WeatherForecastThumbnailListWidget extends StatelessWidget {
  final System? system;
  final WeatherForecastListResponse? forecastListResponse;

  const WeatherForecastThumbnailListWidget({
    Key? key,
    this.system,
    this.forecastListResponse,
  }) : super(key: key);

  Widget buildForecastWeatherContainer(
    WeatherForecastListResponse forecastListResponse,
  ) {
    final List<WeatherForecastResponse> forecastList =
        forecastListResponse.list!;
    // 转换成每日数据Map
    final map = WeatherHelper.getMapForecastsForSameDay(forecastList);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        key: const Key("weather_forecast_thumbnail_list_widget_container"),
        textDirection: TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.center,
        children: buildForecastWeatherWidgets(map, forecastListResponse),
      ),
    );
  }

  List<Widget> buildForecastWeatherWidgets(
    Map<String, List<WeatherForecastResponse>> map,
    WeatherForecastListResponse? data,
  ) {
    final List<Widget> forecastWidgets = [];

    var isMetricUnits = SettingService.to.isMetricUnits;

    map.forEach((key, value) {
      forecastWidgets.add(WeatherForecastThumbnailWidget(
        WeatherForecastHolder(
          value,
          data!.city,
          system,
        ),
        isMetricUnits,
      ));
    });
    return forecastWidgets;
  }

  @override
  Widget build(BuildContext context) {
    // 如果此处是null，主页会显示错误信息 这个页面不会显示
    if (forecastListResponse != null) {
      return buildForecastWeatherContainer(forecastListResponse!);
    } else {
      return const SizedBox();
    }
  }
}
