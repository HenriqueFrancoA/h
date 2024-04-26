import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:h/firebase_options.dart';
import 'package:h/screens/cadastro/cadastro_screen.dart';
import 'package:h/screens/home/home_screen.dart';
import 'package:h/screens/loading/loading_screen.dart';
import 'package:h/screens/login/login_screen.dart';
import 'package:h/screens/mensagem/mensagem_screen.dart';
import 'package:h/screens/perfil/perfil_screen.dart';
import 'package:h/screens/publicacao/publicacao_screen.dart';
import 'package:h/screens/publicar/publicar_screen.dart';
import 'package:h/themes/themes.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sizer/sizer.dart';

bool salvarAcesso = false;
String email = '';
String senha = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initializeDateFormatting('pt_BR', null).then((_) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugInvertOversizedImages = true;
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
          title: '',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          theme: darkTheme,
          home: const LoadingScreen(),
          getPages: [
            GetPage(
              name: '/loading',
              page: () => const LoadingScreen(),
            ),
            GetPage(
              name: '/login',
              page: () => const LoginScreen(),
            ),
            GetPage(
              name: '/cadastro',
              page: () => const CadastroScreen(),
            ),
            GetPage(
              name: '/home',
              page: () => const HomeScreen(),
            ),
            GetPage(
              name: '/publicar',
              page: () => const PublicarScreen(),
            ),
            GetPage(
              name: '/publicacao/:id',
              page: () => const PublicacaoScreen(),
            ),
            GetPage(
              name: '/perfil/:id',
              page: () => const PerfilScreen(),
            ),
            GetPage(
              name: '/mensagem',
              page: () => const MensagemScreen(),
            ),
          ]);
    });
  }
}
