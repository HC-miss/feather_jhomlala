import 'package:card_swiper/card_swiper.dart';
import 'package:feather_jhomlala/core/utils/app_logger.dart';
import 'package:feather_jhomlala/core/values/constant.dart';
import 'package:feather_jhomlala/data/model/internal/weather_forecast_holder.dart';
import 'package:feather_jhomlala/modules/forecast/widgets/weather_forecast_pressure_page.dart';
import 'package:flutter/material.dart';

import 'weather_forecast_base_page.dart';
import 'weather_forecast_rain_page.dart';
import 'weather_forecast_temperature_page.dart';
import 'weather_forecast_wind_page.dart';

class WeatherForecastWidget extends StatelessWidget {
  final WeatherForecastHolder? holder;
  final double? width;
  final double? height;
  final Map<String, WeatherForecastBasePage?> _pageMap = {};

  final bool isMetricUnits;

  WeatherForecastWidget({
    Key? key,
    this.holder,
    this.width,
    this.height,
    required this.isMetricUnits,
  }) : super(key: key);

  WeatherForecastBasePage? _getPage(String key, WeatherForecastHolder? holder,
      double? width, double? height) {
    if (_pageMap.containsKey(key)) {
      Log.d("Get page from map with key: $key");
      return _pageMap[key];
    } else {
      WeatherForecastBasePage? page;
      if (key == Constant.temperaturePage) {
        page = WeatherForecastTemperaturePage(
            holder, width, height, isMetricUnits);
      } else if (key == Constant.windPage) {
        page = WeatherForecastWindPage(holder, width, height, isMetricUnits);
      } else if (key == Constant.rainPage) {
        page = WeatherForecastRainPage(holder, width, height, isMetricUnits);
      } else if (key == Constant.pressurePage) {
        page = WeatherForecastPressurePage(
          holder,
          width,
          height,
          isMetricUnits,
        );
      }
      _pageMap[key] = page;
      return page;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            key: const Key("weather_forecast_container"),
            children: [
              // 位置
              Text(
                holder!.getLocationName(context)!,
                textDirection: TextDirection.ltr,
                key: const Key("weather_forecast_location_name"),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              // 日期
              Text(
                holder!.dateFullFormatted!,
                textDirection: TextDirection.ltr,
                key: const Key("weather_forecast_date_formatted"),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 20),
              // 轮播图
              SizedBox(
                height: 450,
                child: Swiper(
                  physics: BouncingScrollPhysics(),
                  key: const Key("weather_forecast_swiper"),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return _getPage(
                          Constant.temperaturePage, holder, width, height)!;
                    } else if (index == 1) {
                      return _getPage(Constant.windPage, holder, width, height)!;
                    } else if (index == 2) {
                      return _getPage(Constant.rainPage, holder, width, height)!;
                    } else {
                      return _getPage(Constant.pressurePage, holder, width, height)!;
                    }
                  },
                  loop: false,
                  itemCount: 4,
                  pagination: const SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                      color: Colors.white54,
                      activeColor: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
