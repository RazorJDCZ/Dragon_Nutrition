import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final pass2Ctrl = TextEditingController();
  final pesoCtrl = TextEditingController();
  final alturaCtrl = TextEditingController();
  final edadCtrl = TextEditingController();
  final actividadCtrl = TextEditingController(); // veces por semana

  bool isLoading = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    pass2Ctrl.dispose();
    pesoCtrl.dispose();
    alturaCtrl.dispose();
    edadCtrl.dispose();
    actividadCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();
    final pass2 = pass2Ctrl.text.trim();

    if (email.isEmpty ||
        pass.isEmpty ||
        pass2.isEmpty ||
        pesoCtrl.text.isEmpty ||
        alturaCtrl.text.isEmpty ||
        edadCtrl.text.isEmpty ||
        actividadCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    if (pass != pass2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    final double? peso = double.tryParse(pesoCtrl.text.replaceAll(',', '.'));
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

    setState(() => isLoading = true);
    try {
      await AuthService().register(
        email: email,
        password: pass,
        peso: peso,
        altura: altura,
        edad: edad,
        actividadSemanal: actividad,
      );

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Error al registrarse')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error inesperado al registrarse')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.gold),
        title: const Text(
          'Crear cuenta',
          style: TextStyle(color: AppTheme.gold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              style: const TextStyle(color: AppTheme.gold),
              decoration: const InputDecoration(
                labelText: "Email",
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
              controller: passCtrl,
              obscureText: true,
              style: const TextStyle(color: AppTheme.gold),
              decoration: const InputDecoration(
                labelText: "Password",
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
              controller: pass2Ctrl,
              obscureText: true,
              style: const TextStyle(color: AppTheme.gold),
              decoration: const InputDecoration(
                labelText: "Confirmar password",
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
                hintText: "Ej: 3",
                hintStyle: TextStyle(color: Colors.white54),
                labelStyle: TextStyle(color: AppTheme.gold),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.gold),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.gold),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isLoading ? null : _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.gold,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: isLoading
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
                      "Registrarse",
                      style: TextStyle(color: Colors.black),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
