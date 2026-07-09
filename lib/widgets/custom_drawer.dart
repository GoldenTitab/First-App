import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onLogout;

  const CustomDrawer({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Drawer(
        backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: colorScheme.primary),
              child: Center(
                child: Text(
                  AppStrings.drawerMenu,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            ListTile(
              title: const Text(AppStrings.drawerList),
              textColor: colorScheme.primary,
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              title: const Text(AppStrings.drawerFavorites),
              textColor: colorScheme.primary,
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              title: const Text(AppStrings.drawerSettings),
              textColor: colorScheme.primary,
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              title: const Text(AppStrings.drawerAbout),
              textColor: colorScheme.primary,
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              title: const Text(AppStrings.drawerLogOut),
              textColor: Colors.red,
              onTap: () {
                Navigator.of(context).pop();
                onLogout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
