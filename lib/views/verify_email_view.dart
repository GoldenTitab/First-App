// lib/views/verify_email_view.dart
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

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(AppDurations.emailVerificationCheck, (timer) async {
      await _authService.reloadUser();
      final user = _authService.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        // نیازی به action نیست، زیرا AuthWrapper خودش واکنش نشان می‌دهد
        // ولی می‌توانیم بازسازی کنیم
        if (mounted) setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.verifyEmailTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(AppStrings.verifyEmailMessage),
          ],
        ),
      ),
    );
  }
}
