import "dart:developer";

import "package:dio/dio.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:sonorus/src/core/exceptions/expire_token_exception.dart";
import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/models/auth_token_model.dart";
import "package:sonorus/src/models/rest_response_model.dart";

class AuthInterceptor extends Interceptor {
  final HttpClient _httpClient;

  AuthInterceptor(this._httpClient);

   @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? accessToken = sp.getString("accessToken");
    options.headers["Authorization"] = "Bearer $accessToken";
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        if (err.requestOptions.path != "/auth/refreshToken") {
          await this._refreshToken(err);
          await this._retryRequest(err, handler);
        }/*else {
          GlobalContext.instance.loginExpire();
        }*/
      } catch (e) {
        //GlobalContext.instance.loginExpire();
      }
    } else
      handler.next(err);
  }
  
  Future<void> _refreshToken(DioException err) async {
    try {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      final String? accessToken = sp.getString("accessToken");
      final String? refreshToken = sp.getString("refreshToken");

      if (refreshToken == null) return;

      final Response resultRefresh = await this._httpClient.accountMS().unauth().post("/auth/refreshToken", data: {
        "accessToken": accessToken,
        "refreshToken": refreshToken
      });
      final RestResponseModel restResponse = RestResponseModel.fromMap(resultRefresh.data);
      final AuthTokenModel authToken = AuthTokenModel.fromMap(restResponse.data);

      sp.setString("accessToken", authToken.accessToken);
      sp.setString("refreshToken", authToken.refreshToken);
    } on DioException catch (e, s) {
      log("Erro ao realizar o refresh token", error: e, stackTrace: s);
      throw ExpireTokenException();
    }
  }
  
  Future<void> _retryRequest(DioException err, ErrorInterceptorHandler handler) async {
    final RequestOptions requestOptions = err.requestOptions;
    final Response<dynamic> result = await this._httpClient.request(
      "${requestOptions.baseUrl}${requestOptions.path}",
      options: Options(
        headers: requestOptions.headers,
        method: requestOptions.method
      ),
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters
    );
    handler.resolve(Response<dynamic>(
      requestOptions: requestOptions,
      data: result.data,
      statusCode: result.statusCode,
      statusMessage: result.statusMessage
    ));
  }
}