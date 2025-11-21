import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../theme/app_theme.dart';

class CalorieCard extends StatelessWidget {
  final int calories;
  final int goal;

  const CalorieCard({
    super.key,
    required this.calories,
    this.goal = 2500,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$calories\nCalories left",
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CircularPercentIndicator(
            radius: 45.0,
            lineWidth: 8.0,
            percent: (calories / goal).clamp(0.0, 1.0),
            center: const Icon(Icons.local_fire_department, color: Colors.white),
            progressColor: AppTheme.accent,
            backgroundColor: Colors.white12,
            circularStrokeCap: CircularStrokeCap.round,
          ),
        ],
      ),
    );
  }
}
