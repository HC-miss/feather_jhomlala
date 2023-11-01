import 'package:feather_jhomlala/core/theme/app_theme.dart';
import 'package:feather_jhomlala/global.dart';
import 'package:feather_jhomlala/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

Future<void> main() async {
  await Global.init();
  // 显示布局信息
  debugPaintSizeEnabled = false;
  runApp(const FeatherApp());
}

class FeatherApp extends StatelessWidget {
  const FeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      title: 'Feather',

      theme: AppTheme.themeData,

      // 国际化支持-代理
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // locale: Locale('zh', 'cn'),
      debugShowCheckedModeBanner: false,
    );
  }
}
