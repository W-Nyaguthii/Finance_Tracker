import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    } else {
      throw UnsupportedError(
          'FirebaseOptions are not configured for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyBC2eKPWzdMFDI-h2xL9U731oYF_l-NhNU",
    authDomain: "finance-tracker-1a8d1.firebaseapp.com",
    projectId: "finance-tracker-1a8d1",
    storageBucket: "finance-tracker-1a8d1.firebasestorage.app",
    messagingSenderId: "214463772377",
    appId: "1:214463772377:web:2c96929c1f9c4cfa2670c8",
    measurementId: "YOUR_MEASUREMENT_ID", // Optional for analytics
  );
}
