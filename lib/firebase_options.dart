import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyBNZ65ch18SBMgIRSv7wR-6-kDEOMh5Ln8',
    appId: '1:575370405832:web:670e95d216e9f157ad82fd',
    messagingSenderId: '575370405832',
    projectId: 'golden-titab',
    authDomain: 'golden-titab.firebaseapp.com',
    storageBucket: 'golden-titab.firebasestorage.app',
    measurementId: 'G-X3XKLCEM5J',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCBOu-NnsGujtU_8hMY6LHjFe85wzNgXPc',
    appId: '1:575370405832:android:c03b7e5cc1044a69ad82fd',
    messagingSenderId: '575370405832',
    projectId: 'golden-titab',
    storageBucket: 'golden-titab.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCFd2SS7f2rJ-WaXVv1AE8QCrZqbIiuoI8',
    appId: '1:575370405832:ios:071ae9c3db64ffc7ad82fd',
    messagingSenderId: '575370405832',
    projectId: 'golden-titab',
    storageBucket: 'golden-titab.firebasestorage.app',
    iosBundleId: 'com.example.firstApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCFd2SS7f2rJ-WaXVv1AE8QCrZqbIiuoI8',
    appId: '1:575370405832:ios:071ae9c3db64ffc7ad82fd',
    messagingSenderId: '575370405832',
    projectId: 'golden-titab',
    storageBucket: 'golden-titab.firebasestorage.app',
    iosBundleId: 'com.example.firstApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBNZ65ch18SBMgIRSv7wR-6-kDEOMh5Ln8',
    appId: '1:575370405832:web:47f76f753d23bc1fad82fd',
    messagingSenderId: '575370405832',
    projectId: 'golden-titab',
    authDomain: 'golden-titab.firebaseapp.com',
    storageBucket: 'golden-titab.firebasestorage.app',
    measurementId: 'G-34JBNHGRBL',
  );
}
