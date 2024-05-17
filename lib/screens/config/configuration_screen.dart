import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:h/components/animated_bar_component.dart';
import 'package:h/components/bottom_bar_component.dart';
import 'package:h/components/button_config_component.dart';
import 'package:h/components/circular_progress_component.dart';
import 'package:h/components/container_background_component.dart';
import 'package:h/controllers/login_controller.dart';
import 'package:h/controllers/user_controller.dart';
import 'package:sizer/sizer.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  RxBool showBar = RxBool(true);
  RxBool loading = RxBool(false);

  double scrollPosition = 0.0;
  double prevScrollPosition = 0.0;

  final _loginController = Get.put(LoginController());
  final _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: NotificationListener<ScrollUpdateNotification>(
          onNotification: (notification) {
            scrollPosition = notification.metrics.pixels;
            final scrollDirection = scrollPosition - prevScrollPosition;
            if (scrollDirection > 0) {
              showBar.value = false;
            } else {
              showBar.value = true;
            }
            prevScrollPosition = scrollPosition;
            return false;
          },
          child: ContainerBackgroundComponent(
            widget: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      ButtonConfigComponent(
                        text: 'Desativar conta',
                        onTap: () async {
                          loading.value = true;
                          bool disabled = await _userController.desactivateUser(
                            _loginController.userLogged.first,
                            context,
                          );
                          if (disabled) {
                            Get.offAllNamed('/login');
                          }
                          loading.value = false;
                        },
                      ),
                      ButtonConfigComponent(
                        text: 'Sair',
                        onTap: () async {
                          loading.value = true;
                          bool disconnected =
                              await _loginController.logoff(context);
                          if (disconnected) {
                            Get.offAllNamed('/login');
                          }
                          loading.value = false;
                        },
                      ),
                    ],
                  ),
                ),
                AnimatedBarComponent(
                  showBar: showBar,
                  getBack: false,
                  hasFocus: false,
                  searched: false,
                ),
                BottomBarComponent(
                  showBar: showBar,
                  index: 2,
                ),
                CircularProgressComponent(loading: loading),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
