import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pantrychef/screens/home.dart';
import 'package:pantrychef/screens/login.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

const Color primaryColor = Colors.redAccent; // Appetizing red
const Color secondaryColor = Colors.lightGreenAccent; // Fresh green
const Color accentColor = Colors.yellow; // Warm yellow



class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<StatefulWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  var googleName=TextEditingController();
  String? dietaryPreference;

  bool obscureText = true;

  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void register() async {
  if (formKey.currentState!.validate()) {
   
      try {
        EasyLoading.show(status: "Registering");
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text,
                password: passwordController.text);
        String userID = userCredential.user!.uid;
        await FirebaseFirestore.instance.collection('account').doc(userID).set({
          'fname': firstNameController.text,
          'dietary_preference': dietaryPreference,
        });
        EasyLoading.dismiss();
        Navigator.push(context, MaterialPageRoute(builder: (_) => Login()));
      } on FirebaseAuthException catch (e) {
        EasyLoading.dismiss();
        print(e);
        if (e.code == 'weak-password') {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'The password provided is too weak.',
          );
        } else if (e.code == 'email-already-in-use') {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'The account already exists for that email.',
          );
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'An error occurred. Please try again later.',
          );
        }
        // Stop execution
        return;
      }
    
  }
}

Future<void> signUpWithGoogle(BuildContext context) async {
  try {
    EasyLoading.show(status: 'Signing up with Google...');

    final GoogleSignIn googleSignIn = GoogleSignIn();
            await googleSignIn.signOut();

    final GoogleSignInAccount? google = await googleSignIn.signIn();

    if (google != null) {
      final GoogleSignInAuthentication googleAuth = await google.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Check if the Google account's email is already registered
      final email = FirebaseAuth.instance.currentUser?.email ?? google.email;
      final userExists = await FirebaseFirestore.instance.collection('account')
          .where('email', isEqualTo: email)
          .get()
          .then((value) => value.docs.isNotEmpty);

      if (userExists) {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('This Google account is already registered. Please sign in.'),
          ),
        );
        return;
      }

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Now, ask the user to provide additional information
      String? name = await showNameInputDialog(context);
      String? dietaryPreference = await showDietaryPreferenceDialog(context);

      // Store additional user data in Firestore
      await FirebaseFirestore.instance.collection('account').doc(userCredential.user!.uid).set({
        'email': email,
        'fname': name,
        'dietary_preference': dietaryPreference,
      });

      EasyLoading.dismiss();
      Navigator.pushReplacement( // Navigate to the home screen
        context,
        MaterialPageRoute(builder: (_) => Home()),
      );

      // Handle successful sign-up (optional)
      print('Signed up with Google UID: ${userCredential.user!.uid}');
    } else {
      EasyLoading.dismiss();
      // User canceled the sign-up process
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-up with Google canceled.'),
        ),
      );
    }
  } catch (error) {
    EasyLoading.dismiss();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error signing up with Google: $error'),
      ),
    );
  }
}



Future<String?> showNameInputDialog(BuildContext context) async {
        EasyLoading.dismiss();

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter your name'),
        content: TextField(
          controller: googleName,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Name',
          ),
          onChanged: (value) {
            // Handle text changes...
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Get the name and close the dialog
              Navigator.pop(context, googleName.text);
            },
            child: Text('Submit'),
          ),
        ],
      );
    },
  );
}

Future<String?> showDietaryPreferenceDialog(BuildContext context) async {
  String selectedValue = 'Vegan'; // Default value

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Select your dietary preference'),
            content: DropdownButton<String>(
              value: selectedValue,
              items: ['Vegan', 'Vegetarian', 'Meat Lover', 'Other']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    selectedValue = value;
                  });
                }
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Close the dialog and return the selected value
                  Navigator.pop(context, selectedValue);
                },
                child: Text('Submit'),
              ),
            ],
          );
        },
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        title: Text("Join us", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email should not be empty';
                  }
                  if (!EmailValidator.validate(value)) {
                    return 'Invalid email format';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: passwordController,
                obscureText: obscureText,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off,
                      color: primaryColor,
                    ),
                    onPressed: togglePasswordVisibility,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters long.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: obscureText,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off,
                      color: primaryColor,
                    ),
                    onPressed: togglePasswordVisibility,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please re-enter your password';
                  }
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'First name should not be empty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Dietary Preference',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                ),
                value: dietaryPreference,
                items: ['Vegan', 'Vegetarian', 'Meat Lover', 'Other']
                    .map            ((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    dietaryPreference = value;
                    print(dietaryPreference);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your dietary preference';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: register,
                child: Text('Register',style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                ),
              ),
              SizedBox(height: 20.0),
              OutlinedButton.icon(
                onPressed: () {
 signUpWithGoogle(context);                },
                icon: Icon(
                  Icons.account_circle,
                  color: primaryColor,
                ),
                label: Text(
                  'Sign up with Google',
                  style: TextStyle(color: primaryColor),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryColor),
                ),
              ),
              SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Already have an account? Sign in',style: TextStyle(color: Colors.black54),
                 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


