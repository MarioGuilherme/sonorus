import "package:dio/dio.dart";
import "package:dio/io.dart";

import "package:sonorus/src/core/env/env.dart";
import "package:sonorus/src/core/http/interceptors/auth_interceptor.dart";

class HttpClient extends DioForNative {
  late AuthInterceptor _authInterceptor;

  HttpClient() : super(BaseOptions(
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 60)
  )) {
    this.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true
    ));
    _authInterceptor = AuthInterceptor();
  }

  HttpClient accountMicrosservice() {
    this.options.baseUrl = Env.instance["account_microsservice_base_url"]!;
    return this;
  }

  HttpClient businessMicrosservice() {
    this.options.baseUrl = Env.instance["business_microsservice_base_url"]!;
    return this;
  }

  HttpClient chatMicrosservice() {
    this.options.baseUrl = Env.instance["chat_microsservice_base_url"]!;
    return this;
  }

  HttpClient marketplaceMicrosservice() {
    this.options.baseUrl = Env.instance["marketplace_microsservice_base_url"]!;
    return this;
  }

  HttpClient postMicrosservice() {
    this.options.baseUrl = Env.instance["post_microsservice_base_url"]!;
    return this;
  }

  HttpClient auth() {
    if (!interceptors.contains(_authInterceptor)) {
      interceptors.add(_authInterceptor);
    }
    return this;
  }

  HttpClient unauth() {
    interceptors.remove(_authInterceptor);
    return this;
  }
}