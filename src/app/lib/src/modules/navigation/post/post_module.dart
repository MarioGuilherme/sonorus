import "package:flutter_modular/flutter_modular.dart";

import "package:sonorus/src/modules/navigation/post/post_page.dart";

class PostModule extends Module {
  @override
  void routes(r) => r.child(Modular.initialRoute, child: (context) => PostPage());
}