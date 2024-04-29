import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pantrychef/screens/home.dart';
import 'package:pantrychef/screens/register.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

const Color primaryColor = Colors.redAccent; // Appetizing red

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State  <Login> createState() => _LoginState();
}

class _LoginState extends State  <Login> {
  var email = TextEditingController();
  var pass = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void login()async {
  if (formKey.currentState!.validate()) {
    EasyLoading.show(status: "Logging in");
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.text,
      password: pass.text,
    ).then((value) {
      EasyLoading.dismiss();
      print(value);
      Navigator.push(context, MaterialPageRoute(builder: (_) => Home()));
    }).catchError((error) {
  EasyLoading.dismiss();
  print("Firebase Authentication Error: $error");
  if (error is FirebaseAuthException) {
    if (error.code == "invalid-email") {
       QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'The email address is badly formatted.',
          );
    } else if (error.code == "user-not-found" || error.code == "wrong-password") {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Invalid email or password.',
          );
    } else {
         QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'An error occurred: ${error.message}',
          );
      
    }
  }
});

  }
}


Future<void> signInWithGoogle() async {
  try {
    EasyLoading.show(status: 'Signing in with Google...');

    final GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();

    final GoogleSignInAccount? google = await googleSignIn.signIn();

    if (google != null) {
      final GoogleSignInAuthentication googleAuth = await google.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      EasyLoading.dismiss();
      Navigator.pushReplacement( // Use pushReplacement for cleaner navigation
        context,
        MaterialPageRoute(builder: (_) => Home()),
      );

      // Handle successful sign-in (optional)
      print('Signed in with Google UID: ${userCredential.user!.uid}');
    } else {
      EasyLoading.dismiss();
      // User canceled the sign-in process
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-in with Google canceled.'),
        ),
      );
    }
  } catch (error) {
    EasyLoading.dismiss();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error signing in with Google: $error'),
      ),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PantryChef',
          style: TextStyle(color: Colors.white), // White text for better contrast
        ),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // App logo with primary color background
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
                child: Center(
                  child: Text(
                    'Your Logo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text for better contrast
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor), // Use primary color for border
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: pass,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor), // Use primary color for border
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: login,
                child: Text('Login',style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // Use backgroundColor instead
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'or',
                style: TextStyle(fontSize: 18.0, color: Colors.black54), // Greyish text
              ),
              SizedBox(height: 20.0),
              OutlinedButton.icon(
                onPressed: () {
 signInWithGoogle();                },
                icon: Icon(Icons.account_circle, color: primaryColor), // Use primary color for icon
                label: Text(
                  'Sign in with Google',
                  style: TextStyle(color: Colors.black), // Black text for better contrast
                ),
              ),
              SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  // Navigate to the register screen
                  Navigator.push(context, MaterialPageRoute(builder: (_) => Register()));
                },
                child: Text(
                  'Don\'t have an account? Register here',
                  style: TextStyle(color: Colors.black54), // Greyish text
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


