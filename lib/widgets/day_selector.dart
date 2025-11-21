import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DaySelector extends StatelessWidget {
  final int selected;
  final Function(int) onSelect;

  const DaySelector({super.key, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Past 3 days + today + next 3 days
    final days = List.generate(7, (i) => now.subtract(Duration(days: 3 - i)));

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, i) {
          final date = days[i];
          final isSelected = selected == i;

          return GestureDetector(
            onTap: () => onSelect(i),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Text(
                    _weekday(date.weekday),
                    style: TextStyle(
                      color: isSelected ? AppTheme.accent : Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: isSelected
                          ? AppTheme.accent.withOpacity(0.2)
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? AppTheme.accent : Colors.grey,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        color: isSelected ? AppTheme.accent : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _weekday(int value) {
    switch (value) {
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thu";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:
        return "";
    }
  }
}
