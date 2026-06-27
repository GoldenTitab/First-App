import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/views/register_view.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: Text('صفحه ورود'),
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
                    .signInWithEmailAndPassword(
                      email: _email.text,
                      password: _password.text,
                    );
              } on FirebaseAuthException catch (e) {
                print('Error: ${e.code}');
              }
            },
            child: const Text("ورود"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const RegisterView()),
              );
            },
            child: const Text("ثبت‌نام نکرده‌اید؟ ایجاد حساب جدید"),
          ),
        ],
      ),
    );
  }
}
