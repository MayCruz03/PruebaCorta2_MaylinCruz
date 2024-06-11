// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCsGtq2N58oBvRUT1c86rZIHt3O0scypr0',
    appId: '1:652473045672:web:0b3e0a45afd75b2322689d',
    messagingSenderId: '652473045672',
    projectId: 'pruebacorta2-maylincruz',
    authDomain: 'pruebacorta2-maylincruz.firebaseapp.com',
    storageBucket: 'pruebacorta2-maylincruz.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDzyB8G3bDohHqp_gPQJaHlV50h248mv4w',
    appId: '1:652473045672:android:76edb18e5e8aec9b22689d',
    messagingSenderId: '652473045672',
    projectId: 'pruebacorta2-maylincruz',
    storageBucket: 'pruebacorta2-maylincruz.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA7iIBpz6Y2z-fn3SKIAr1z6wEyeCvioNk',
    appId: '1:652473045672:ios:d027318237acec0022689d',
    messagingSenderId: '652473045672',
    projectId: 'pruebacorta2-maylincruz',
    storageBucket: 'pruebacorta2-maylincruz.appspot.com',
    iosBundleId: 'com.example.pruebaMaylincruz',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA7iIBpz6Y2z-fn3SKIAr1z6wEyeCvioNk',
    appId: '1:652473045672:ios:d027318237acec0022689d',
    messagingSenderId: '652473045672',
    projectId: 'pruebacorta2-maylincruz',
    storageBucket: 'pruebacorta2-maylincruz.appspot.com',
    iosBundleId: 'com.example.pruebaMaylincruz',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCsGtq2N58oBvRUT1c86rZIHt3O0scypr0',
    appId: '1:652473045672:web:77cbbfed78609eae22689d',
    messagingSenderId: '652473045672',
    projectId: 'pruebacorta2-maylincruz',
    authDomain: 'pruebacorta2-maylincruz.firebaseapp.com',
    storageBucket: 'pruebacorta2-maylincruz.appspot.com',
  );
}
