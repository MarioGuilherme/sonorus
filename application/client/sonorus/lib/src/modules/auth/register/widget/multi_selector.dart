import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/models/interest_model.dart";
import "package:sonorus/src/models/interest_type.dart";
import "package:sonorus/src/modules/auth/register/interests_controller.dart";

class MultiSelector extends StatefulWidget {
  final String title;
  final List<InterestModel>? selecteds;
  final List<InterestModel>? allItens;

  const MultiSelector({
    super.key,
    required this.title,
    required this.selecteds,
    this.allItens
  });

  @override
  State<MultiSelector> createState() => _MultiSelectorState();
}

class _MultiSelectorState extends State<MultiSelector> with Loader, Messages {
  final InterestsController _controller = Modular.get<InterestsController>();
  final _newInterestEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: context.colors.primary, width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            color: context.colors.primary,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    this.widget.title,
                    style: context.textStyles.textSemiBold.copyWith(fontSize: 20.sp, color: Colors.white)
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: this.context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              actionsAlignment: MainAxisAlignment.center,
                              content: TextFormField(
                                cursorColor: Colors.white,
                                controller: this._newInterestEC,
                                textInputAction: TextInputAction.send,
                                style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Adicione um interesse",
                                  fillColor: const Color.fromRGBO(85, 85, 87, 1),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black)
                                  ),
                                  hintStyle: context.textStyles.textMedium.copyWith(
                                    color: Colors.white,
                                    fontSize: 14.sp
                                  ),
                                  contentPadding: const EdgeInsets.only(left: 16)
                                )
                              ),
                              actions: [
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    final String newInterest = this._newInterestEC.text
                                      .trim()
                                      .toLowerCase()
                                      .replaceAll(" ", "-");

                                    if (newInterest.trim().isEmpty) return;

                                    Modular.to.pop();
                                    setState(() {
                                      _controller.addNewInterest(
                                        newInterest,
                                        this._newInterestEC.text,
                                        this.widget.title == "Gêneros Musicais"
                                          ? InterestType.musicalGenre
                                          : this.widget.title == "Bandas ou artistas"
                                            ? InterestType.bandOrArtist
                                            : InterestType.instrument
                                      );
                                    });
                                    this._newInterestEC.clear();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(10)
                                  ),
                                  label: const Text("Adicionar"),
                                  icon: const Icon(Icons.add)
                                )
                              ]
                            )
                          );
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white
                        )
                      )
                    )
                  )
                ]
              )
            )
          ),
          Container(
            height: 52,
            padding: const EdgeInsets.all(7.5),
            child: this.widget.allItens == null
              ? const CircularProgressIndicator()
              : this.widget.allItens!.isEmpty
                  ? Center(child: Text("Nenhum item deste tipo encontrado", style: context.textStyles.textMedium.copyWith(color: Colors.white)))
                  : ListView.separated(
                    separatorBuilder: (_, __) => const SizedBox(width: 5),
                      scrollDirection: Axis.horizontal,
                      itemCount: this.widget.allItens!.length,
                      itemBuilder: (context, index) => _MultiSelectorItem(data: this.widget.allItens![index])
                    )
          )
        ]
      )
    );
  }
}

class _MultiSelectorItem extends StatefulWidget {
  final InterestModel data;

  const _MultiSelectorItem({ required this.data });

  @override
  State<_MultiSelectorItem> createState() => _MultiSelectorItemState();
}

class _MultiSelectorItemState extends State<_MultiSelectorItem> {
  final InterestsController _controller = Modular.get<InterestsController>();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Material(
        color: context.colors.secondary,
        child: InkWell(
          onTap: () {
            this._controller.selectInterest(this.widget.data);
          },
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: context.colors.primary.withOpacity(this._controller.selectedInterests.contains(this.widget.data) ? .6 : .25),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: context.colors.primary.withOpacity(this._controller.selectedInterests.contains(this.widget.data) ? .25 : .6), width: 2)
            ),
            child: Text(
              this.widget.data.value,
              style: context.textStyles.textSemiBold.copyWith(fontSize: 16, color: Colors.white)
            )
          )
        )
      )
    );
  }
}