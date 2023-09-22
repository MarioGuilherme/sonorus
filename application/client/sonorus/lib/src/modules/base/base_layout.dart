import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/modules/timeline/timeline_module.dart";
import "package:sonorus/src/modules/timeline/timeline_page.dart";

class BaseLayout extends StatefulWidget {
  final Widget body;

  const BaseLayout({required this.body, super.key});

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  final PageController _controllerPageView = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16161F),
      body: PageView(
        controller: this._controllerPageView,
        children: const [
            SafeArea(child: Text("1", style: TextStyle(color: Colors.white),)),
            SafeArea(child: Text("2", style: TextStyle(color: Colors.white),)),
        ],
      ),
      bottomNavigationBar: Container(
        clipBehavior: Clip.hardEdge,
        height: 85,
        decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        child: BottomNavigationBar(
          onTap: (value) => this._controllerPageView.jumpToPage(value),
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
              label: "Meu Perfil",
              icon: Icon(Icons.person)
            )
          ]
        )
      )
    );
  }
}