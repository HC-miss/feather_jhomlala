class AppDioConfig {
  // 基础地址
  static const String baseUrl = "https://api.openweathermap.org";

  // 代理
  static const bool proxyEnable = false;
  static const String proxyIP = "";
  static const String proxyPort = "";

  // 超时
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 5);

  // 请求头
  static const Map<String, dynamic> headers = <String, dynamic>{};
}
