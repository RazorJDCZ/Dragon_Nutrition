import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa email y contraseña')),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      await AuthService().login(email: email, password: pass);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Error al iniciar sesión')),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error inesperado al iniciar sesión')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "USFQ Nutrition",
              style: TextStyle(
                fontSize: 38,
                color: AppTheme.gold,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),

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
            const SizedBox(height: 20),

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

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.gold,
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
                      "Login",
                      style: TextStyle(color: Colors.black),
                    ),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text(
                "¿No tienes cuenta? Crear cuenta",
                style: TextStyle(color: AppTheme.gold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
