import 'dart:async';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

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
    _timer = Timer.periodic(AppDurations.emailVerificationCheck, (timer) async {
      await _authService.reloadUser();
      final user = _authService.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        if (mounted) setState(() {});
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطا: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.verifyEmailTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                AppStrings.verifyEmailMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                'اگر ایمیلی دریافت نکرده‌اید، روی دکمه زیر کلیک کنید.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              _isResending
                  ? const CircularProgressIndicator()
                  : TextButton(
                      onPressed: _resendVerificationEmail,
                      child: const Text('ارسال مجدد ایمیل تأیید'),
                    ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  await _authService.signOut();
                },
                child: const Text('خروج از حساب'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
