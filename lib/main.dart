import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:h/firebase_options.dart';
import 'package:h/screens/config/configuration_screen.dart';
import 'package:h/screens/home/home_screen.dart';
import 'package:h/screens/loading/loading_screen.dart';
import 'package:h/screens/login/login_screen.dart';
import 'package:h/screens/message/message_screen.dart';
import 'package:h/screens/profile/profile_screen.dart';
import 'package:h/screens/publication/publication_screen.dart';
import 'package:h/screens/publish/publish_screen.dart';
import 'package:h/screens/register/register_screen.dart';
import 'package:h/screens/search/search_screen.dart';
import 'package:h/screens/user/users_screen.dart';
import 'package:h/themes/themes.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sizer/sizer.dart';

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
          themeMode: ThemeMode.dark,
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
              name: '/register',
              page: () => const RegisterScreen(),
            ),
            GetPage(
              name: '/home',
              page: () => const HomeScreen(),
            ),
            GetPage(
              name: '/publish',
              page: () => const PublishScreen(),
            ),
            GetPage(
              name: '/publication/:id',
              page: () => const PublicationScreen(),
            ),
            GetPage(
              name: '/profile/:id',
              page: () => const ProfileScreen(),
            ),
            GetPage(
              name: '/message',
              page: () => const MessageScreen(),
            ),
            GetPage(
              name: '/users',
              page: () => const UsersScreen(),
            ),
            GetPage(
              name: '/search',
              page: () => const SearchScreen(),
            ),
            GetPage(
              name: '/config',
              page: () => const ConfigurationScreen(),
            ),
          ]);
    });
  }
}
