import 'package:feather_jhomlala/core/utils/weather_helper.dart';
import 'package:feather_jhomlala/data/model/internal/weather_forecast_holder.dart';
import 'package:feather_jhomlala/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeatherForecastThumbnailWidget extends StatelessWidget {
  final WeatherForecastHolder holder;
  final bool isMetricUnits;

  const WeatherForecastThumbnailWidget(
    this.holder,
    this.isMetricUnits, {
    Key? key,
  }) : super(key: key);

  void _onWeatherForecastClicked() {
    Get.toNamed(AppRoutes.forecastPage, arguments: holder);
  }

  @override
  Widget build(BuildContext context) {
    var temperature = holder.averageTemperature;
    if (!isMetricUnits) {
      temperature = WeatherHelper.convertCelsiusToFahrenheit(temperature!);
    }

    return Material(
      key: const Key("weather_forecast_thumbnail_widget"),
      color: Colors.transparent,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: InkWell(
          onTap: _onWeatherForecastClicked,
          child: Container(
            padding: const EdgeInsets.only(left: 4, right: 4, top: 8),
            child: Column(
              children: [
                Text(
                  holder.dateShortFormatted!,
                  key: const Key("weather_forecast_thumbnail_date"),
                  textDirection: TextDirection.ltr,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Image.asset(
                  holder.weatherCodeAsset!,
                  key: const Key("weather_forecast_thumbnail_icon"),
                  width: 30,
                  height: 30,
                ),
                const SizedBox(height: 4),
                Text(
                  WeatherHelper.formatTemperature(
                    temperature: temperature,
                    metricUnits: isMetricUnits,
                  ),
                  key: const Key("weather_forecast_thumbnail_temperature"),
                  textDirection: TextDirection.ltr,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
