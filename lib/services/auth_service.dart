// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  AuthService._internal();
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Registro con datos antropométricos.
  /// Fórmula: Mifflin-St Jeor (asumiendo hombre por ahora).
  Future<UserCredential> register({
    required String email,
    required String password,
    required double peso, // kg
    required double altura, // cm
    required int edad,
    required int actividadSemanal, // veces por semana
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // TMB (Mifflin-St Jeor) para hombre
    final double bmr = 10 * peso + 6.25 * altura - 5 * edad + 5;

    // Factor según actividad semanal
    double factor;
    if (actividadSemanal <= 1) {
      factor = 1.2;
    } else if (actividadSemanal <= 3) {
      factor = 1.375;
    } else if (actividadSemanal <= 5) {
      factor = 1.55;
    } else {
      factor = 1.725;
    }

    final double mantenimiento = bmr * factor;

    await _db.collection('usuarios').doc(cred.user!.uid).set({
      'email': email,
      'peso': peso,
      'altura': altura,
      'edad': edad,
      'actividadSemanal': actividadSemanal,
      'caloriasMantenimiento': mantenimiento.round(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    return cred;
  }

  Future<void> logout() => _auth.signOut();

  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No hay usuario autenticado');
    }
    return await _db.collection('usuarios').doc(user.uid).get();
  }

  Future<void> updateProfile({
    required double peso,
    required double altura,
    required int edad,
    required int actividadSemanal,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No hay usuario autenticado');
    }

    // Recalcular calorías de mantenimiento
    final double bmr = 10 * peso + 6.25 * altura - 5 * edad + 5;
    double factor;
    if (actividadSemanal <= 1) {
      factor = 1.2;
    } else if (actividadSemanal <= 3) {
      factor = 1.375;
    } else if (actividadSemanal <= 5) {
      factor = 1.55;
    } else {
      factor = 1.725;
    }
    final double mantenimiento = bmr * factor;

    await _db.collection('usuarios').doc(user.uid).update({
      'peso': peso,
      'altura': altura,
      'edad': edad,
      'actividadSemanal': actividadSemanal,
      'caloriasMantenimiento': mantenimiento.round(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
