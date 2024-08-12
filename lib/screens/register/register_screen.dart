import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:h/components/container_background_component.dart';
import 'package:h/components/button_components.dart';
import 'package:h/components/textfield_component.dart';
import 'package:h/controllers/user_controller.dart';
import 'package:h/utils/notification_snack_bar.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _userController = Get.put(UserController());

  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _dateBirthController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  RxBool obscurePasswordText = RxBool(true);
  RxBool obscureConfirmPasswordText = RxBool(true);

  void _launchPrivacyPolicy() async {
    const url = 'https://www.iubenda.com/privacy-policy/20491208';
    await launchUrlString(url);
  }

  void _launchTerms() async {
    const url = 'https://www.iubenda.com/privacy-policy/20491208';
    await launchUrlString(url);
  }

  @override
  Widget build(BuildContext context) {
    RxBool termos = RxBool(false);

    DateTime? selectedDate;

    final dateFormat = DateFormat('dd/MM/yyyy');

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SingleChildScrollView(
          child: ContainerBackgroundComponent(
            padding: 10,
            widget: Column(
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
                        controller: _emailController,
                        labelText: "e-mail *",
                        width: 100.w,
                      ),
                      SizedBox(height: 2.h),
                      TextFieldComponent(
                        controller: _userNameController,
                        labelText: "usuário *",
                        width: 100.w,
                      ),
                      SizedBox(height: 2.h),
                      TextFieldComponent(
                        controller: _telephoneController,
                        labelText: "telefone",
                        width: 100.w,
                      ),
                      SizedBox(height: 2.h),
                      SizedBox(
                        width: 100.w,
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
                                _dateBirthController.text =
                                    dateFormat.format(date);
                              },
                              currentTime: selectedDate ?? DateTime.now(),
                              locale: LocaleType.pt,
                            );
                          },
                          controller: _dateBirthController,
                          decoration: InputDecoration(
                            labelText: 'Data de nascimento *',
                            hintText: 'Selecione uma data',
                            hintStyle: Theme.of(context).textTheme.labelSmall,
                            labelStyle: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: Colors.grey,
                                ),
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
                      Obx(
                        () => TextFieldComponent(
                          controller: _passwordController,
                          labelText: "senha *",
                          width: 100.w,
                          obscureText: obscurePasswordText.value,
                          tapObscure: () => obscurePasswordText.value =
                              !obscurePasswordText.value,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Obx(
                        () => TextFieldComponent(
                          controller: _confirmPasswordController,
                          labelText: "confirme a senha *",
                          width: 100.w,
                          obscureText: obscureConfirmPasswordText.value,
                          tapObscure: () => obscureConfirmPasswordText.value =
                              !obscureConfirmPasswordText.value,
                        ),
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
                                    text: "Veja as ",
                                  ),
                                  TextSpan(
                                    text: "políticas de privacidade.",
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = _launchPrivacyPolicy,
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
                        child: CustomButtonComponent(
                          onPressed: () {
                            if (termos.isFalse) {
                              NotificationSnackbar.showError(
                                context,
                                'É necessário concordar com os termos.',
                              );
                              return;
                            }
                            if (_emailController.text == '' ||
                                _userNameController.text == '' ||
                                _dateBirthController.text == '' ||
                                _passwordController.text == '' ||
                                _confirmPasswordController.text == '') {
                              NotificationSnackbar.showError(
                                context,
                                'Preencha todos campos obrigatórios que contém *.',
                              );
                              return;
                            }
                            if (_passwordController.value !=
                                _confirmPasswordController.value) {
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
                              _userController
                                  .criar(
                                _emailController.text,
                                _userNameController.text,
                                _passwordController.text,
                                _telephoneController.text,
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
