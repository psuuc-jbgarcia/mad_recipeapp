import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pantrychef/components/drawer.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    const Color primaryColor = Color(0xFFD32F2F); // Dark Red
    const Color accentColor = Color(0xFFFFAB91); // Light Orange
    const Color backgroundColor = Color(0xFFFBE9E7); // Light Peach

    // Function to handle uploading image to Firestore
    Future<void> uploadImage() async {
      // Implement your image uploading logic here
    }

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text(
          "My Account",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('account').doc(userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data?.data();
            if (data == null || data.isEmpty) {
              return Center(child: Text('No data found'));
            } else {
              final dietaryPreference = data['dietary_preference'] ?? 'Not found';
              final fname = data['fname'] ?? 'Not found';

              return ListView(
                padding: EdgeInsets.all(16.0),
                children: [
               ClipOval(
    child: Image.asset(
      'assets/images/profile.png',
      fit: BoxFit.cover,
    )),
                  
                  SizedBox(height: 20),
                  Card(
                    elevation: 3,
                    color: backgroundColor,
                    child: ListTile(
                      title: Text(
                        'Dietary Preference',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      subtitle: Text(
                        dietaryPreference,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    elevation: 3,
                    color: backgroundColor,
                    child: ListTile(
                      title: Text(
                        'First Name',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      subtitle: Text(
                        fname,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                
                ],
              );
            }
          }
        },
      ),
    );
  }
}
