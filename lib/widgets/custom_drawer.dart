import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onOpenFavorites;

  const CustomDrawer({
    super.key,
    required this.onLogout,
    required this.onOpenFavorites,
  });

  /// Closes the drawer and tells the user the feature is not built yet.
  void _comingSoon(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(const SnackBar(content: Text(AppStrings.comingSoon)));
  }

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
                title: const Text(AppStrings.playlist),
                textColor: colorScheme.onSurface,
                onTap: () => _comingSoon(context),
              ),
              ListTile(
                leading: Icon(Icons.favorite, color: colorScheme.primary),
                title: const Text(AppStrings.favorites),
                textColor: colorScheme.onSurface,
                onTap: () {
                  Navigator.of(context).pop();
                  onOpenFavorites();
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: colorScheme.primary),
                title: const Text(AppStrings.settings),
                textColor: colorScheme.onSurface,
                onTap: () => _comingSoon(context),
              ),
              ListTile(
                leading: Icon(Icons.info, color: colorScheme.primary),
                title: const Text(AppStrings.about),
                textColor: colorScheme.onSurface,
                onTap: () => _comingSoon(context),
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.logout, color: colorScheme.error),
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
