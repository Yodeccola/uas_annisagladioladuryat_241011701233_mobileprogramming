import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web; // Diarahkan ke konfigurasi web jika dijalankan di Chrome
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android; // Diarahkan ke konfigurasi android jika dijalankan di HP/Emulator
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Konfigurasi untuk Web (Chrome)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDwlB-bq22KB1uNJGOkgcEVSq14C3uIb1E',
    authDomain: 'uas-annisagladiola-mobile.firebaseapp.com',
    projectId: 'uas-annisagladiola-mobile',
    storageBucket: 'uas-annisagladiola-mobile.firebasestorage.app',
    messagingSenderId: '570477631956',
    appId: '1:570477631956:web:f7b41b782a8da640129e41',
  );

  // Konfigurasi untuk Android (Disamakan kuncinya agar tidak error saat dipasang ke perangkat Android)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDwlB-bq22KB1uNJGOkgcEVSq14C3uIb1E',
    authDomain: 'uas-annisagladiola-mobile.firebaseapp.com',
    projectId: 'uas-annisagladiola-mobile',
    storageBucket: 'uas-annisagladiola-mobile.firebasestorage.app',
    messagingSenderId: '570477631956',
    appId: '1:570477631956:web:f7b41b782a8da640129e41',
  );
}