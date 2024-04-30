import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pantrychef/screens/favorites.dart';
import 'package:pantrychef/screens/home.dart';
import 'package:pantrychef/screens/login.dart';
import 'package:pantrychef/screens/profile.dart';

const Color primaryColor = Colors.redAccent; // Appetizing red
const Color secondaryColor = Colors.lightGreenAccent; // Fresh green
const Color accentColor = Colors.yellow; // Warm yellow

class CustomDrawer extends StatelessWidget {


  const CustomDrawer({
    Key? key,
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: Text(
              'PantryChef',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
             ListTile(
              onTap: () {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>Home()));

              },
            title: Text('Home'),
            leading: Icon(Icons.home, color: primaryColor),
         
          ),
          ListTile(
            onTap: () {
                                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>Favorites()));

            },
            title: Text('Favorites'),
            leading: Icon(Icons.favorite, color: primaryColor),
          ),
          ListTile(
            onTap: () {
                                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>AccountScreen()));

            },
            title: Text('Profile'),
            leading: Icon(Icons.person, color: primaryColor),
         
          ),
          Divider(), // Divider for visual separation
          ListTile(
            onTap: () async{
                  EasyLoading.show(status: "Logging out");

              await FirebaseAuth.instance.signOut();
                  final GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        EasyLoading.dismiss();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>Login()));

            },
            title: Text('Logout'),
            leading: Icon(Icons.logout, color: primaryColor),
     
          ),
        ],
      ),
    );
  }
}
