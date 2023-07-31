import "package:flutter/material.dart";
import "package:sonorus/app/core/ui/styles/colors_app.dart";

class TimelinePage extends StatelessWidget {
  const TimelinePage({ super.key });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            title: Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(blurRadius: 3, color: Colors.black, spreadRadius: 2)],
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 29,
                    child: CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage("https://igormiranda.com.br/wp-content/uploads/2021/11/Dave-Grohl-Foo-Fighters-2021-The-Storyteller.jpg"),
                    ),
                  ),
                )
              ]
            ),
            toolbarHeight: 70,
            backgroundColor: const Color(0xFF373739),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))
            ),
            actions: [
              Container(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: IconButton(onPressed: () {}, icon: Icon(Icons.settings, size: 42, color: context.colors.primary))
                )
              )
            ]
          )
        ),
        backgroundColor: context.colors.secondary,
        body: const Text("Ola")
      ),
    );
  }
}