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
      responseHeader: true,
      request: true
    ));
    this._authInterceptor = AuthInterceptor(this);
  }

  HttpClient accountMS() {
    this.options.baseUrl = Env.instance["account_ms_base_url"]!;
    return this;
  }

  HttpClient businessMS() {
    this.options.baseUrl = Env.instance["business_ms_base_url"]!;
    return this;
  }

  HttpClient chatMS() {
    this.options.baseUrl = Env.instance["chat_ms_base_url"]!;
    return this;
  }

  HttpClient marketplaceMS() {
    this.options.baseUrl = Env.instance["marketplace_ms_base_url"]!;
    return this;
  }

  HttpClient postMS() {
    this.options.baseUrl = Env.instance["post_ms_base_url"]!;
    return this;
  }

  HttpClient auth() {
    if (!interceptors.contains(this._authInterceptor))
      interceptors.add(this._authInterceptor);
    return this;
  }

  HttpClient unauth() {
    interceptors.remove(this._authInterceptor);
    return this;
  }
}