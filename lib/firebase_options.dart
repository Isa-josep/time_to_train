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
    apiKey: 'AIzaSyA6rM3smkV6fixgjntAaH4XHdw4R93b5Kg',
    appId: '1:261798415275:web:e192449fe5c25ba2cb60ee',
    messagingSenderId: '261798415275',
    projectId: 'time-to-train-596c8',
    authDomain: 'time-to-train-596c8.firebaseapp.com',
    storageBucket: 'time-to-train-596c8.appspot.com',
    measurementId: 'G-D1BBEV0TF3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBIxY4cAQqzfUJrY12rB2QfLzU5-yIil-s',
    appId: '1:261798415275:android:b5a4f36325959c40cb60ee',
    messagingSenderId: '261798415275',
    projectId: 'time-to-train-596c8',
    storageBucket: 'time-to-train-596c8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBTjeMhBUSYsAQmQkCNVJFnTalThI_kbTw',
    appId: '1:261798415275:ios:f8ebf0718d2fa060cb60ee',
    messagingSenderId: '261798415275',
    projectId: 'time-to-train-596c8',
    storageBucket: 'time-to-train-596c8.appspot.com',
    iosBundleId: 'com.example.timeToTrain',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBTjeMhBUSYsAQmQkCNVJFnTalThI_kbTw',
    appId: '1:261798415275:ios:4e009e5a6b53b303cb60ee',
    messagingSenderId: '261798415275',
    projectId: 'time-to-train-596c8',
    storageBucket: 'time-to-train-596c8.appspot.com',
    iosBundleId: 'com.example.timeToTrain.RunnerTests',
  );
}
