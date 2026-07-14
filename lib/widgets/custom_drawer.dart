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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.lightBlueAccent],
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
                textColor: Colors.white,
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                title: const Text(AppStrings.favorites),
                textColor: Colors.white,
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                title: const Text(AppStrings.settings),
                textColor: Colors.white,
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                title: const Text(AppStrings.about),
                textColor: Colors.white,
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                title: const Text(AppStrings.logout),
                textColor: Colors.red[200],
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
