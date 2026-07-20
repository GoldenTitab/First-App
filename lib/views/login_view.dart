import 'package:first_app/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import '../utils/exception_handler.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_text_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Image.asset(
                'assets/images/splash_logo.png',
                width: 80,
                height: 80,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: colorScheme.primary),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      AppStrings.loginTitle,
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _emailController,
                      hint: AppStrings.emailHint,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: AppValidators.email,
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _passwordController,
                      hint: AppStrings.passwordHint,
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                      validator: AppValidators.password,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(AppStrings.forgotPassword),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomElevatedButton(
                      label: AppStrings.login,
                      onPressed: _login,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 64),
                    Text(
                      AppStrings.loginWaysText,
                      style: TextStyle(color: colorScheme.secondary),
                    ),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: Divider(
                          color: colorScheme.onSurface.withValues(alpha: 0.2),
                          thickness: 1,
                          height: 16,
                        ),
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Text(
                              String.fromCharCode(
                                FontAwesomeIcons.spotify.codePoint,
                              ),
                              style: TextStyle(
                                fontFamily: FontAwesomeIcons.spotify.fontFamily,
                                package: FontAwesomeIcons.spotify.fontPackage,
                                fontSize: 24,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1.4
                                  ..color = colorScheme.onSurface,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Text(
                              String.fromCharCode(
                                FontAwesomeIcons.apple.codePoint,
                              ),
                              style: TextStyle(
                                fontFamily: FontAwesomeIcons.apple.fontFamily,
                                package: FontAwesomeIcons.apple.fontPackage,
                                fontSize: 24,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1.2
                                  ..color = colorScheme.onSurface,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Text(
                              String.fromCharCode(
                                FontAwesomeIcons.google.codePoint,
                              ),
                              style: TextStyle(
                                fontFamily: FontAwesomeIcons.google.fontFamily,
                                package: FontAwesomeIcons.google.fontPackage,
                                fontSize: 24,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1.2
                                  ..color = colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
              TextButton(
                onPressed: () => context.go(AppRoutes.register),
                child: const Text(AppStrings.dontHaveAnAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
