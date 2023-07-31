import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:sonorus/app/core/rest_client/custom_dio.dart";
import "package:sonorus/app/pages/auth/register/register_page.dart";

class RegisterRouter {
  RegisterRouter._();

  static Widget get page => MultiProvider(
    providers: <Provider>[
      Provider<CustomDio>(create: (BuildContext context) => CustomDio())
    ],
    child: const RegisterPage()
  );
}