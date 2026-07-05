import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  bool _isLoggingOut = false;
  int _currentIndex = 0;

  static const List<Widget> _pages = [
    Center(child: Text(AppStrings.bottomNavigatorHome)),
    Center(child: Text(AppStrings.bottomNavigatorLibrary)),
    Center(child: Text(AppStrings.bottomNavigatorFavorites)),
    Center(child: Text(AppStrings.bottomNavigatorProfile)),
  ];

  Future<void> _showLogoutDialog() async {
    if (_isLoggingOut) return;

    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.logoutDialogTitle),
        content: const Text(AppStrings.logoutDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppStrings.logout),
          ),
        ],
      ),
    );

    if (shouldLogout ?? false) {
      await _performLogout();
    }
  }

  Future<void> _performLogout() async {
    setState(() => _isLoggingOut = true);
    try {
      await _authService.signOut();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppStrings.logOutError}${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoggingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.homeTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: _isLoggingOut ? null : _showLogoutDialog,
            ),
          ],
        ),
        body: Stack(
          children: [
            _pages[_currentIndex],
            if (_isLoggingOut)
              Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: colorScheme.primary.withValues(alpha: 0.4),
          backgroundColor: colorScheme.surface,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: AppStrings.bottomNavigatorHome,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music),
              label: AppStrings.bottomNavigatorLibrary,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: AppStrings.bottomNavigatorFavorites,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: AppStrings.bottomNavigatorProfile,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: colorScheme.primary,
          onPressed: () {},
          child: const Icon(Icons.add, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        drawer: SafeArea(
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
                    _showLogoutDialog();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
