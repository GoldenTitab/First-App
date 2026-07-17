import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onLogout;

  const CustomDrawer({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      width: 250,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colorScheme.primary, colorScheme.secondary],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 100,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: colorScheme.primary),
                  child: const Center(
                    child: Text(
                      AppStrings.menu,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              ListTile(
                title: const Text(AppStrings.playlist),
                textColor: colorScheme.onPrimary,
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                title: const Text(AppStrings.favorites),
                textColor: colorScheme.onPrimary,
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                title: const Text(AppStrings.settings),
                textColor: colorScheme.onPrimary,
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                title: const Text(AppStrings.about),
                textColor: colorScheme.onPrimary,
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                title: const Text(AppStrings.logout),
                textColor: colorScheme.error,
                onTap: () {
                  Navigator.of(context).pop();
                  onLogout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
