import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../views/splash_screen.dart';
import '../views/login_view.dart';
import '../views/register_view.dart';
import '../views/home_page.dart';
import '../views/verify_email_view.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/login/register';
  static const String home = '/home';
  static const String verifyEmail = '/verify-email';

  static GoRouter get router => GoRouter(
    initialLocation: splash,
    redirect: _globalRedirect,
    routes: [
      GoRoute(path: splash, builder: (_, _) => const SplashScreen()),
      GoRoute(
        path: login,
        builder: (_, _) => const LoginView(),
        routes: [
          GoRoute(path: 'register', builder: (_, _) => const RegisterView()),
        ],
      ),
      GoRoute(path: verifyEmail, builder: (_, _) => const VerifyEmailView()),
      GoRoute(path: home, builder: (_, _) => const HomePage()),
    ],
  );

  static String? _globalRedirect(BuildContext context, GoRouterState state) {
    final user = AuthService().currentUser;
    final isOnSplash = state.matchedLocation == splash;
    final isOnAuth =
        state.matchedLocation == login ||
        state.matchedLocation == '$login/register';

    if (isOnSplash) return null;

    if (user == null) {
      return isOnAuth ? null : login;
    }

    if (!user.emailVerified) {
      return state.matchedLocation == verifyEmail ? null : verifyEmail;
    }

    if (isOnAuth || state.matchedLocation == verifyEmail) {
      return home;
    }

    return null;
  }
}
