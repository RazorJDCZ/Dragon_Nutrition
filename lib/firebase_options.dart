// File: lib/firebase_options.dart
// GENERATED FOR PROJECT: usfq-nutrition-b42b5

import 'package:firebase_core/firebase_core.dart'
    show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Web no está configurado en este proyecto.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'iOS no está configurado para este proyecto.',
        );
      default:
        throw UnsupportedError(
          'Este proyecto solo tiene configuración para Android.',
        );
    }
  }

  /// Configuración generada desde google-services.json (Android)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB6O3elzLScjR3DWeQZN94a-oaSZ-7oFuQ',
    appId: '1:1062245695442:android:8478a84e47f118437a520b',
    messagingSenderId: '1062245695442',
    projectId: 'usfq-nutrition-b42b5',
    storageBucket: 'usfq-nutrition-b42b5.firebasestorage.app',
  );
}
