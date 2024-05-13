import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pantrychef/screens/home.dart';
import 'package:pantrychef/screens/login.dart';
import 'package:pantrychef/screens/splash1.dart';
import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
 options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pantry Chef',
      theme: ThemeData(

        useMaterial3: true,
      ),
      home: SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}


 