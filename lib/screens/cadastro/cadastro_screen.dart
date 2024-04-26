import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:h/components/button_components.dart';
import 'package:h/components/textfield_component.dart';
import 'package:h/controllers/usuario_controller.dart';
import 'package:h/utils/notification_snack_bar.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final userController = Get.put(UsuarioController());

  @override
  Widget build(BuildContext context) {
    RxBool termos = RxBool(false);
    final emailController = TextEditingController();
    final usuarioController = TextEditingController();
    final telefoneController = TextEditingController();
    final dataNascimentoController = TextEditingController();
    final senhaController = TextEditingController();
    final confirmaSenhaController = TextEditingController();

    DateTime? selectedDate;

    final dateFormat = DateFormat('dd/MM/yyyy');

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SingleChildScrollView(
          child: Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.background,
                  Theme.of(context).colorScheme.onBackground,
                ],
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: 3.h),
                SizedBox(
                  width: 90.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 30,
                          child: Image.asset(
                            "assets/images/logoBranco.png",
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                ),
                SizedBox(height: 5.h),
                SizedBox(
                  width: 85.w,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Cadastro'.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Colors.white,
                                    fontSize: 30,
                                  ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      TextFieldComponent(
                        controller: emailController,
                        labelText: "e-mail *",
                        width: 100.w,
                        height: 50,
                      ),
                      SizedBox(height: 2.h),
                      TextFieldComponent(
                        controller: usuarioController,
                        labelText: "usuário *",
                        width: 100.w,
                        height: 50,
                      ),
                      SizedBox(height: 2.h),
                      TextFieldComponent(
                        controller: telefoneController,
                        labelText: "telefone",
                        width: 100.w,
                        height: 50,
                      ),
                      SizedBox(height: 2.h),
                      SizedBox(
                        width: 100.w,
                        height: 50,
                        child: TextFormField(
                          readOnly: true,
                          onTap: () {
                            DatePicker.showDatePicker(
                              context,
                              showTitleActions: true,
                              maxTime: DateTime(
                                DateTime.now().year - 18,
                                DateTime.now().month,
                                DateTime.now().day,
                              ),
                              onConfirm: (date) {
                                selectedDate = date;
                                dataNascimentoController.text =
                                    dateFormat.format(date);
                              },
                              currentTime: selectedDate ?? DateTime.now(),
                              locale: LocaleType.pt,
                            );
                          },
                          controller: dataNascimentoController,
                          decoration: InputDecoration(
                            labelText: 'Data de validade *',
                            hintText: 'Selecione uma data',
                            hintStyle: Theme.of(context).textTheme.labelSmall,
                            labelStyle: Theme.of(context).textTheme.labelSmall,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      TextFieldComponent(
                        controller: senhaController,
                        labelText: "senha *",
                        width: 100.w,
                        height: 50,
                        obscureText: true,
                      ),
                      SizedBox(height: 2.h),
                      TextFieldComponent(
                        controller: confirmaSenhaController,
                        labelText: "confirme a senha *",
                        width: 100.w,
                        height: 50,
                        obscureText: true,
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Obx(
                            () => Checkbox(
                              value: termos.value,
                              onChanged: (value) {
                                termos.value = !termos.value;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 70.w,
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                      color: Colors.grey,
                                    ),
                                children: [
                                  const TextSpan(
                                    text: "Li e Concordo com os ",
                                  ),
                                  TextSpan(
                                    text: "termos e políticas de privacidade.",
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      SizedBox(
                        width: 100.w,
                        height: 50,
                        child: CustomButton(
                          onPressed: () {
                            if (termos.isFalse) {
                              NotificationSnackbar.showError(
                                context,
                                'É necessário concordar com os termos.',
                              );
                              return;
                            }
                            if (emailController.text == '' ||
                                usuarioController.text == '' ||
                                dataNascimentoController.text == '' ||
                                senhaController.text == '' ||
                                confirmaSenhaController.text == '') {
                              NotificationSnackbar.showError(
                                context,
                                'Preencha todos campos obrigatórios que contém *.',
                              );
                              return;
                            }
                            if (senhaController.value !=
                                confirmaSenhaController.value) {
                              NotificationSnackbar.showError(
                                context,
                                'As senhas não são iguais',
                              );
                              return;
                            }

                            try {
                              Timestamp dataNascimento = Timestamp.fromDate(
                                DateTime(
                                  selectedDate!.year,
                                  selectedDate!.month,
                                  selectedDate!.day,
                                  0,
                                  0,
                                  0,
                                ),
                              );
                              userController
                                  .criar(
                                emailController.text,
                                usuarioController.text,
                                senhaController.text,
                                telefoneController.text,
                                dataNascimento,
                                context,
                              )
                                  .then((value) {
                                if (value) {
                                  NotificationSnackbar.showSuccess(
                                    context,
                                    'Conta criada com sucesso!',
                                  );
                                  Get.back();
                                } else {
                                  NotificationSnackbar.showError(
                                    context,
                                    'Ocorreu algum erro. Tente novamente mais tarde.',
                                  );
                                }
                              });
                            } catch (e) {
                              NotificationSnackbar.showError(
                                context,
                                e.toString(),
                              );
                            }
                          },
                          context: context,
                          text: "Criar",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
