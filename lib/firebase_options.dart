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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBdsAvRbSHfK8ZgSwjoo_cxzb4yXi64Fx4',
    appId: '1:823427789530:web:3c99e6bb5e074792ab2be3',
    messagingSenderId: '823427789530',
    projectId: 'madanichat-ba132',
    authDomain: 'madanichat-ba132.firebaseapp.com',
    storageBucket: 'madanichat-ba132.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBAc_k1602j-_5Bfb6uwF2p494XgX-IKuU',
    appId: '1:823427789530:android:06c2512fe8fab133ab2be3',
    messagingSenderId: '823427789530',
    projectId: 'madanichat-ba132',
    storageBucket: 'madanichat-ba132.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAi8OgkqCoG9c1chA-ZI-FU7d7Q3gYSDBo',
    appId: '1:823427789530:ios:10f66423be51823cab2be3',
    messagingSenderId: '823427789530',
    projectId: 'madanichat-ba132',
    storageBucket: 'madanichat-ba132.appspot.com',
    iosBundleId: 'com.example.chatApp',
  );
}
