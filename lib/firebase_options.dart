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
    apiKey: 'AIzaSyD9S28is5fYHo5vmg9BsWPsW_uHprvz-os',
    appId: '1:615752753862:web:f7764da585e80a4447edc7',
    messagingSenderId: '615752753862',
    projectId: 'hotel-finder-apk',
    authDomain: 'hotel-finder-apk.firebaseapp.com',
    storageBucket: 'hotel-finder-apk.appspot.com',
    measurementId: 'G-FY7XLM8V4R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDBQmilYtaas1SWluzNiB7I8TEkalKnUCI',
    appId: '1:615752753862:android:9064ef1c2d11501247edc7',
    messagingSenderId: '615752753862',
    projectId: 'hotel-finder-apk',
    storageBucket: 'hotel-finder-apk.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCe0k13Iz9lcu_viLDlBqBNS6Sjj7FvbCY',
    appId: '1:615752753862:ios:0d9230a78469b18c47edc7',
    messagingSenderId: '615752753862',
    projectId: 'hotel-finder-apk',
    storageBucket: 'hotel-finder-apk.appspot.com',
    androidClientId: '615752753862-jp9dtdqurlibk9rf23ll83e8o4qgdlmc.apps.googleusercontent.com',
    iosClientId: '615752753862-9rssdfjikubpn812bcpdvhtnlcufjs92.apps.googleusercontent.com',
    iosBundleId: 'com.sandeidevlab.hotelFinder',
  );
}
