import 'dart:async';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import 'auth_wrapper.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  final AuthService _authService = AuthService();
  Timer? _timer;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(AppDurations.emailVerificationCheck, (_) async {
      await _authService.reloadUser();
      final user = _authService.currentUser;

      if (user?.emailVerified ?? false) {
        _timer?.cancel();
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AuthWrapper()),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _resendVerificationEmail() async {
    if (_isResending) return;
    setState(() => _isResending = true);
    try {
      final user = _authService.currentUser;
      if (user != null && !user.emailVerified) {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppStrings.error} ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.verifyEmailTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text(
                AppStrings.verifyEmailMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                AppStrings.emailNotSent,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              if (_isResending)
                const CircularProgressIndicator()
              else
                TextButton(
                  onPressed: _resendVerificationEmail,
                  child: const Text(AppStrings.emailResend),
                ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  await _authService.signOut();
                },
                child: const Text(AppStrings.logOut),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
