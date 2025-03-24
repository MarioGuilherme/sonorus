import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/modules/navigation/chat/chat_controller.dart";
import "package:sonorus/src/modules/navigation/navigation_page.dart";
import "package:sonorus/src/modules/navigation/opportunity/opportunity_controller.dart";
import "package:sonorus/src/modules/navigation/post/post_controller.dart";
import "package:sonorus/src/modules/navigation/product/product_controller.dart";
import "package:sonorus/src/modules/navigation/product/product_details_controller.dart";
import "package:sonorus/src/repositories/opportunity/opportunity_repository.dart";
import "package:sonorus/src/repositories/opportunity/opportunity_repository_impl.dart";
import "package:sonorus/src/repositories/post/post_repository.dart";
import "package:sonorus/src/repositories/post/post_repository_impl.dart";
import "package:sonorus/src/repositories/product/product_repository.dart";
import "package:sonorus/src/repositories/product/product_repository_impl.dart";
import "package:sonorus/src/services/opportunity/opportunity_service.dart";
import "package:sonorus/src/services/opportunity/opportunity_service_impl.dart";
import "package:sonorus/src/services/post/post_service.dart";
import "package:sonorus/src/services/post/post_service_impl.dart";
import "package:sonorus/src/services/product/product_service.dart";
import "package:sonorus/src/services/product/product_service_impl.dart";

class NavigationModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton<PostRepository>(() => PostRepositoryImpl(Modular.get()));
    i.addLazySingleton<PostService>(PostServiceImpl.new);
    i.addLazySingleton<PostController>(() => PostController(Modular.get(), Modular.get()));
    
    i.addLazySingleton<OpportunityRepository>(() => OpportunityRepositoryImpl(Modular.get()));
    i.addLazySingleton<OpportunityService>(OpportunityServiceImpl.new);
    i.addLazySingleton(OpportunityController.new);

    i.addLazySingleton<ProductRepository>(() => ProductRepositoryImpl(Modular.get()));
    i.addLazySingleton<ProductService>(ProductServiceImpl.new);
    i.addLazySingleton(ProductController.new);
    i.addLazySingleton(ProductDetailsController.new);

    i.addLazySingleton<ChatController>(() => ChatController(Modular.get()));
  }

  @override
  void routes(r) => r.child(Modular.initialRoute, child: (context) => const NavigationPage());
}