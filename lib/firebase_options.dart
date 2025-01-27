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
    apiKey: 'AIzaSyCzgx_N7YNr19dFM5ERDIw-PyGvXi_RxbI',
    appId: '1:412225805390:web:f1acab39c922d55a98b71f',
    messagingSenderId: '412225805390',
    projectId: 'nekowaifu-37dbb',
    authDomain: 'nekowaifu-37dbb.firebaseapp.com',
    databaseURL: 'https://nekowaifu-37dbb-default-rtdb.firebaseio.com',
    storageBucket: 'nekowaifu-37dbb.appspot.com',
    measurementId: 'G-86FZ2C9F92',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDRiNWc0xP1h8i6ZnM4sbAhCbeoAkNBQPQ',
    appId: '1:412225805390:android:d7df7b6d592b88e398b71f',
    messagingSenderId: '412225805390',
    projectId: 'nekowaifu-37dbb',
    databaseURL: 'https://nekowaifu-37dbb-default-rtdb.firebaseio.com',
    storageBucket: 'nekowaifu-37dbb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBP7TCBPq7qUlk4t2yO-SVM9673fLm0MIU',
    appId: '1:412225805390:ios:285c8767610ff4e598b71f',
    messagingSenderId: '412225805390',
    projectId: 'nekowaifu-37dbb',
    databaseURL: 'https://nekowaifu-37dbb-default-rtdb.firebaseio.com',
    storageBucket: 'nekowaifu-37dbb.appspot.com',
    iosBundleId: 'com.nekowaifu.nekoWaifu',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBP7TCBPq7qUlk4t2yO-SVM9673fLm0MIU',
    appId: '1:412225805390:ios:3425d367664aaa5e98b71f',
    messagingSenderId: '412225805390',
    projectId: 'nekowaifu-37dbb',
    databaseURL: 'https://nekowaifu-37dbb-default-rtdb.firebaseio.com',
    storageBucket: 'nekowaifu-37dbb.appspot.com',
    iosBundleId: 'com.nekowaifu.nekoWaifu.RunnerTests',
  );
}
