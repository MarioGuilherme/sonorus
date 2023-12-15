import "package:brasil_fields/brasil_fields.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_modular/flutter_modular.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:sonorus/src/core/extensions/time_ago_extension.dart";
import "package:sonorus/src/core/ui/styles/colors_app.dart";
import "package:sonorus/src/core/ui/styles/text_styles.dart";
import "package:sonorus/src/core/ui/utils/loader.dart";
import "package:sonorus/src/core/ui/utils/messages.dart";
import "package:sonorus/src/models/chat_model.dart";
import "package:sonorus/src/models/current_user_model.dart";
import "package:sonorus/src/models/opportunity_model.dart";
import "package:sonorus/src/models/work_time_unit.dart";
import "package:sonorus/src/modules/base/business/business_controller.dart";
import "package:validatorless/validatorless.dart";

class Opportunity extends StatefulWidget{
  final OpportunityModel opportunity;

  const Opportunity({ super.key, required this.opportunity });

  @override
  State<Opportunity> createState() => _OpportunityState();
}

class _OpportunityState extends State<Opportunity> with Loader, Messages {
  final TextEditingController _nameEC = TextEditingController();
  final TextEditingController _descriptionEC = TextEditingController();
  final TextEditingController _paymentEC = TextEditingController();
  final TextEditingController _experienceEC = TextEditingController();
  final TextEditingController _bandNameEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  WorkTimeUnit? _workTimeUnit = WorkTimeUnit.perShow;

  final BusinessController _controller = Modular.get<BusinessController>();

