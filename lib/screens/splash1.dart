import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pantrychef/screens/splash2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const Color primaryColor = Colors.redAccent; // Appetizing red

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Delay for 2 seconds before navigating to the next screen
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => SecondSplashScreen(),
      ));
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          // Background image
          
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.shoppingBasket,
                    size: 80,
                    color: primaryColor,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  Text(
                    'PantryChef',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 20),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
