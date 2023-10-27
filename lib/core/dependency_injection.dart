import 'package:feather_jhomlala/data/services/dio_service.dart';
import 'package:feather_jhomlala/data/services/setting_service.dart';
import 'package:feather_jhomlala/data/services/storage_service.dart';
import 'package:get/get.dart';


class DependencyInjection {
  static Future<void> init() async {
    // 持久化Storage
    await Get.putAsync<StorageService>(() => StorageService().init());
    // 全局dio实例
    Get.put<DioService>(DioService());
    // 全局设置
    Get.put<SettingService>(SettingService());
    // 全局设置
    // await Get.putAsync<SettingService>(() => SettingService().init());
    // // 全局DioClient
    // Get.put<DioClient>(DioClient());
    // // 用户信息
    // Get.put<UserService>(UserService());
  }
}