  @override
  Widget build(BuildContext context) {
    final bool isMyOpportunity = this.widget.opportunity.recruiter.userId == Modular.get<CurrentUserModel>().userId;

    return Stack(
      children: [
        SizedBox(
          height: 70,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(7))
                  ),
                  child: Icon(
                    this.widget.opportunity.isWork ? Icons.card_travel : Icons.group_add,
                    color: Colors.black,
                    size: 32
                  )
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
                        this.widget.opportunity.name,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyles.textBold.copyWith(fontSize: 18.sp)
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ...[
                              const Icon(
                                Icons.paid,
                                color: Colors.white,
                                size: 24
                              ),
                              const SizedBox(width: 5),
                              Text(
                                this.widget.opportunity.formatedCurrency,
                                style: context.textStyles.textMedium.copyWith(fontSize: 12.sp)
                              ),
                              Text(
                                this.widget.opportunity.workTimeUnitString,
                                style: context.textStyles.textMedium.copyWith(fontSize: 12.sp)
                              )
                            ]
                            ]
                          ),
                          Text(
                            "Experiência: ${this.widget.opportunity.experienceRequired}",
                            style: context.textStyles.textMedium.copyWith(fontSize: 11.sp)
                          )
                        ]
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
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
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
                                  Expanded(
                                    child: Icon(
                                      this.widget.opportunity.isWork ? Icons.card_travel : Icons.group_add,
                                      color: Colors.white,
                                      size: 32
                                    )
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          FittedBox(
                                            clipBehavior: Clip.none,
                                            child: Text(
                                              this.widget.opportunity.name,
                                              style: context.textStyles.textExtraBold.copyWith(color: Colors.white, fontSize: 20.sp)
                                            )
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                if (this.widget.opportunity.isWork) ...[
                                                  TextSpan(
                                                    text: this.widget.opportunity.formatedCurrency,
                                                    style: context.textStyles.textSemiBold.copyWith(color: const Color.fromARGB(255, 124, 249, 128), fontSize: 16.sp)
                                                  ),
                                                  TextSpan(
                                                    text: " ${this.widget.opportunity.workTimeUnitString}",
                                                    style: context.textStyles.textMedium.copyWith(fontSize: 14.sp)
                                                  )
                                                ] else ...[
                                                  TextSpan(
                                                    text: "Banda: ${this.widget.opportunity.bandName}",
                                                    style: context.textStyles.textMedium.copyWith(fontSize: 14.sp)
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
                                    style: context.textStyles.textBold.copyWith(fontSize: 16.sp)
                                  ),
                                  Text(
                                    this.widget.opportunity.isWork
                                      ? "Trabalho"
                                      : "Participação de banda",
                                    textAlign: TextAlign.justify,
                                    style: context.textStyles.textRegular.copyWith(fontSize: 12.sp)
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Experiência requerida: ",
                                    textAlign: TextAlign.justify,
                                    style: context.textStyles.textBold.copyWith(fontSize: 16.sp)
                                  ),
                                  Text(
                                    this.widget.opportunity.experienceRequired,
                                    textAlign: TextAlign.justify,
                                    style: context.textStyles.textRegular.copyWith(fontSize: 12.sp)
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Descrição",
                                    textAlign: TextAlign.justify,
                                    style: context.textStyles.textBold.copyWith(fontSize: 16.sp)
                                  ),
                                  Text(
                                    this.widget.opportunity.description ?? "Nenhuma descrição",
                                    textAlign: TextAlign.justify,
                                    style: context.textStyles.textRegular.copyWith(fontSize: 12.sp)
                                  ),
                                  const SizedBox(height: 10),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: isMyOpportunity ? "Você" : this.widget.opportunity.recruiter.nickname,
                                      style: context.textStyles.textBold.copyWith(color: Colors.black, fontSize: 12.sp),
                                      children: [
                                        TextSpan(
                                          text: " anunciou esta oportunidade há ",
                                          style: context.textStyles.textRegular.copyWith(fontSize: 12.sp)
                                        ),
                                        TextSpan(
                                          text: this.widget.opportunity.announcedAt.timeAgo,
                                          style: context.textStyles.textBold.copyWith(fontSize: 12.sp)
                                        )
                                      ]
                                    )
                                  ),
                                  const SizedBox(height: 10),
                                  if (isMyOpportunity) ...[
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                            title: Text("Tem certeza?", textAlign: TextAlign.center, style: context.textStyles.textBold.copyWith(color: Colors.black, fontSize: 20.sp)),
                                            content: Text("Ao definir esta oportunidade como preenchida, ele será removida das oportunidades existentes, deseja prosseguir?", textAlign: TextAlign.center, style: context.textStyles.textRegular.copyWith(fontSize: 16.sp)),
                                            actionsAlignment: MainAxisAlignment.center,
                                            actions: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ElevatedButton.icon(
                                                    onPressed: () {
                                                      Modular.to.pop();
                                                      this.showLoader();
                                                      this._controller.deleteOpportunityById(this.widget.opportunity.opportunityId).then((_) {
                                                        this.hideLoader();
                                                        showDialog(
                                                          context: this.context,
                                                          builder: (context) => AlertDialog(
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                            title: Text("Sucesso", textAlign: TextAlign.center, style: context.textStyles.textBold.copyWith(color: Colors.black, fontSize: 20.sp)),
                                                            content: Text("Oportunidade encerrada e removida com sucesso", textAlign: TextAlign.center, style: context.textStyles.textRegular.copyWith(fontSize: 16.sp)),
                                                            actionsAlignment: MainAxisAlignment.center,
                                                            actions: [
                                                              ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                  shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(20))
                                                                ),
                                                                onPressed: () {
                                                                  Modular.to.popUntil(ModalRoute.withName("/business"));
                                                                  this._controller.getAllOpportunities();
                                                                },
                                                                child: Text("OK", style: context.textStyles.textLight.copyWith(fontSize: 14.sp))
                                                              )
                                                            ]
                                                          )
                                                        );
                                                      });
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      padding: const EdgeInsets.all(10)
                                                    ),
                                                    label: const Text("Sim"),
                                                    icon: const Icon(Icons.check)
                                                  ),
                                                  const SizedBox(width: 10,),
                                                  ElevatedButton.icon(
                                                    onPressed: Modular.to.pop,
                                                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10)),
                                                    label: const Text("Não"),
                                                    icon: const Icon(Icons.cancel)
                                                  )
                                                ]
                                              )
                                            ]
                                          )
                                        );
                                      },
                                      icon: const Icon(Icons.offline_pin),
                                      label: const Text("Marcar como preenchida")
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        this._controller.toggleIsWork(this.widget.opportunity.isWork);
                                        setState(() {
                                          this._workTimeUnit = WorkTimeUnit.parse(this.widget.opportunity.workTimeUnit?.id ?? 2);
                                        });
                                        this._bandNameEC.text = this.widget.opportunity.bandName ?? "";
                                        this._descriptionEC.text = this.widget.opportunity.description ?? "";
                                        this._nameEC.text = this.widget.opportunity.name;
                                        this._paymentEC.text = this.widget.opportunity.payment.toString();
                                        this._experienceEC.text = this.widget.opportunity.experienceRequired;
                                        showDialog(
                                          context: this.context,
                                          builder: (context) => Material(
                                            color: Colors.transparent,
                                            child: Container(
                                              margin: const EdgeInsets.all(10),
                                              padding: const EdgeInsets.all(10),
                                              color: context.colors.secondary,
                                              child: Form(
                                                key: this._formKey,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    SizedBox(
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          Modular.to.pop();
                                                        },
                                                        child: const Icon(Icons.close)
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            "Editando oportunidade",
                                                            textAlign: TextAlign.center,
                                                            style: context.textStyles.textBold.copyWith(fontSize: 22.sp)
                                                          ),
                                                          const SizedBox(height: 10),
                                                          TextFormField(
                                                            textInputAction: TextInputAction.next,
                                                            controller: this._nameEC,
                                                            style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                                            validator: Validatorless.multiple([
                                                              Validatorless.required("O nome da oportunidade é obrigatório."),
                                                              Validatorless.max(50, "O nome pode ter no máximo 50 caracteres.")
                                                            ]),
                                                            decoration: InputDecoration(
                                                              label: Text("Nome da oportunidade", style: context.textStyles.textBold.copyWith(fontSize: 18.sp)),
                                                              prefixIcon: const Icon(Icons.assignment, color: Colors.white, size: 24),
                                                              isDense: true
                                                            )
                                                          ),
                                                          const SizedBox(height: 20),
                                                          TextFormField(
                                                            textInputAction: TextInputAction.next,
                                                            controller: this._experienceEC,
                                                            style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                                            validator: Validatorless.multiple([
                                                              Validatorless.required("A experiência mínima para a oportunidade é obrigatória."),
                                                              Validatorless.max(25, "O nome pode ter no máximo 25 caracteres.")
                                                            ]),
                                                            decoration: InputDecoration(
                                                              label: Text("Experiência requerida", style: context.textStyles.textBold.copyWith(fontSize: 18.sp)),
                                                              prefixIcon: const Icon(Icons.verified, color: Colors.white, size: 24),
                                                              isDense: true
                                                            )
                                                          ),
                                                          const SizedBox(height: 20),
                                                          TextFormField(
                                                            textInputAction: TextInputAction.newline,
                                                            keyboardType: TextInputType.multiline,
                                                            maxLines: null,
                                                            minLines: 5,
                                                            controller: this._descriptionEC,
                                                            style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                                            validator: Validatorless.max(255, "A descrição da oportunidade pode ter no máximo 255 caracteres."),
                                                            decoration: InputDecoration(
                                                              label: Text("Descrição", style: context.textStyles.textBold.copyWith(fontSize: 18.sp)),
                                                              prefixIcon: const Icon(Icons.description, color: Colors.white, size: 24),
                                                              isDense: true
                                                            )
                                                          ),
                                                          Observer(
                                                            builder: (context) {
                                                              if (this._controller.isWork)
                                                                return Column(
                                                                  children: [
                                                                    const SizedBox(height: 20),
                                                                    TextFormField(
                                                                      textInputAction: TextInputAction.next,
                                                                      controller: this._bandNameEC,
                                                                      style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                                                      validator: Validatorless.max(50, "O nome da banda pode no máximo 50 caracteres."),
                                                                      decoration: InputDecoration(
                                                                        label: Text("Nome da banda", style: context.textStyles.textBold.copyWith(fontSize: 18.sp)),
                                                                        prefixIcon: const Icon(Icons.groups, color: Colors.white, size: 24),
                                                                        isDense: true
                                                                      )
                                                                    )
                                                                  ],
                                                                );
                                                              
                                                              return Column(
                                                                children: [
                                                                  const SizedBox(height: 20),
                                                                  TextFormField(
                                                                    inputFormatters: [
                                                                      FilteringTextInputFormatter.digitsOnly,
                                                                      CentavosInputFormatter(moeda: true),
                                                                    ],
                                                                    keyboardType: TextInputType.number,
                                                                    textInputAction: TextInputAction.next,
                                                                    controller: this._paymentEC,
                                                                    style: context.textStyles.textRegular.copyWith(color: Colors.white),
                                                                    decoration: InputDecoration(
                                                                      label: Text("Pagamento", style: context.textStyles.textBold.copyWith(fontSize: 18.sp)),
                                                                      prefixIcon: const Icon(Icons.attach_money, color: Colors.white, size: 24),
                                                                      isDense: true
                                                                    )
                                                                  ),
                                                                ],
                                                              );
                                                            }
                                                          ),
                                                          const SizedBox(height: 10),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "É para formação de banda?",
                                                                style: context.textStyles.textBold.copyWith(fontSize: 18.sp)
                                                              ),
                                                              Observer(
                                                                builder: (context) {
                                                                  return Checkbox(
                                                                    value: this._controller.isWork,
                                                                    activeColor: context.colors.primary,
                                                                    fillColor: MaterialStateProperty.resolveWith((_) {
                                                                      return context.colors.primary.withAlpha(127);
                                                                    }),
                                                                    onChanged: (value) {
                                                                      this._bandNameEC.clear();
                                                                      this._paymentEC.clear();
                                                                      this._controller.toggleIsWork(!this._controller.isWork);
                                                                    }
                                                                  );
                                                                }
                                                              )
                                                            ]
                                                          ),
                                                          const SizedBox(height: 20),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                "Será pago por:",
                                                                style: context.textStyles.textBold.copyWith(fontSize: 18.sp)
                                                              ),
                                                              const SizedBox(width: 30),
                                                              DropdownButton<WorkTimeUnit>(
                                                                icon: Icon(Icons.arrow_drop_down, size: 28, color: context.colors.primary),
                                                                isDense: true,
                                                                value: this._workTimeUnit,
                                                                style: context.textStyles.textMedium.copyWith(fontSize: 14.sp, color: context.colors.primary),
                                                                underline: Container(),
                                                                onChanged: (value) {
                                                                  setState(() {
                                                                    this._workTimeUnit = value;
                                                                  });
                                                                },
                                                                items: const [
                                                                  DropdownMenuItem<WorkTimeUnit>(
                                                                    value: WorkTimeUnit.perDays,
                                                                    child: Text("Dia")
                                                                  ),
                                                                  DropdownMenuItem<WorkTimeUnit>(
                                                                    value: WorkTimeUnit.perHours,
                                                                    child: Text("Horas")
                                                                  ),
                                                                  DropdownMenuItem<WorkTimeUnit>(
                                                                    value: WorkTimeUnit.perShow,
                                                                    child: Text("Show")
                                                                  )
                                                                ]
                                                              )
                                                            ]
                                                          )
                                                        ],
                                                      )
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(disabledBackgroundColor: Colors.grey),
                                                      onPressed: () async {
                                                        final bool formValid = this._formKey.currentState?.validate() ?? false;

                                                        if (formValid) {
                                                          showLoader();
                                                          await this._controller.updateOpportunity(
                                                            this.widget.opportunity.opportunityId,
                                                            this._nameEC.text,
                                                            this._descriptionEC.text,
                                                            this._workTimeUnit ?? WorkTimeUnit.perShow,
                                                            this._controller.isWork ? this._bandNameEC.text : null,
                                                            this._experienceEC.text,
                                                            this._paymentEC.text.isEmpty ? null : UtilBrasilFields.converterMoedaParaDouble(this._paymentEC.text),
                                                            this._controller.isWork
                                                          ).then((_) {
                                                            hideLoader();
                                                            showDialog(
                                                              barrierDismissible: true,
                                                              context: this.context,
                                                              builder: (context) => AlertDialog(
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                                title: Text("Sucesso", textAlign: TextAlign.center, style: context.textStyles.textBold.copyWith(color: Colors.black, fontSize: 20.sp)),
                                                                content: Text("Oportunidade atuaizada com sucesso", textAlign: TextAlign.center, style: context.textStyles.textRegular.copyWith(fontSize: 16.sp)),
                                                                actionsAlignment: MainAxisAlignment.center,
                                                                actions: [
                                                                  ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(20))
                                                                    ),
                                                                    onPressed: () {
                                                                      Modular.to.pop();
                                                                      Modular.to.pop();
                                                                      Modular.to.pop();
                                                                      this._controller.getAllOpportunities();
                                                                    },
                                                                    child: Text("Ok", style: context.textStyles.textLight.copyWith(fontSize: 14.sp))
                                                                  )
                                                                ]
                                                              )
                                                            );
                                                          });
                                                        }
                                                      },
                                                      child: const Text("Atualizar")
                                                    )
                                                  ]
                                                )
                                              )
                                            )
                                          )
                                        );
                                      },
                                      icon: const Icon(Icons.edit),
                                      label: const Text("Editar")
                                    )
                                  ] else
                                    ElevatedButton.icon(
                                      onPressed: () => Modular.to.popAndPushNamed(
                                        "/chat/",
                                        arguments: [
                                          "Olá, tenho interesse nesta sua ${this.widget.opportunity.isWork ? "oportunidade de trabalho" : "oportunidade para entrar na banda"} \"${this.widget.opportunity.name}\", ainda está disponível?",
                                          ChatModel(
                                            friend: this.widget.opportunity.recruiter,
                                            messages: []
                                          )
                                        ]
                                      ),
                                      icon: const Icon(Icons.card_travel),
                                      label: const Text("Aplicar à vaga")
                                    )
                                ]
                              )
                            )
                          ]
                        )
                      )
                    )
                  );
                }
              )
            )
          )
        )
      ]
    );
  }
}