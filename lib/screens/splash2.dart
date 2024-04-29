import 'package:flutter/material.dart';
import 'package:pantrychef/screens/login.dart';

const Color primaryColor = Colors.redAccent; // Appetizing red
const Color secondaryColor = Colors.lightGreenAccent; // Fresh green

class SecondSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to PantryChef!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'PantryChef helps you find and save your favorite recipes.\n\n'
                'To get started, use the search feature to find recipes based on your ingredients. '
                'You can also explore different categories of recipes and save your favorites for quick access later.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: Text('Get Started',style: TextStyle(
                  color: Colors.white
                ),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
