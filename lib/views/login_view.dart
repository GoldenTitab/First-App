import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import '../utils/exception_handler.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      await _authService.signInWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );
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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.loginTitle),
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
            // دکمه ورود با نمایش لودینگ
            _isLoading
                ? const CircularProgressIndicator()
                : TextButton(
                    onPressed: _login,
                    child: Text(AppStrings.loginButton),
                  ),
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
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
