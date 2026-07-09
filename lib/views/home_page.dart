import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/loading_overlay.dart';

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
    final bool? shouldLogout = await CustomDialog.showLogoutConfirmation(
      context,
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
      child: LoadingOverlay(
        isLoading: _isLoggingOut,
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
          body: _pages[_currentIndex],
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: colorScheme.primary,
            onPressed: () {},
            child: const Icon(Icons.add, color: Colors.white),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
          drawer: CustomDrawer(onLogout: _showLogoutDialog),
        ),
      ),
    );
  }
}
