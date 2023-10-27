import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:feather_jhomlala/core/config/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AppDio with DioMixin implements Dio {
  static Dio getInstance() => AppDio._();

  AppDio._([BaseOptions? options]) {
    options ??= BaseOptions(
      // 请求基地址,可以包含子路径
      baseUrl: AppDioConfig.baseUrl,
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: AppDioConfig.connectTimeout,
      // 响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: AppDioConfig.receiveTimeout,
      // Http请求头.
      headers: AppDioConfig.headers,

      /// 请求的Content-Type，默认值是"application/json; charset=utf-8".
      /// 如果您想以"application/x-www-form-urlencoded"格式编码请求数据,
      /// 可以设置此选项为 `Headers.formUrlEncodedContentType`,  这样[Dio]
      /// 就会自动编码请求体.
      contentType: ContentType.json.toString(),

      /// [responseType] 表示期望以那种格式(方式)接受响应数据。
      /// 目前 [ResponseType] 接受三种类型 `JSON`, `STREAM`, `PLAIN`.
      ///
      /// 默认值是 `JSON`, 当响应头中content-type为"application/json"时，dio 会自动将响应内容转化为json对象。
      /// 如果想以二进制方式接受响应数据，如下载一个二进制文件，那么可以使用 `STREAM`.
      ///
      /// 如果想以文本(字符串)格式接收响应数据，请使用 `PLAIN`.
      responseType: ResponseType.json,
    );
    this.options = options;

    // 代理
    if (AppDioConfig.proxyEnable) {
      httpClientAdapter = IOHttpClientAdapter(createHttpClient: () {
        final client = HttpClient();
        client.findProxy = (_) {
          return "PROXY ${AppDioConfig.proxyIP}:${AppDioConfig.proxyPort}";
        };
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      });
    } else {
      httpClientAdapter = IOHttpClientAdapter();
    }
    // 添加拦截器
    // Cookie管理 Cookie存在内存中 所以每次都得重新登录
    // interceptors.add(CookieManager(CookieJar()));
    // Cookie存在文件中 需要权限
    // 添加持久化Cookie会话 利用临时目录
    // interceptors.add(
    //   // 务必先初始化SettingService
    //   CookieManager(SettingService.to.cookieJar),
    // );
    //
    // // 异常拦截器
    // interceptors.add(ErrorInterceptor());
    // // 网络检测拦截器
    // interceptors.add(ConnectivityInterceptor());
    // // 认证拦截器
    // interceptors.add(AuthInterceptor());

    // DEBUG模式下打印请求信息
    if (kDebugMode) {
      interceptors.add(
        // LogInterceptor(
        //   responseBody: true,
        //   error: true,
        //   requestHeader: false,
        //   responseHeader: false,
        //   request: false,
        //   requestBody: true,
        // ),
        PrettyDioLogger(),
      );
    }
  }
}
