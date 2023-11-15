import "dart:developer";

import "package:flutter_modular/flutter_modular.dart";
import "package:signalr_core/signalr_core.dart";

import "package:sonorus/src/modules/base/base_page.dart";
import "package:sonorus/src/modules/base/business/business_controller.dart";
import "package:sonorus/src/modules/base/business/business_module.dart";
import "package:sonorus/src/modules/base/chat/chat_controller.dart";
import "package:sonorus/src/modules/base/chat/chat_module.dart";
import "package:sonorus/src/modules/base/creation/creation_controller.dart";
import "package:sonorus/src/modules/base/creation/creation_module.dart";
import "package:sonorus/src/modules/base/marketplace/marketplace_controller.dart";
import "package:sonorus/src/modules/base/marketplace/marketplace_module.dart";
import "package:sonorus/src/modules/base/timeline/timeline_controller.dart";
import "package:sonorus/src/modules/base/timeline/timeline_module.dart";
import "package:sonorus/src/repositories/business/business_repository.dart";
import "package:sonorus/src/repositories/business/business_repository_impl.dart";
import "package:sonorus/src/repositories/chat/chat_repository.dart";
import "package:sonorus/src/repositories/chat/chat_repository_impl.dart";
import "package:sonorus/src/repositories/creation/creation_repository.dart";
import "package:sonorus/src/repositories/creation/creation_repository_impl.dart";
import "package:sonorus/src/repositories/marketplace/marketplace_repository_impl.dart";
import "package:sonorus/src/repositories/marketplace/marketplace_repository.dart";
import "package:sonorus/src/repositories/timeline/timeline_repository.dart";
import "package:sonorus/src/repositories/timeline/timeline_repository_impl.dart";
import "package:sonorus/src/services/business/business_service.dart";
import "package:sonorus/src/services/business/business_service_impl.dart";
import "package:sonorus/src/services/chat/chat_service.dart";
import "package:sonorus/src/services/chat/chat_service_impl.dart";
import "package:sonorus/src/services/creation/creation_service.dart";
import "package:sonorus/src/services/creation/creation_service_impl.dart";
import "package:sonorus/src/services/marketplace/marketplace_service.dart";
import "package:sonorus/src/services/marketplace/marketplace_service_impl.dart";
import "package:sonorus/src/services/timeline/timeline_service.dart";
import "package:sonorus/src/services/timeline/timeline_service_impl.dart";

class BaseModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton<TimelineRepository>(() => TimelineRepositoryImpl(Modular.get()));
    i.addLazySingleton<TimelineService>(TimelineServiceImpl.new);
    i.addLazySingleton(TimelineController.new);
    
    i.addLazySingleton<BusinessRepository>(() => BusinessRepositoryImpl(Modular.get()));
    i.addLazySingleton<BusinessService>(BusinessServiceImpl.new);
    i.addLazySingleton(BusinessController.new);

    i.addLazySingleton<CreationRepository>(() => CreationRepositoryImpl(Modular.get()));
    i.addLazySingleton<CreationService>(CreationServiceImpl.new);
    i.addLazySingleton(CreationController.new);

    i.addLazySingleton<MarketplaceRepository>(() => MarketplaceRepositoryImpl(Modular.get()));
    i.addLazySingleton<MarketplaceService>(MarketplaceServiceImpl.new);
    i.addLazySingleton(MarketplaceController.new);

    i.addLazySingleton<ChatRepository>(() => ChatRepositoryImpl(Modular.get()));
    i.addLazySingleton<ChatService>(ChatServiceImpl.new);
    i.addLazySingleton(ChatController.new);
  }

  @override
  void routes(r) {
    r.child(
      "/",
      child: (context) => const BasePage(),
      children: [
        ModuleRoute(
          "/timeline",
          module: TimelineModule()
        ),
        ModuleRoute(
          "/marketplace",
          module: MarketplaceModule()
        ),
        ModuleRoute(
          "/creation",
          module: CreationModule()
        ),
        ModuleRoute(
          "/business",
          module: BusinessModule()
        ),
        ModuleRoute(
          "/chats",
          module: ChatModule()
        )
      ]
    );
  }
}