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
                      email: _email.text,
                      password: _password.text,
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
                print('Error: ${e.code}');
              }
            },
            child: const Text("ثبت‌نام"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/register/', (route) => false);
            },
            child: const Text("حساب دارید؟ ورود به سیستم"),
          ),
        ],
      ),
    );
  }
}
