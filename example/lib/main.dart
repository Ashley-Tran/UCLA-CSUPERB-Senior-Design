import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// import 'package:telematics_sdk_example/screens/title_screen.dart';
import 'package:telematics_sdk_example/screens/welcome_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
