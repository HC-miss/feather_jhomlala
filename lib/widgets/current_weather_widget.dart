import 'package:feather_jhomlala/core/utils/weather_helper.dart';
import 'package:feather_jhomlala/data/model/remote/overall_weather_data.dart';
import 'package:feather_jhomlala/data/model/remote/weather_forecast_list_response.dart';
import 'package:feather_jhomlala/data/model/remote/weather_response.dart';
import 'package:feather_jhomlala/data/services/setting_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../modules/main/widgets/weather_forecast_thumbnail_list_widget.dart';
import 'animated_state.dart';

class CurrentWeatherWidget extends StatefulWidget {
  final WeatherResponse? weatherResponse;
  final WeatherForecastListResponse? forecastListResponse;

  const CurrentWeatherWidget(
      {Key? key, this.weatherResponse, this.forecastListResponse})
      : super(key: key);

  @override
  State<CurrentWeatherWidget> createState() => _CurrentWeatherWidgetState();
}

class _CurrentWeatherWidgetState extends AnimatedState<CurrentWeatherWidget> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return buildWeatherContainer(
        widget.weatherResponse!,
        widget.forecastListResponse!,
      );
    });
  }

  String _getWeatherImage(WeatherResponse weatherResponse) {
    final OverallWeatherData overallWeatherData =
    weatherResponse.overallWeatherData![0];
    final int code = overallWeatherData.id!;
    return WeatherHelper.getWeatherIcon(code);
  }

  String _getMaxMinTemperatureRow(WeatherResponse weatherResponse) {
    var isMetricUnits = SettingService.to.isMetricUnits;
    var maxTemperature = weatherResponse.mainWeatherData!.tempMax;
    var minTemperature = weatherResponse.mainWeatherData!.tempMin;

    if (!isMetricUnits) {
      maxTemperature = WeatherHelper.convertCelsiusToFahrenheit(maxTemperature);
      minTemperature = WeatherHelper.convertCelsiusToFahrenheit(minTemperature);
    }
    final formattedMaxTemperature = WeatherHelper.formatTemperature(
      temperature: maxTemperature,
      metricUnits: isMetricUnits,
    );

    final formattedMinTemperature = WeatherHelper.formatTemperature(
      temperature: minTemperature,
      metricUnits: isMetricUnits,
    );

    return "↑$formattedMaxTemperature ↓$formattedMinTemperature";
  }

  Widget _getPressureAndHumidityRow(WeatherResponse weatherResponse) {
    final applicationLocalization = AppLocalizations.of(context)!;
    var isMetricUnits = SettingService.to.isMetricUnits;

    return RichText(
      textDirection: TextDirection.ltr,
      key: const Key("weather_current_widget_pressure_humidity"),
      text: TextSpan(
        children: [
          TextSpan(
            text: "${applicationLocalization.pressure}: ",
            style: Theme
                .of(context)
                .textTheme
                .bodyLarge,
          ),
          TextSpan(
            text: WeatherHelper.formatPressure(
              weatherResponse.mainWeatherData!.pressure,
              isMetricUnits,
            ),
            style: Theme
                .of(context)
                .textTheme
                .titleSmall,
          ),
          const TextSpan(
            text: "  ",
          ),
          TextSpan(
            text: "${applicationLocalization.humidity}: ",
            style: Theme
                .of(context)
                .textTheme
                .bodyLarge,
          ),
          TextSpan(
            text: WeatherHelper.formatHumidity(
              weatherResponse.mainWeatherData!.humidity,
            ),
            style: Theme
                .of(context)
                .textTheme
                .titleSmall,
          )
        ],
      ),
    );
  }

  Widget buildWeatherContainer(WeatherResponse response,
      WeatherForecastListResponse weatherForecastListResponse,) {
    var currentTemperature = response.mainWeatherData!.temp;

    if (!SettingService.to.isMetricUnits) {
      currentTemperature = WeatherHelper.convertCelsiusToFahrenheit(
        currentTemperature,
      );
    }

    return FadeTransition(
      opacity: setupAnimation(duration: 1000, noAnimation: true),
      child: Container(
        key: const Key("weather_current_widget_container"),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Image.asset(
                _getWeatherImage(response),
                width: 100,
                height: 100,
              ),
              Text(
                key: const Key("weather_current_widget_temperature"),
                textDirection: TextDirection.ltr,
                style: Theme
                    .of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: Colors.white),
                WeatherHelper.formatTemperature(
                  temperature: currentTemperature,
                  metricUnits: SettingService.to.isMetricUnits,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                _getMaxMinTemperatureRow(response),
                key: const Key("weather_current_widget_min_max_temperature"),
                textDirection: TextDirection.ltr,
                style: Theme
                    .of(context)
                    .textTheme
                    .titleSmall,
              ),
              const SizedBox(height: 4),
              _getPressureAndHumidityRow(response),
              const SizedBox(height: 24),
              WeatherForecastThumbnailListWidget(
                system: response.system,
                forecastListResponse: weatherForecastListResponse,
                key: const Key("weather_current_widget_thumbnail_list"),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onAnimatedValue(double value) {}
}
