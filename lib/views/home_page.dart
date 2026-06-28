// lib/views/home_page.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.homeTitle),
        actions: [
          IconButton(
            icon: const RotatedBox(
              quarterTurns: 2,
              child: Icon(Icons.more_vert, color: Colors.black),
            ),
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(AppStrings.logoutDialogTitle),
                    content: Text(AppStrings.logoutDialogContent),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(AppStrings.cancel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(AppStrings.logout),
                      ),
                    ],
                  );
                },
              );
              if (shouldLogout ?? false) {
                await _authService.signOut();
              }
            },
          ),
        ],
      ),
      body: const Center(child: Text(AppStrings.welcome)),
    );
  }
}
