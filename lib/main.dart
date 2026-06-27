import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/views/login_view.dart';
import 'package:first_app/views/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fa', 'IR'), Locale('en', 'US')],
      locale: const Locale('fa', 'IR'),
      title: 'Aurora',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primarySwatch: Colors.blueGrey,
        fontFamily: "Vazir",
        appBarTheme: AppBarTheme(backgroundColor: Colors.blueGrey),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        fontFamily: "Vazir",
        appBarTheme: const AppBarTheme(backgroundColor: Colors.blueGrey),
      ),
      themeMode: ThemeMode.system,

      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          final user = snapshot.data;
          if (user != null && user.emailVerified) {
            return const HomePage();
          } else {
            return const VerifyEmailView();
          }
        }
        return const LoginView();
      },
    );
  }
}

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final user = FirebaseAuth.instance.currentUser;
      await user?.reload();

      if (user?.emailVerified ?? false) {
        timer.cancel();
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
      appBar: AppBar(title: const Text('تأیید ایمیل')),
      body: Center(child: Text('لطفاً ایمیل خود را تأیید کنید.')),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خانه'),
        actions: [
          IconButton(
            icon: RotatedBox(
              quarterTurns: 2,
              child: Icon(Icons.more_vert, color: Colors.black),
            ),
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('خروج از حساب'),
                    content: const Text(
                      'آیا مطمئن هستید که می‌خواهید خارج شوید؟',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('لغو'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('خروج'),
                      ),
                    ],
                  );
                },
              );
              if (shouldLogout ?? false) {
                await FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: const Center(child: Text('به صفحه اصلی خوش آمدید')),
    );
  }
}
