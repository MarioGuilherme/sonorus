import "package:dio/dio.dart";
import "package:dio/io.dart";

import "package:sonorus/app/core/env/env.dart";

class CustomDio extends DioForNative {

  CustomDio() : super(BaseOptions(
    baseUrl: Env.instance["backend_base_url"] ?? "",
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 60)
  )) {
    this.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true
    ));
  }

  CustomDio unauth() => this;
}