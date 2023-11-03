import "dart:math";

import "package:flutter/material.dart";
import "package:shimmer/shimmer.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/utils/size_extensions.dart";

class RandomPostShimmer extends StatelessWidget {
   const RandomPostShimmer({ super.key });

  @override
  Widget build(BuildContext context) {
    final bool withMedias = Random().nextBool();
    final bool withTablature = Random().nextBool();
    final int totalLines = Random().nextInt(4) + 1;
    final double sizeOfLastLine = (1 + Random().nextInt(context.screenWidth.toInt() - 1 + 1)).toDouble();

    return Column(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            color: Color(0xFF404048)
          ),
          child: Shimmer.fromColors(
            baseColor: context.colors.secondary,
            highlightColor: Colors.grey.withAlpha(75),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipOval(
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  color: Colors.white
                                )
                              ),
                              const SizedBox(width: 10),
                              Container(width: 180, height: 10, color: Colors.white)
                            ]
                          ),
                          Container(
                            width: 50,
                            height: 10,
                            color: Colors.white
                          )
                        ]
                      ),
                       const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < totalLines - 1; i++) ...[
                            Container(height: 10, color: Colors.white),
                            const SizedBox(height: 10)
                          ],
                          Container(
                            width: sizeOfLastLine,
                            height: 10,
                            color: Colors.white
                          )
                        ]
                      ),
                      const SizedBox(height: 10),
                      if (withMedias) ...[
                        Container(
                          margin:  const EdgeInsets.only(bottom: 10),
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white
                          )
                        )
                      ]
                    ]
                  )
                )
              ]
            ),
          )
        ),
        Container(
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.only(top: 2),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            color: Color(0xFF16161F)
          ),
          child: Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 91, 91, 100),
            highlightColor: Colors.grey.withAlpha(200),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    width: 90,
                    height: 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
                      color: Colors.white
                    )
                  )
                ),
                if (withTablature) ...[
                  const SizedBox(width: 2.5),
                  Container(
                    width: 64,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white
                    )
                  )
                ],
                 const SizedBox(width: 2.5),
                Expanded(
                  child: Container(
                    width: 90,
                    height: 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
                      color: Colors.white
                    )
                  )
                )
              ]
            ),
          )
        )
      ]
    );
  }
}