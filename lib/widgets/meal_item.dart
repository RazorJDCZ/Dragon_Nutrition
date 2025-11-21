import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MealItem extends StatelessWidget {
  final String name;
  final int calories;

  const MealItem({
    super.key,
    required this.name,
    required this.calories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundImage: AssetImage("assets/food.png"),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          ),
          Text("$calories kcal", style: const TextStyle(color: AppTheme.accent)),
        ],
      ),
    );
  }
}
