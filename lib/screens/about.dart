import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pantrychef/components/drawer.dart';

class About extends StatelessWidget {
  final Color primaryColor = Colors.redAccent; // Appetizing red
  final Color secondaryColor = Colors.lightGreenAccent; // Fresh green
  final Color accentColor = Colors.yellow; // Warm yellow

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "About Us",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About Us",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Pantry Chef is your ultimate cooking companion, providing you with delicious recipes, helpful kitchen tips, and much more!",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Contact Us",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    leading: Icon(Icons.email, color: primaryColor),
                    title: Text("info@pantrychef.com",
                        style: TextStyle(fontSize: 16)),
                    onTap: () {
                      // Handle the action to contact via email
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.phone, color: primaryColor),
                    title: Text("+1234567890", style: TextStyle(fontSize: 16)),
                    onTap: () {
                      // Handle the action to contact via phone
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Follow Us",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.facebook,
                            color: secondaryColor),
                        onPressed: () {
                          // Handle the action to go to Facebook
                        },
                      ),
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.twitter,
                            color: secondaryColor),
                        onPressed: () {
                          // Handle the action to go to Twitter
                        },
                      ),
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.instagram,
                            color: secondaryColor),
                        onPressed: () {
                          // Handle the action to go to Instagram
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Follow Jerico Garcia for more updates:",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About the Developer",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Jerico B. Garcia",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Passionate Flutter developer with a keen interest in creating beautiful and user-friendly applications.",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Contact the developer:",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      // Handle the action to contact the developer via email
                    },
                    child: Text(
                      "Email: garciajerico217@.com",
                      style: TextStyle(
                          fontSize: 16,
                          color: primaryColor,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      // Handle the action to contact the developer via phone
                    },
                    child: Text(
                      "Phone: +63519071316",
                      style: TextStyle(
                          fontSize: 16,
                          color: primaryColor,
                          decoration: TextDecoration.underline),
                    ),
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
