import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/models/current_user_model.dart";
import "package:sonorus/src/modules/base/business/business_page.dart";
import "package:sonorus/src/modules/base/chat/chat_page.dart";
import "package:sonorus/src/modules/base/create-post/create_post_page.dart";
import "package:sonorus/src/modules/base/marketplace/marketplace_page.dart";
import "package:sonorus/src/modules/base/timeline/timeline_page.dart";

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int indexPage = 0;
  final PageController _controllerPageView = PageController();
  final CurrentUserModel _currentUser = Modular.get<CurrentUserModel>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF16161F),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: AppBar(
            backgroundColor: const Color(0xFF373739),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))
            ),
            actions: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  border: Border.all(
                    color: context.colors.primary,
                    width: 2
                  )
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Image.network(
                    this._currentUser.picture!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover
                  )
                )
              )
            ]
          )
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: PageView(
            onPageChanged: (value) => this.setState(() => this.indexPage = value),
            controller: this._controllerPageView,
            children: const [
              TimelinePage(),
              MarketplacePage(),
              CreatePostPage(),
              BusinessPage(),
              ChatPage()
            ]
          ),
        ),
        bottomNavigationBar: Container(
          clipBehavior: Clip.hardEdge,
          height: 85,
          decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
          child: BottomNavigationBar(
            currentIndex: this.indexPage,
            onTap: (value) {
              setState(() => this.indexPage = value);
              this._controllerPageView.jumpToPage(value);
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFF373739),
            selectedItemColor: context.colors.primary,
            unselectedItemColor: Colors.white.withAlpha(100),
            items: const [
              BottomNavigationBarItem(
                label: "Menu",
                icon: Icon(Icons.home)
              ),
              BottomNavigationBarItem(
                label: "Compras",
                icon: Icon(Icons.shopping_cart)
              ),
              BottomNavigationBarItem(
                label: "Criar",
                icon: Icon(Icons.add_circle, size: 48)
              ),
              BottomNavigationBarItem(
                label: "Negócios",
                icon: Icon(Icons.handshake)
              ),
              BottomNavigationBarItem(
                label: "Chat",
                icon: Icon(Icons.chat)
              ),
            ]
          )
        )
      )
    );
  }
}