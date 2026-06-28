// lib/views/register_view.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/error_handler.dart';
import '../utils/constants.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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

  Future<void> _register() async {
    try {
      final userCredential = await _authService.signUpWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );
      final user = userCredential.user;
      if (user != null) {
        await _authService.sendEmailVerification(user);
        if (mounted) {
          ErrorHandler.showSuccess(context, AppStrings.emailVerificationSent);
          Navigator.of(context).pop(); // بازگشت به صفحه ورود
        }
      }
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
        title: Text(AppStrings.registerTitle),
        actions: const [Icon(Icons.search)],
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
            TextButton(
              onPressed: _register,
              child: Text(AppStrings.registerButton),
            ),
          ],
        ),
      ),
    );
  }
}
