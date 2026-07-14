import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onLogout;

  const CustomDrawer({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // ← SafeArea باید داخل Drawer باشه، نه بیرونش
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
                      AppStrings.drawerMenu,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              ListTile(
                title: const Text(AppStrings.drawerList),
                textColor: Colors.white,
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                title: const Text(AppStrings.drawerFavorites),
                textColor: Colors.white,
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                title: const Text(AppStrings.drawerSettings),
                textColor: Colors.white,
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                title: const Text(AppStrings.drawerAbout),
                textColor: Colors.white,
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                title: const Text(AppStrings.drawerLogOut),
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
