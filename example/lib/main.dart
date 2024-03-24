import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// import 'package:telematics_sdk_example/screens/title_screen.dart';
import 'package:telematics_sdk_example/screens/welcome_screen.dart';

import 'screens/welcome_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyAk9910ZhjWPYEzRZbfqiy7brmhVjN0_QU',
              appId: '1:1087866779795:android:8f81bce241d4c66a05b566',
              messagingSenderId: '1087866779795',
              projectId: 'telematics-sample-cd2af'))
      : await Firebase.initializeApp();
      
  //await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TelematicsSDK Example',
      home: WelcomeScreen(),
    );
  }
}
