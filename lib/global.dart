import 'package:feather_jhomlala/core/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeago/timeago.dart' as timeago;

/// 全局静态数据
class Global {
  /// 初始化
  static Future<void> init() async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();
    // 设备方向
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // 初始化Loading配置
    // Loading.init();

    // 初始化timeago配置
    timeago.setLocaleMessages('zh', timeago.ZhCnMessages());
    timeago.setLocaleMessages('pl', timeago.PlMessages());

    // 依赖注入
    await DependencyInjection.init();
  }
}
