import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FabMenu extends StatelessWidget {
  final VoidCallback onScan;

  const FabMenu({super.key, required this.onScan});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppTheme.accent,
      child: const Icon(Icons.add, size: 32, color: Colors.black),
      onPressed: onScan,
    );
  }
}
