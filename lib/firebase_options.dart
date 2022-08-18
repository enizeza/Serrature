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
    apiKey: 'AIzaSyDgMO5DEIeBGVm63NkPAzmr2JQ4LfHJ7G4',
    appId: '1:295647266614:web:279dca6ae4beccdba81597',
    messagingSenderId: '295647266614',
    projectId: 'serrature-b7210',
    authDomain: 'serrature-b7210.firebaseapp.com',
    storageBucket: 'serrature-b7210.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDzkC6ZGeeAE4oChw5ZFjHv7Q-bubdMm-0',
    appId: '1:295647266614:android:93f6744c4d364898a81597',
    messagingSenderId: '295647266614',
    projectId: 'serrature-b7210',
    storageBucket: 'serrature-b7210.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDo72hmYmm_jyHgOI_2LPncjb3PHRk82_w',
    appId: '1:295647266614:ios:54790178144c3a71a81597',
    messagingSenderId: '295647266614',
    projectId: 'serrature-b7210',
    storageBucket: 'serrature-b7210.appspot.com',
    androidClientId: '295647266614-u8qpa4dapfq72ihfop1s2i69jn9vkomj.apps.googleusercontent.com',
    iosClientId: '295647266614-fcbl1obgjp33ouep0vid7oek4thrdpq6.apps.googleusercontent.com',
    iosBundleId: 'com.example.serrature',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDo72hmYmm_jyHgOI_2LPncjb3PHRk82_w',
    appId: '1:295647266614:ios:54790178144c3a71a81597',
    messagingSenderId: '295647266614',
    projectId: 'serrature-b7210',
    storageBucket: 'serrature-b7210.appspot.com',
    androidClientId: '295647266614-u8qpa4dapfq72ihfop1s2i69jn9vkomj.apps.googleusercontent.com',
    iosClientId: '295647266614-fcbl1obgjp33ouep0vid7oek4thrdpq6.apps.googleusercontent.com',
    iosBundleId: 'com.example.serrature',
  );
}