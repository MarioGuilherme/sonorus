import "package:convex_bottom_bar/convex_bottom_bar.dart";
import "package:flutter/material.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/modules/base/business/business_page.dart";
import "package:sonorus/src/modules/base/chat/chat_page.dart";
import "package:sonorus/src/modules/base/create-post/create_post_page.dart";
import "package:sonorus/src/modules/base/marketplace/marketplace_page.dart";
import "package:sonorus/src/modules/base/marketplace/widgets/product.dart";
import "package:sonorus/src/modules/base/marketplace/widgets/sonorus_app_bar.dart";
import "package:sonorus/src/modules/base/timeline/timeline_page.dart";

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
          body: PageView(
            onPageChanged: (value) => this.setState(() => this.indexPage = value),
            controller: this._controllerPageView,
            children: const [
              TimelinePage(),
              MarketplacePage(),
              CreatePostPage(),
              BusinessPage(),
              ChatPage()
            ]
          )
        ),
        bottomNavigationBar: ConvexAppBar.badge(
          { 4: this.indexPage == 4 ? "" :  "+9" },
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
            TabItem(icon: Icons.shopping_cart, title: "Compras"),
            TabItem(icon: Icons.add_circle, title: "Criar"),
            TabItem(icon: Icons.handshake, title: "Negócios"),
            TabItem(icon: Icons.chat, title: "Chat"),
          ],
          onTap: (value) {
            setState(() => this.indexPage = value);
            this._controllerPageView.jumpToPage(value);
          }
        )
      )
      
      
      
      
      // Scaffold(
      //   backgroundColor: const Color(0xFF16161F),
      //   body: CustomScrollView(
      //     slivers: [
      //       SliverAppBar(
      //         flexibleSpace: SonorusAppBar(),
      //         backgroundColor: Colors.transparent
      //       ),
      //       SliverFillRemaining(
      //         child: PageView(
      //           onPageChanged: (value) => this.setState(() => this.indexPage = value),
      //           controller: this._controllerPageView,
      //           children: const [
      //             TimelinePage(),
      //             MarketplacePage(),
      //             CreatePostPage(),
      //             BusinessPage(),
      //             ChatPage()
      //           ]
      //         )
      //       )
      //     ]
      //   ),
      //   bottomNavigationBar: Container(
      //     clipBehavior: Clip.hardEdge,
      //     height: 85,
      //     decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      //     child: BottomNavigationBar(
      //       currentIndex: this.indexPage,
      //       onTap: (value) {
      //         setState(() => this.indexPage = value);
      //         this._controllerPageView.jumpToPage(value);
      //       },
      //       type: BottomNavigationBarType.fixed,
      //       backgroundColor: const Color(0xFF373739),
      //       selectedItemColor: context.colors.primary,
      //       unselectedItemColor: Colors.white.withAlpha(100),
      //       items: const [
      //         BottomNavigationBarItem(
      //           label: "Menu",
      //           icon: Icon(Icons.home)
      //         ),
      //         BottomNavigationBarItem(
      //           label: "Compras",
      //           icon: Icon(Icons.shopping_cart)
      //         ),
      //         BottomNavigationBarItem(
      //           label: "Criar",
      //           icon: Icon(Icons.add_circle, size: 48)
      //         ),
      //         BottomNavigationBarItem(
      //           label: "Negócios",
      //           icon: Icon(Icons.handshake)
      //         ),
      //         BottomNavigationBarItem(
      //           label: "Chat",
      //           icon: Icon(Icons.chat)
      //         )
      //       ]
      //     )
      //   )
      // )
    );
  }
}