import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final pesoCtrl = TextEditingController();
  final alturaCtrl = TextEditingController();
  final edadCtrl = TextEditingController();
  final actividadCtrl = TextEditingController();

  int caloriasMantenimiento = 0;
  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    pesoCtrl.dispose();
    alturaCtrl.dispose();
    edadCtrl.dispose();
    actividadCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final snap = await AuthService().getCurrentUserData();
      if (snap.exists) {
        final data = snap.data()!;
        pesoCtrl.text = (data['peso'] ?? '').toString();
        alturaCtrl.text = (data['altura'] ?? '').toString();
        edadCtrl.text = (data['edad'] ?? '').toString();
        actividadCtrl.text = (data['actividadSemanal'] ?? '').toString();
        caloriasMantenimiento =
            (data['caloriasMantenimiento'] as num?)?.toInt() ?? 0;
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error cargando configuración')),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _saveProfile() async {
    final double? peso =
        double.tryParse(pesoCtrl.text.replaceAll(',', '.'));
    final double? altura =
        double.tryParse(alturaCtrl.text.replaceAll(',', '.'));
    final int? edad = int.tryParse(edadCtrl.text);
    final int? actividad = int.tryParse(actividadCtrl.text);

    if (peso == null || altura == null || edad == null || actividad == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Revisa los valores numéricos')),
      );
      return;
    }

    setState(() => saving = true);
    try {
      await AuthService().updateProfile(
        peso: peso,
        altura: altura,
        edad: edad,
        actividadSemanal: actividad,
      );

      // Volver a cargar para actualizar calorías
      await _loadProfile();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado')),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar el perfil')),
      );
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  Future<void> _logout() async {
    await AuthService().logout();
    if (!mounted) return;
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBar(index: 2),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Perfil nutricional",
                    style: TextStyle(
                      color: AppTheme.gold,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Calorías de mantenimiento: $caloriasMantenimiento kcal/día",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: pesoCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(color: AppTheme.gold),
                    decoration: const InputDecoration(
                      labelText: "Peso (kg)",
                      labelStyle: TextStyle(color: AppTheme.gold),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.gold),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.gold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: alturaCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(color: AppTheme.gold),
                    decoration: const InputDecoration(
                      labelText: "Altura (cm)",
                      labelStyle: TextStyle(color: AppTheme.gold),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.gold),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.gold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: edadCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: AppTheme.gold),
                    decoration: const InputDecoration(
                      labelText: "Edad (años)",
                      labelStyle: TextStyle(color: AppTheme.gold),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.gold),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.gold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: actividadCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: AppTheme.gold),
                    decoration: const InputDecoration(
                      labelText: "Actividad semanal (veces/semana)",
                      labelStyle: TextStyle(color: AppTheme.gold),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.gold),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.gold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: saving ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.gold,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: saving
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                          )
                        : const Text(
                            "Guardar cambios",
                            style: TextStyle(color: Colors.black),
                          ),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: _logout,
                    child: const Text(
                      "Cerrar sesión",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
