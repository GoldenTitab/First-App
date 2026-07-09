import 'package:first_app/utils/app_theme.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import '../utils/exception_handler.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_text_field.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final AuthService _authService = AuthService();
  bool _isLoading = false;

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
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final userCredential = await _authService.signUpWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );
      final user = userCredential.user;
      if (user != null) {
        await _authService.sendEmailVerification(user);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.emailVerificationSent),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        await ExceptionHandler.showErrorDialog(context, e, onRetry: _register);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.registerTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 48),
            const Icon(
              Icons.person_add_rounded,
              size: 64,
              color: AppTheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.registerTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            CustomTextField(
              controller: _emailController,
              hint: AppStrings.emailHint,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _passwordController,
              hint: AppStrings.passwordHint,
              prefixIcon: Icons.lock_outline,
              obscureText: true,
            ),
            const SizedBox(height: 24),
            CustomElevatedButton(
              label: AppStrings.registerButton,
              onPressed: _register,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
