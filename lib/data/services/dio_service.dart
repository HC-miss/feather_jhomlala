import 'package:dio/dio.dart';
import 'package:feather_jhomlala/core/utils/http/app_dio.dart';
import 'package:get/get.dart';

class DioService extends GetxService {
  final Dio client = AppDio.getInstance();

  static DioService get to => Get.find<DioService>();
}
