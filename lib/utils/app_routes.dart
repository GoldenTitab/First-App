import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../services/onboarding_service.dart';
import '../views/splash_screen.dart';
import '../views/welcome_view.dart';
import '../views/login_view.dart';
import '../views/register_view.dart';
import '../views/home_page.dart';
import '../views/verify_email_view.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/login/register';
  static const String home = '/home';
  static const String verifyEmail = '/verify-email';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    redirect: _globalRedirect,
    routes: [
      GoRoute(path: splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: welcome, builder: (_, _) => const WelcomeView()),
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

  static Future<String?> _globalRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final user = AuthService().currentUser;
    final location = state.matchedLocation;

    if (location == splash) return null;
    if (user == null) {
      final isOnAuth = location == login || location == '$login/register';
      final isOnWelcome = location == welcome;

      if (isOnAuth || isOnWelcome) return null;

      final hasSeenWelcome = await OnboardingService().hasSeenWelcome;
      return hasSeenWelcome ? login : welcome;
    }

    if (!user.emailVerified) {
      return location == verifyEmail ? null : verifyEmail;
    }

    if (location == login ||
        location == '$login/register' ||
        location == welcome ||
        location == verifyEmail) {
      return home;
    }

    return null;
  }
}
