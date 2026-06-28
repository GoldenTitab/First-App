import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'services/auth_service.dart';
import 'utils/constants.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/verify_email_view.dart';
import 'views/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fa', 'IR'), Locale('en', 'US')],
      locale: const Locale('fa', 'IR'),
      title: AppStrings.appTitle,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primarySwatch: Colors.blueGrey,
        fontFamily: "Vazir",
        appBarTheme: const AppBarTheme(backgroundColor: Colors.blueGrey),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        fontFamily: "Vazir",
        appBarTheme: const AppBarTheme(backgroundColor: Colors.blueGrey),
      ),
      themeMode: ThemeMode.system,
      home: const AuthWrapper(),
      routes: {
        AppRoutes.login: (context) => const LoginView(),
        AppRoutes.register: (context) => const RegisterView(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          final user = snapshot.data;
          if (user != null && user.emailVerified) {
            return const HomePage();
          } else {
            return const VerifyEmailView();
          }
        }
        return const LoginView();
      },
    );
  }
}
