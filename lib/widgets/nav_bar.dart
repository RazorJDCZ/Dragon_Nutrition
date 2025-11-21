import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/settings_screen.dart';
import '../theme/app_theme.dart';

class NavBar extends StatelessWidget {
  final int index;

  const NavBar({super.key, required this.index});

  void navigate(BuildContext ctx, int page) {
    if (page == index) return;

    switch (page) {
      case 0:
        Navigator.pushReplacement(
            ctx, MaterialPageRoute(builder: (_) => const HomeScreen()));
        break;
      case 1:
        Navigator.pushReplacement(
            ctx, MaterialPageRoute(builder: (_) => const ProgressScreen()));
        break;
      case 2:
        Navigator.pushReplacement(
            ctx, MaterialPageRoute(builder: (_) => const SettingsScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppTheme.bg,
      currentIndex: index,
      onTap: (i) => navigate(context, i),
      selectedItemColor: AppTheme.accent,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Progress"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
      ],
    );
  }
}
