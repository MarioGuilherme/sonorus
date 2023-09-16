import "package:flutter/material.dart";

import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/models/interest_model.dart";

class MultiSelector extends StatefulWidget {
  final String title;
  final List<InterestModel> selecteds;
  final List<InterestModel> allItens;
  final void Function(InterestModel) onSelected;

  const MultiSelector({ super.key, required this.title, required this.selecteds, required this.allItens, required this.onSelected });

  @override
  State<MultiSelector> createState() => _MultiSelectorState();
}

class _MultiSelectorState extends State<MultiSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: context.colors.primary, width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: context.colors.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    this.widget.title,
                    style: context.textStyles.textSemiBold.copyWith(fontSize: 20, color: Colors.white)
                  )
                ),
                IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {})
              ]
            )
          ),
          Container(
            height: 52,
            padding: const EdgeInsets.all(7.5),
            child: this.widget.allItens.isEmpty
              ? const CircularProgressIndicator()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: this.widget.allItens.length,
                  itemBuilder: (context, index) => _MultiSelectorItem(data: this.widget.allItens[index], onSelected: this.widget.onSelected)
                )
          )
        ]
      )
    );
  }
}

class _MultiSelectorItem extends StatefulWidget {
  final InterestModel data;
  final void Function(InterestModel) onSelected;

  const _MultiSelectorItem({ required this.data, required this.onSelected });

  @override
  State<_MultiSelectorItem> createState() => _MultiSelectorItemState();
}

class _MultiSelectorItemState extends State<_MultiSelectorItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Material(
        color: context.colors.secondary,
        child: InkWell(
          onTap: () {
            this.widget.onSelected(this.widget.data);
            setState(() => this.isSelected = !this.isSelected);
          },
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: context.colors.primary.withOpacity(this.isSelected ? .6 : .25),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: context.colors.primary.withOpacity(this.isSelected ? .25 : .6), width: 2)
            ),
            child: Text(
              this.widget.data.value!,
              style: context.textStyles.textSemiBold.copyWith(fontSize: 16, color: Colors.white)
            )
          )
        )
      )
    );
  }
}