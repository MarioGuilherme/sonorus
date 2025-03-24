import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

import "package:sonorus/src/core/extensions/currency_extension.dart";
import "package:sonorus/src/core/extensions/font_size_extension.dart";
import "package:sonorus/src/core/extensions/time_ago_extension.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/domain/models/authenticated_user.dart";
import "package:sonorus/src/dtos/view_models/opportunity_view_model.dart";

class OpportunityModal extends StatelessWidget {
  final OpportunityViewModel opportunityViewModel;
  final VoidCallback onPressedEditButton;
  final VoidCallback onPressedDeleteButton;

  const OpportunityModal({
    required this.opportunityViewModel,
    required this.onPressedEditButton,
    required this.onPressedDeleteButton,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final bool isMy = opportunityViewModel.recruiter!.userId == Modular.get<AuthenticatedUser>().userId;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.black),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: context.colors.primary,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset.zero
                  )
                ]
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Icon(this.opportunityViewModel.isWork ? Icons.card_travel : Icons.group_add, size: 32)),
                  const SizedBox(width: 5),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(this.opportunityViewModel.name, style: context.textStyles.textExtraBold.withFontSize(20)),
                          RichText(
                            text: TextSpan(
                              children: [
                                if (this.opportunityViewModel.isWork) ...[
                                  TextSpan(
                                    text: this.opportunityViewModel.payment.currency,
                                    style: context.textStyles.textSemiBold.copyWith(color: const Color.fromARGB(255, 124, 249, 128), fontSize: 16.sp)
                                  ),
                                  TextSpan(
                                    text: " ${this.opportunityViewModel.workTimeUnitString}",
                                    style: context.textStyles.textMedium.withFontSize(14)
                                  )
                                ] else ...[
                                  TextSpan(
                                    text: "Banda: ${this.opportunityViewModel.bandName}",
                                    style: context.textStyles.textMedium.withFontSize(14)
                                  )
                                ]
                              ]
                            )
                          )
                        ]
                      ),
                    )
                  )
                ]
              )
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Tipo de oferta: ",
                    style: context.textStyles.textBold.copyWith(color: Colors.black, fontSize: 16.sp)
                  ),
                  Text(
                    this.opportunityViewModel.isWork ? "Trabalho" : "Participação de banda",
                    textAlign: TextAlign.justify,
                    style: context.textStyles.textRegular.copyWith(color: Colors.black, fontSize: 12.sp)
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Experiência requerida: ",
                    textAlign: TextAlign.justify,
                    style: context.textStyles.textBold.copyWith(color: Colors.black, fontSize: 16.sp)
                  ),
                  Text(
                    this.opportunityViewModel.experienceRequired,
                    textAlign: TextAlign.justify,
                    style: context.textStyles.textRegular.copyWith(color: Colors.black, fontSize: 12.sp)
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Descrição",
                    textAlign: TextAlign.justify,
                    style: context.textStyles.textBold.copyWith(color: Colors.black, fontSize: 16.sp)
                  ),
                  Text(
                    this.opportunityViewModel.description ?? "Nenhuma descrição",
                    textAlign: TextAlign.justify,
                    style: context.textStyles.textRegular.copyWith(color: Colors.black, fontSize: 12.sp)
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: isMy ? "Você" : this.opportunityViewModel.recruiter!.nickname,
                      style: context.textStyles.textBold.copyWith(color: Colors.black, fontSize: 12.sp),
                      children: [
                        TextSpan(
                          text: " anunciou esta oportunidade há ",
                          style: context.textStyles.textRegular.copyWith(color: Colors.black, fontSize: 12.sp)
                        ),
                        TextSpan(
                          text: this.opportunityViewModel.announcedAt.timeAgo,
                          style: context.textStyles.textBold.copyWith(color: Colors.black, fontSize: 12.sp)
                        )
                      ]
                    )
                  ),
                  const SizedBox(height: 10),
                  if (isMy) ...[
                    ElevatedButton.icon(
                      icon: const Icon(Icons.offline_pin),
                      label: const Text("Marcar como preenchida"),
                      onPressed: this.onPressedDeleteButton
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: this.onPressedEditButton,
                      icon: const Icon(Icons.edit),
                      label: const Text("Editar")
                    )
                  ] else
                    ElevatedButton.icon(
                      icon: const Icon(Icons.card_travel),
                      label: const Text("Aplicar à vaga"),
                      onPressed: () => Modular.to.popAndPushNamed("/chat/",
                        arguments: [
                          this.opportunityViewModel.recruiter!,
                          "Olá, tenho interesse nesta sua ${this.opportunityViewModel.isWork ? "oportunidade de trabalho" : "oportunidade para entrar na banda"} \"${this.opportunityViewModel.name}\", ainda está disponível?",
                        ]
                      )
                    )
                ]
              )
            )
          ]
        )
      )
    );
  }
}