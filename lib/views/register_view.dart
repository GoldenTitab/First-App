import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/views/login_view.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('صفحه ثبت‌نام'),
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(hintText: "ایمیل خود را وارد کنید."),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(hintText: "رمز خود را وارد کنید."),
          ),
          TextButton(
            onPressed: () async {
              try {
                final userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                      email: _email.text.trim(),
                      password: _password.text.trim(),
                    );
                await userCredential.user?.sendEmailVerification();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'ایمیل تأیید ارسال شد. لطفاً صندوق ورودی خود را چک کنید.',
                      ),
                    ),
                  );
                  Navigator.of(context).pop();
                }
              } on FirebaseAuthException catch (e) {
                String errorMessage = "خطا در ثبت‌نام.";
                if (e.code == 'weak-password') {
                  errorMessage = 'رمز عبور بسیار ضعیف است.';
                } else if (e.code == 'email-already-in-use') {
                  errorMessage = 'این ایمیل قبلاً ثبت شده است.';
                } else if (e.code == 'invalid-email') {
                  errorMessage = 'ایمیل نامعتبر است.';
                }
                showError(errorMessage);
              } catch (e) {
                showError("خطا: ${e.toString()}");
              }
            },
            child: const Text("ثبت‌نام"),
          ),
        ],
      ),
    );
  }
}
