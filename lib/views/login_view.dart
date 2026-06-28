// lib/views/login_view.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/error_handler.dart';
import '../utils/constants.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      await _authService.signInWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );
      // در صورت موفقیت، AuthWrapper وضعیت را مدیریت می‌کند
    } on FirebaseAuthException catch (e) {
      ErrorHandler.showError(context, AuthService.getErrorMessage(e));
    } catch (e) {
      ErrorHandler.showError(
        context,
        '${AppStrings.unknownError}${e.toString()}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.loginTitle),
        actions: const [
          Icon(Icons.search),
        ], // اگر جستجو واقعی ندارید، می‌توانید حذف کنید
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(hintText: AppStrings.emailHint),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(hintText: AppStrings.passwordHint),
            ),
            const SizedBox(height: 20),
            TextButton(onPressed: _login, child: Text(AppStrings.loginButton)),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.register);
              },
              child: Text(AppStrings.goToRegister),
            ),
          ],
        ),
      ),
    );
  }
}
