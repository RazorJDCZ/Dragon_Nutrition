import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../theme/app_theme.dart';
import '../widgets/fab_menu.dart';
import '../widgets/day_selector.dart';
import '../widgets/calorie_card.dart';
import '../widgets/macro_card.dart';
import '../widgets/meal_item.dart';
import '../widgets/nav_bar.dart';
import '../services/openai_service.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedDay = 3; // hoy es el centro del selector

  int dailyCalories = 0;
  int caloriesLeft = 0;
  int proteinLeft = 0;
  int carbsLeft = 0;
  int fatsLeft = 0;

  bool loadingUser = true;

  List<Map<String, dynamic>> meals = [];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final snap = await AuthService().getCurrentUserData();
      if (snap.exists) {
        final data = snap.data()!;
        final int mantenimiento =
            (data['caloriasMantenimiento'] as num?)?.toInt() ?? 0;

        setState(() {
          dailyCalories = mantenimiento;
          caloriesLeft = mantenimiento;

          // Objetivos de macros simples
          proteinLeft = (mantenimiento * 0.3 / 4).round();
          carbsLeft = (mantenimiento * 0.5 / 4).round();
          fatsLeft = (mantenimiento * 0.2 / 9).round();
          loadingUser = false;
        });
      } else {
        setState(() => loadingUser = false);
      }
    } catch (e) {
      setState(() => loadingUser = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error cargando tu perfil nutricional'),
          ),
        );
      }
    }
  }

  void _recalculateCaloriesLeft() {
    final totalConsumed = meals.fold<int>(
      0,
      (sum, m) => sum + (m['calories'] as int? ?? 0),
    );
    setState(() {
      caloriesLeft = (dailyCalories - totalConsumed).clamp(0, dailyCalories);
    });
  }

  // 📸 Cámara + análisis con IA
  Future<void> scanFood() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.camera);

    if (img == null) return;

    final data = await OpenAIService.analyzeFoodImage(File(img.path));

    final c = (data["calories"] as num?)?.toInt() ?? 0;

    setState(() {
      meals.add({
        "name": data["name"] ?? "Food",
        "calories": c,
      });
    });

    _recalculateCaloriesLeft();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✔ Barra inferior restaurada
      bottomNavigationBar: const NavBar(index: 0),

      // ✔ Botón flotante + para abrir la cámara
      floatingActionButton: FabMenu(onScan: scanFood),

      body: loadingUser
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TÍTULO
                  const Text(
                    "USFQ Nutrition",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accent,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // SELECTOR DE DÍAS
                  DaySelector(
                    selected: selectedDay,
                    onSelect: (i) => setState(() => selectedDay = i),
                  ),

                  const SizedBox(height: 25),

                  // TARJETA DE CALORÍAS
                  CalorieCard(
                    calories: caloriesLeft,
                    goal: dailyCalories, // ahora viene de Firestore
                  ),

                  const SizedBox(height: 25),

                  // TARJETAS DE MACROS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MacroCard(
                        title: "Protein left",
                        value: "${proteinLeft}g",
                        icon: Icons.set_meal,
                      ),
                      MacroCard(
                        title: "Carbs left",
                        value: "${carbsLeft}g",
                        icon: Icons.grass,
                      ),
                      MacroCard(
                        title: "Fats left",
                        value: "${fatsLeft}g",
                        icon: Icons.bubble_chart,
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

                  // TÍTULO DE RECENTLY
                  const Text(
                    "Recently uploaded",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accent,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // MENSAJE SI NO HAY COMIDAS
                  if (meals.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppTheme.cardDark.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          "Tap + to add your first meal of the day",
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ),

                  // LISTA DE COMIDAS REGISTRADAS
                  for (var m in meals)
                    MealItem(
                      name: m["name"],
                      calories: m["calories"],
                    ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }
}
