// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDxXIWIdxoD6eFwwYi_dy3wliwsjaLI5ng',
    appId: '1:158458873507:web:2f5381abc429c6266fe116',
    messagingSenderId: '158458873507',
    projectId: 'kutuphane-ad3dd',
    authDomain: 'kutuphane-ad3dd.firebaseapp.com',
    storageBucket: 'kutuphane-ad3dd.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC_9iSXt49i7EgnryRJru-ehMnyPsnaeQs',
    appId: '1:158458873507:android:684de641881f41c66fe116',
    messagingSenderId: '158458873507',
    projectId: 'kutuphane-ad3dd',
    storageBucket: 'kutuphane-ad3dd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyArxlkJo1OLKLTrALxhMBM9bwIFjugnK-U',
    appId: '1:158458873507:ios:66bdac7d1128f3386fe116',
    messagingSenderId: '158458873507',
    projectId: 'kutuphane-ad3dd',
    storageBucket: 'kutuphane-ad3dd.appspot.com',
    iosBundleId: 'com.example.firebaseKurulu',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyArxlkJo1OLKLTrALxhMBM9bwIFjugnK-U',
    appId: '1:158458873507:ios:825d4ac5d696785c6fe116',
    messagingSenderId: '158458873507',
    projectId: 'kutuphane-ad3dd',
    storageBucket: 'kutuphane-ad3dd.appspot.com',
    iosBundleId: 'com.example.firebaseKurulu.RunnerTests',
  );
}