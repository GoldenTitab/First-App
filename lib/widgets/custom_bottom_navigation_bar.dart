import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BottomNavigationBar(
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.primary.withValues(alpha: 0.4),
      backgroundColor: colorScheme.surface,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
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
    );
  }
}
