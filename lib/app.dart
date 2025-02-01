import 'package:flutter/material.dart';
import 'screens/main/main.dart';
import 'screens/login/login.dart';
import 'screens/login/register.dart';
import 'screens/login/verification.dart';
import 'screens/main/profile.dart';
import 'style.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Search',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const Search(),
        '/register': (context) => const RegisterPage(),
        '/verification': (context) => const VerificationPage(),
        '/profile': (context) => const ProfilePage(),
      },
      theme: appTheme,
    );
  }
}