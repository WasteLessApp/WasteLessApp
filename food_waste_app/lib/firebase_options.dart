// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDSMkMdTJMFbDnmr51VO3nk9sNEkboxohI',
    appId: '1:578749921356:web:cb9a8854ddd9c378e11ce9',
    messagingSenderId: '578749921356',
    projectId: 'food-waste-app-2022',
    authDomain: 'food-waste-app-2022.firebaseapp.com',
    storageBucket: 'food-waste-app-2022.appspot.com',
    measurementId: 'G-Z912PGXZTB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAwjZbsAXDmKdyvpJd4Wn6pQzvYYn5oU_g',
    appId: '1:578749921356:android:17e7245129167766e11ce9',
    messagingSenderId: '578749921356',
    projectId: 'food-waste-app-2022',
    storageBucket: 'food-waste-app-2022.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBUjZBA3QkB7vG7JhvhOrkbqQUh23I2vBo',
    appId: '1:578749921356:ios:d80672a4869d67c0e11ce9',
    messagingSenderId: '578749921356',
    projectId: 'food-waste-app-2022',
    storageBucket: 'food-waste-app-2022.appspot.com',
    iosClientId: '578749921356-7jkdv4mdlccmoa4gig3sb61rnbl4fe2b.apps.googleusercontent.com',
    iosBundleId: 'com.foodwasteapp.FoodWasteApp',
  );
}
