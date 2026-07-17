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
          color: colorScheme.surface,
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
                leading: Icon(Icons.playlist_play, color: colorScheme.primary),
                title: Text(AppStrings.playlist),
                textColor: colorScheme.onSurface,
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: Icon(Icons.favorite, color: colorScheme.primary),
                title: Text(AppStrings.favorites),
                textColor: colorScheme.onSurface,
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: Icon(Icons.settings, color: colorScheme.primary),
                title: Text(AppStrings.settings),
                textColor: colorScheme.onSurface,
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: Icon(Icons.info, color: colorScheme.primary),
                title: Text(AppStrings.about),
                textColor: colorScheme.onSurface,
                onTap: () => Navigator.of(context).pop(),
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.logout, color: colorScheme.error),
                title: Text(AppStrings.logout),
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
