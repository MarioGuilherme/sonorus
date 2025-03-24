import "package:flutter_modular/flutter_modular.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:signalr_netcore/hub_connection.dart";

import "package:sonorus/src/domain/models/authenticated_user.dart";
import "package:sonorus/src/dtos/view_models/authenticated_user_view_model.dart";
import "package:sonorus/src/dtos/view_models/token_view_model.dart";

class AuthUtils {
  static Future<void> startSession(TokenViewModel tokenViewModel, AuthenticatedUserViewModel authenticatedUserViewModel) async {
    final AuthenticatedUser authenticatedUser = Modular.get<AuthenticatedUser>();
    authenticatedUser.updateAfterLogin(authenticatedUserViewModel);

    final HubConnection hubConnection = Modular.get<HubConnection>();
    hubConnection.start();
  }

  static Future<void> clearSession() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
    final AuthenticatedUser authenticatedUser = Modular.get<AuthenticatedUser>();
    authenticatedUser.clearSession();
    final HubConnection hubConnection = Modular.get<HubConnection>();
    hubConnection.stop();
  }

  static Future<(String?, String?)> getAccessAndRefreshToken() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? accessToken = sp.get("accessToken") as String?;
    final String? refreshToken = sp.get("refreshToken") as String?;
    return (accessToken, refreshToken);
  }

  static Future<void> setAccessAndRefreshToken(String accessToken, String refreshToken) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("accessToken", accessToken);
    sp.setString("refreshToken", refreshToken);
  }
}