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
  int currentIndex = 0;

  final List<Widget> pages = [
    const Center(child: Text("خانه")),
    const Center(child: Text("کتابخانه")),
    const Center(child: Text("علاقه‌مندی‌ها")),
    const Center(child: Text("پروفایل")),
  ];

  Future<void> _showLogoutDialog() async {
    if (_isLoggingOut) return;
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
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
      setState(() => _isLoggingOut = true);
      try {
        await _authService.signOut();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطا در خروج: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoggingOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.homeTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: _isLoggingOut ? null : _showLogoutDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                AppStrings.welcome,
                style: TextStyle(color: Colors.blue, fontSize: 24),
              ),
            ),
          ),
          if (_isLoggingOut)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blue.shade200,
        backgroundColor: Colors.teal.shade50,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'خانه'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'کتابخانه',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'علاقه‌مندی‌ها',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'پروفایل'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {},
        child: Center(
          child: const Text(
            "+",
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      drawer: Drawer(
        backgroundColor: Colors.blue.shade100,
        child: ListView(
          children: [
            SizedBox(
              height: 80,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  border: Border(
                    bottom: BorderSide(color: Colors.blue.shade500, width: 2),
                  ),
                ),
                child: Center(child: Text("منو")),
              ),
            ),
            ListTile(
              title: Text("لیست پخش"),
              textColor: Colors.blue,
              onTap: () {},
            ),
            ListTile(
              title: Text("موردعلاقه"),
              textColor: Colors.blue,
              onTap: () {},
            ),
            ListTile(
              title: Text("تنظیمات"),
              textColor: Colors.blue,
              onTap: () {},
            ),
            ListTile(
              title: Text("درباره ما"),
              textColor: Colors.blue,
              onTap: () {},
            ),
            ListTile(title: Text("خانه"), textColor: Colors.blue, onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class Final {}
