import "package:flutter/material.dart";

import "package:sonorus/src/models/chat_model.dart";
import "package:sonorus/src/models/user_model.dart";
import "package:sonorus/src/modules/base/chat/widgets/chat.dart";
import "package:sonorus/src/modules/base/marketplace/widgets/random_product_shimmer.dart";

class TestePage extends StatelessWidget {
  const TestePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const RandomProductShimmer(),
                const SizedBox(height: 10),
                // Product(
                //   product: ProductModel(
                //     announcedAt: DateTime.now(),
                //     medias: [],
                //     price: 32,
                //     productId: 1,
                //     seller: UserModel(userId: 1, nickname: "nickname", picture: "picture")
                //   )
                // ),
                Chat(chat: ChatModel(chatId: "1", friend: UserModel(nickname: "asd", picture: "https://yt3.ggpht.com/XpOIk4Lh0Xk7ImNJ-eltmJ91TiZsZzCUFz22hlackXPk5gGBXx8KRp6ZBYx5d6kLFdb2TiOg=s48-c-k-c0x00ffffff-no-rj", userId: 2), messages: [
                  // MessageModel(isSentByMe: false, content: "content", sentAt: DateTime.now())
                ]))
              ]
            ),
          ),
        ),
      )
    );
  }
}