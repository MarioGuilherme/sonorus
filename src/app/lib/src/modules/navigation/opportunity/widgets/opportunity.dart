import "package:flutter/material.dart";

import "package:sonorus/src/core/extensions/currency_extension.dart";
import "package:sonorus/src/core/extensions/font_size_extension.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/dtos/view_models/opportunity_view_model.dart";

class Opportunity extends StatelessWidget {
  final OpportunityViewModel opportunityViewModel;
  final void Function(OpportunityViewModel) onPressedShowOpportunity;

  const Opportunity({
    required this.opportunityViewModel,
    required this.onPressedShowOpportunity,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 80,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: double.infinity,
                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.horizontal(left: Radius.circular(7))),
                  child: Icon(this.opportunityViewModel.isWork ? Icons.card_travel : Icons.group_add, color: Colors.black, size: 32)
                )
              ),
              Expanded(
                flex: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                  decoration: BoxDecoration(
                    color: context.colors.primary,
                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(7))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        this.opportunityViewModel.name,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyles.textBold.withFontSize(18)
                      ),
                      Row(
                        children: [
                          const Icon(Icons.paid, size: 24),
                          const SizedBox(width: 5),
                          Text(this.opportunityViewModel.payment.currency, style: context.textStyles.textMedium.withFontSize(12)),
                          Text(
                            this.opportunityViewModel.workTimeUnitString,
                            style: context.textStyles.textMedium.withFontSize(12)
                          )
                        ]
                      ),
                      Text(
                        "Experiência: ${this.opportunityViewModel.experienceRequired}",
                        style: context.textStyles.textMedium.withFontSize(11)
                      )
                    ]
                  )
                )
              )
            ]
          )
        ),
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Material(
              color: Colors.transparent,
              child: InkWell(onTap: () => this.onPressedShowOpportunity(opportunityViewModel))
            )
          )
        )
      ]
    );
  }
}