import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/nav_bar.dart';
import '../theme/app_theme.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ TIPAMOS EXPLÍCITAMENTE COMO double
    final List<double> weeklyProtein = [60, 80, 100, 75, 90, 110, 95];
    final List<double> weeklyCarbs   = [120, 150, 160, 140, 200, 180, 175];
    final List<double> weeklyFats    = [40, 50, 55, 45, 60, 58, 62];

    const proteinColor = Color(0xFFEF5350); // rojo suave
    const carbsColor   = Color(0xFFFFCA28); // amarillo
    const fatsColor    = Color(0xFF42A5F5); // azul
    const double objective = 200.0;

    return Scaffold(
      bottomNavigationBar: const NavBar(index: 1),
      appBar: AppBar(
        title: const Text("Weekly Progress"),
        backgroundColor: AppTheme.bg,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            maxY: 250,
            minY: 0,
            barGroups: List.generate(7, (i) {
              return BarChartGroupData(
                x: i,
                barsSpace: 4,
                barRods: [
                  BarChartRodData(
                    // ✅ ahora es double
                    toY: weeklyProtein[i],
                    width: 8,
                    color: proteinColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  BarChartRodData(
                    toY: weeklyCarbs[i],
                    width: 8,
                    color: carbsColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  BarChartRodData(
                    toY: weeklyFats[i],
                    width: 8,
                    color: fatsColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(),   // sin títulos arriba
              leftTitles: const AxisTitles(),  // sin ejes a la izquierda
              rightTitles: const AxisTitles(), // ni a la derecha
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
                    final idx = value.toInt();
                    if (idx < 0 || idx >= days.length) return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        days[idx],
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
            ),
            gridData: const FlGridData(show: false),
            // ✅ línea punteada del objetivo
            extraLinesData: ExtraLinesData(
              horizontalLines: [
                HorizontalLine(
                  y: objective,
                  color: Colors.white30,
                  strokeWidth: 2,
                  dashArray: [8, 8],
                ),
              ],
            ),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }
}
