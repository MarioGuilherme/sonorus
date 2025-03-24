import "package:flutter_modular/flutter_modular.dart";
import "package:signalr_netcore/signalr_client.dart";

import "package:sonorus/src/core/env/env.dart";
import "package:sonorus/src/core/http/http_client.dart";
import "package:sonorus/src/core/utils/auth_utils.dart";
import "package:sonorus/src/domain/models/authenticated_user.dart";
import "package:sonorus/src/repositories/auth/auth_repository.dart";
import "package:sonorus/src/repositories/auth/auth_repository_impl.dart";
import "package:sonorus/src/repositories/chat/chat_repository.dart";
import "package:sonorus/src/repositories/chat/chat_repository_impl.dart";
import "package:sonorus/src/repositories/interest/interest_repository.dart";
import "package:sonorus/src/repositories/interest/interest_repository_impl.dart";
import "package:sonorus/src/repositories/user/user_repository.dart";
import "package:sonorus/src/repositories/user/user_repository_impl.dart";
import "package:sonorus/src/services/auth/auth_service.dart";
import "package:sonorus/src/services/auth/auth_service_impl.dart";
import "package:sonorus/src/services/chat/chat_service.dart";
import "package:sonorus/src/services/chat/chat_service_impl.dart";
import "package:sonorus/src/services/interest/interest_service.dart";
import "package:sonorus/src/services/interest/interest_service_impl.dart";
import "package:sonorus/src/services/user/user_service.dart";
import "package:sonorus/src/services/user/user_service_impl.dart";

class CoreModule extends Module {
  @override
  void exportedBinds(i) {
    i.addLazySingleton<HubConnection>(() {
      final HubConnection hubConnection = HubConnectionBuilder()
        .withUrl(Env.instance["hub_url"]!, options: HttpConnectionOptions(
          accessTokenFactory: () async => (await AuthUtils.getAccessAndRefreshToken()).$1!,
          transport: HttpTransportType.WebSockets
        ))
        .withAutomaticReconnect()
        .build();
      hubConnection.keepAliveIntervalInMilliseconds = 3600;
      return hubConnection;
    });
    i.addLazySingleton<HttpClient>(HttpClient.new);
    i.addLazySingleton<AuthRepository>(AuthRepositoryImpl.new);
    i.addLazySingleton<AuthService>(AuthServiceImpl.new);
    i.addLazySingleton<InterestRepository>(InterestRepositoryImpl.new);
    i.addLazySingleton<InterestService>(InterestServiceImpl.new);
    i.addLazySingleton<UserRepository>(UserRepositoryImpl.new);
    i.addLazySingleton<UserService>(UserServiceImpl.new);
    i.addLazySingleton<ChatRepository>(ChatRepositoryImpl.new);
    i.addLazySingleton<ChatService>(ChatServiceImpl.new);
    i.addLazySingleton(() => AuthenticatedUser());
  }
}