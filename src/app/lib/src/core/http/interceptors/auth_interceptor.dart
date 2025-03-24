import "package:dio/dio.dart";
import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/core/utils/auth_utils.dart";
import "package:sonorus/src/domain/exceptions/refresh_token_not_found_exception.dart";
import "package:sonorus/src/dtos/input_models/refresh_token_input_model.dart";
import "package:sonorus/src/dtos/view_models/token_view_model.dart";

class AuthInterceptor extends Interceptor {
  final HttpClient _httpClient;

  AuthInterceptor(this._httpClient);

   @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final (String? accessToken, _) = await AuthUtils.getAccessAndRefreshToken();
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
        } else {
          AuthUtils.clearSession();
          Modular.to.navigate("/login/");
        }
      } catch (e) {
        AuthUtils.clearSession();
        Modular.to.navigate("/login/");
      }
    } else
      handler.next(err);
  }
  
  Future<void> _refreshToken(DioException err) async {
    try {
      final (_, String? refreshToken) = await AuthUtils.getAccessAndRefreshToken();
      if (refreshToken == null) return;

      final RefreshTokenInputModel inputModel = RefreshTokenInputModel(refreshToken: refreshToken);
      final Response resultRefresh = await this._httpClient.auth().put("/auth/refreshToken", data: inputModel.toJson());
      final TokenViewModel tokenViewModel = TokenViewModel.fromMap(resultRefresh.data);

      AuthUtils.setAccessAndRefreshToken(tokenViewModel.accessToken, tokenViewModel.refreshToken);
    } on RefreshTokenNotFoundException {
      AuthUtils.clearSession();
      Modular.to.navigate("/login");
    }
  }
  
  Future<void> _retryRequest(DioException err, ErrorInterceptorHandler handler) async {
    final RequestOptions requestOptions = err.requestOptions;
    final Response<dynamic> result = await this._httpClient.request(
      "${requestOptions.baseUrl}${requestOptions.path}",
      options: Options(headers: requestOptions.headers, method: requestOptions.method),
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