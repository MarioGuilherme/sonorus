import "package:flutter/material.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/modules/navigation/chat/chat_page.dart";
import "package:sonorus/src/modules/navigation/opportunity/opportunity_page.dart";
import "package:sonorus/src/modules/navigation/post/post_page.dart";
import "package:sonorus/src/modules/navigation/product/product_page.dart";
import "package:sonorus/src/modules/navigation/widgets/sonorus_app_bar.dart";

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final PageController _controllerPageView = PageController();
  int _indexPage = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SonorusAppBar(onBackProfilePage: () => this.setState(() {})),
        backgroundColor: const Color(0xFF16161F),
        body: PageView(
          onPageChanged: (value) => this.setState(() => this._indexPage = value),
          controller: this._controllerPageView,
          children: const [
            Padding(padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6), child: PostPage()),
            Padding(padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6), child: OpportunityPage()),
            Padding(padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6), child: ProductPage()),
            Padding(padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6), child: ChatPage())
          ]
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: context.colors.primary,
          iconSize: 28,
          currentIndex: this._indexPage,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 15,
          unselectedFontSize: 13,
          selectedLabelStyle: context.textStyles.textSemiBold,
          unselectedLabelStyle: context.textStyles.textRegular,
          unselectedItemColor: const Color.fromARGB(255, 154, 154, 154),
          backgroundColor: const Color.fromARGB(255, 48, 48, 48),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Menu"),
            BottomNavigationBarItem(icon: Icon(Icons.work), label: "Trabalhos"),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Compras"),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat")
          ],
          onTap: (value) {
            setState(() => this._indexPage = value);
            this._controllerPageView.jumpToPage(value);
          }
        )
      )
    );
  }
}