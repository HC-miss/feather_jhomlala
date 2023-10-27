import 'package:feather_jhomlala/modules/about/about_binding.dart';
import 'package:feather_jhomlala/modules/about/about_page.dart';
import 'package:feather_jhomlala/modules/forecast/forecast_binding.dart';
import 'package:feather_jhomlala/modules/forecast/forecast_page.dart';
import 'package:feather_jhomlala/modules/main/main_binding.dart';
import 'package:feather_jhomlala/modules/main/main_page.dart';
import 'package:feather_jhomlala/modules/settings/settings_binding.dart';
import 'package:feather_jhomlala/modules/settings/settings_page.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

abstract class AppPages {
  static const initial = AppRoutes.mainPage;

  static final routes = [
    // main
    GetPage(
      name: AppRoutes.mainPage,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),
    // about
    GetPage(
      name: AppRoutes.aboutPage,
      page: () => const AboutPage(),
      binding: AboutBinding(),
    ),
    // settings
    GetPage(
      name: AppRoutes.settingsPage,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
    ),
    // forecast
    GetPage(
      name: AppRoutes.forecastPage,
      page: () => const ForecastPage(),
      binding: ForecastBinding(),
    ),
  ];
}
