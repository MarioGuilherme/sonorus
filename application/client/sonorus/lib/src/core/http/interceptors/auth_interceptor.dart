import "package:dio/dio.dart";
import "package:shared_preferences/shared_preferences.dart";

class AuthInterceptor extends Interceptor {
  AuthInterceptor();

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final accessToken = sp.getString("accessToken");
    options.headers["Authorization"] = "Bearer $accessToken";
    handler.next(options);
  }

  @override
  void onError(DioException  err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // GlobalContext.instance.loginExpire();
    } else {
      handler.next(err);
    }
  }
}