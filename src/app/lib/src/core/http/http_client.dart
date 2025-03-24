import "package:dio/dio.dart";
import "package:dio/io.dart";

import "package:sonorus/src/core/env/env.dart";
import "package:sonorus/src/core/http/interceptors/auth_interceptor.dart";

class HttpClient extends DioForNative {
  late AuthInterceptor _authInterceptor;

  HttpClient() : super(BaseOptions(
    baseUrl: Env.instance["api_gateway_base_url"]!,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 60)
  )) {
    this.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true,
      request: true
    ));
    this._authInterceptor = AuthInterceptor(this);
  }

  HttpClient auth() {
    if (!this.interceptors.contains(this._authInterceptor)) this.interceptors.add(this._authInterceptor);
    return this;
  }

  HttpClient unauth() {
    this.interceptors.remove(this._authInterceptor);
    return this;
  }
}