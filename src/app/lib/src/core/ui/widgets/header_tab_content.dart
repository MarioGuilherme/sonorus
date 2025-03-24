import "package:flutter/material.dart";

import "package:sonorus/src/core/extensions/font_size_extension.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/debouncer.dart";

class HeaderTabContent extends StatelessWidget {
  final String entityName;
  final bool showForm;
  final bool isEdit;
  final VoidCallback onUpdatedShowForm;
  final Future<void> Function({ String? name }) onCallDebouncer;
  final TextEditingController _searchEC = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  HeaderTabContent({
    required this.entityName,
    required this.showForm,
    required this.isEdit,
    required this.onUpdatedShowForm,
    required this.onCallDebouncer,
    super.key
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Row(
      children: [
        this.showForm
          ? Expanded(child: Text("${this.isEdit ? "EDITANDO" : "CRIANDO"} ${this.entityName}".toUpperCase(), style: context.textStyles.textBold.withFontSize(18), textAlign: TextAlign.center))
          : Expanded(
              child: TextFormField(
                textInputAction: TextInputAction.search,
                controller: this._searchEC,
                style: context.textStyles.textRegular,
                onChanged: (value) => this._debouncer.call(() async => this.onCallDebouncer(name: value)),
                decoration: const InputDecoration(label: Text("Pesquisar"), prefixIcon: Icon(Icons.search, size: 24))
              )
            ),
        SizedBox(width: 15),
        IconButton.filled(onPressed: this.onUpdatedShowForm, icon: Icon(this.showForm ? Icons.list_alt : Icons.add))
      ]
    )
  );
}
