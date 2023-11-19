import "package:convex_bottom_bar/convex_bottom_bar.dart";
import "package:flutter/material.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/modules/base/business/business_page.dart";
import "package:sonorus/src/modules/base/chat/chat_page.dart";
import "package:sonorus/src/modules/base/creation/creation_page.dart";
import "package:sonorus/src/modules/base/marketplace/marketplace_page.dart";
import "package:sonorus/src/modules/base/timeline/timeline_page.dart";
import "package:sonorus/src/modules/base/widgets/sonorus_app_bar.dart";

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int indexPage = 0;
  final PageController _controllerPageView = PageController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF16161F),
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => [SonorusAppBar()],
          body: Padding(
            padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
            child: PageView(
              onPageChanged: (value) => this.setState(() => this.indexPage = value),
              controller: this._controllerPageView,
              children: const [
                TimelinePage(),
                BusinessPage(),
                CreationPage(),
                MarketplacePage(),
                ChatPage()
              ]
            )
          )
        ),
        bottomNavigationBar: ConvexAppBar(
          initialActiveIndex: this.indexPage,
          height: 60,
          top: -17.5,
          curveSize: 67.5,
          style: TabStyle.reactCircle,
          backgroundColor: const Color(0xFF373739),
          color: Colors.white.withAlpha(100),
          activeColor: context.colors.primary,
          items: const [
            TabItem(icon: Icons.home, title: "Menu"),
            TabItem(icon: Icons.work, title: "Trabalhos"),
            TabItem(icon: Icons.add_circle, title: "Criar"),
            TabItem(icon: Icons.shopping_cart, title: "Compras"),
            TabItem(icon: Icons.chat, title: "Chat")
          ],
          onTap: (value) {
            setState(() => this.indexPage = value);
            this._controllerPageView.jumpToPage(value);
          }
        )
      )
    );
  }
}