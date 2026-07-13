import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../utils/app_routes.dart';
import '../utils/constants.dart';
import '../utils/exception_handler.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_text_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
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

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      await _authService.signInWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );
      if (mounted) {
        context.go(AppRoutes.home);
      }
    } catch (e) {
      if (mounted) {
        await ExceptionHandler.showErrorDialog(context, e, onRetry: _login);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 59),
                Image.asset(
                  'assets/images/SplashScreen.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(AppStrings.loginTitle),

                      const SizedBox(height: 80),

                      CustomTextField(
                        controller: _emailController,
                        hint: AppStrings.emailHint,
                        prefixIcon: Icons.email_outlined,
                      ),

                      const SizedBox(height: 8),

                      CustomTextField(
                        controller: _passwordController,
                        hint: AppStrings.passwordHint,
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('رمز خود را فراموش کرده‌اید؟'),
                        ),
                      ),

                      const SizedBox(height: 24),

                      CustomElevatedButton(
                        label: AppStrings.loginButton,
                        onPressed: _login,
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
