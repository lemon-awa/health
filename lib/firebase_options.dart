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
    apiKey: 'AIzaSyABIZKDuNba0oTWnsB22jaWH_2HGaCnwKo',
    appId: '1:259687303472:web:3b5473d0d08fb23a01e0f5',
    messagingSenderId: '259687303472',
    projectId: 'keepingfit-ea291',
    authDomain: 'keepingfit-ea291.firebaseapp.com',
    storageBucket: 'keepingfit-ea291.appspot.com',
    measurementId: 'G-51WKB5E5MZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDveGZnBy-1CXxmEk9I8SSJDcwHxogg3ks',
    appId: '1:259687303472:android:ec4c13c1d724cb2b01e0f5',
    messagingSenderId: '259687303472',
    projectId: 'keepingfit-ea291',
    storageBucket: 'keepingfit-ea291.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA4J3uHgej2ZlvlhtubePSJG62ANK41ekE',
    appId: '1:259687303472:ios:636be771b15d14cb01e0f5',
    messagingSenderId: '259687303472',
    projectId: 'keepingfit-ea291',
    storageBucket: 'keepingfit-ea291.appspot.com',
    iosBundleId: 'com.VivianRMS.keepingFit',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA4J3uHgej2ZlvlhtubePSJG62ANK41ekE',
    appId: '1:259687303472:ios:e78837fe6885ddac01e0f5',
    messagingSenderId: '259687303472',
    projectId: 'keepingfit-ea291',
    storageBucket: 'keepingfit-ea291.appspot.com',
    iosBundleId: 'com.VivianRMS.keepingFit.RunnerTests',
  );
}
