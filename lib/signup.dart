// lib/pages/signup_page.dart
import 'package:allobaay/login.dart';
import 'package:allobaay/navigation.dart';
import 'package:allobaay/navigation1.dart';
import 'package:allobaay/privacy.dart';
import 'package:allobaay/terms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void navigateBasedOnUser(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    if (user != null && user.email == "doctor001@gmail.com") {
      // Admin email detected, navigate to Navbar1
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainNavigation1()),
      );
    } else {
      // Normal user, navigate to Navbar
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainNavigation()),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF5F7),
              Color(0xFFFFEBEE),
              Color(0xFFFFCDD2).withOpacity(0.8),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'images/pregnanacyimage.png',
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                  // Back Button
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Color(0xFFE91E63)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  // App Logo/Title
                  Column(
                    children: [
                      Image.asset(
                        'images/pregnanacylogo.png',
                        width: 80,
                        height: 80,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Create Account',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          color: Color(0xFFE91E63),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Begin your pregnancy journey with us',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Color(0xFF494949),
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  // Signup Form
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Name Field
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline, color: Colors.pink),
                            labelText: 'Full Name',
                            hintText: 'Enter your full name',
                            labelStyle: GoogleFonts.poppins(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.pink),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Email Field
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined, color: Colors.pink),
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            labelStyle: GoogleFonts.poppins(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.pink),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Password Field
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline, color: Colors.pink),
                            labelText: 'Password',
                            hintText: 'Create a password',
                            labelStyle: GoogleFonts.poppins(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.pink),
                            ),
                            // suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Phone Field
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone_android, color: Colors.pink),
                            labelText: 'Phone Number',
                            hintText: 'Enter your mobile number',
                            labelStyle: GoogleFonts.poppins(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.pink),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Address Field
                        TextField(
                          controller: _addressController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.home_outlined, color: Colors.pink),
                            labelText: 'Address',
                            hintText: 'Enter your residential address',
                            labelStyle: GoogleFonts.poppins(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.pink),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        // Terms & Conditions
                        Row(
                          children: [
                            Checkbox(
                              value: true,
                              onChanged: (value) {},
                              activeColor: Colors.pink,
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  children: [
                                    TextSpan(text: 'I agree to the ', style: TextStyle(color: Color(0xFF494949))),
                                    TextSpan(

                                      text: 'Terms & Conditions',
                                      style: TextStyle(
                                        color: Colors.pink,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // Navigate to Terms & Conditions page
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TermsConditionsPage(),
                                            ),
                                          );
                                        },

                                    ),
                                    TextSpan(text: ' and ', style: TextStyle(color: Color(0xFF494949))),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: TextStyle(
                                        color: Colors.pink,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // Navigate to Terms & Conditions page
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PrivacyPolicyPage(),
                                            ),
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Sign Up Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {

                              if (_nameController.text.isEmpty ||
                                  _emailController.text.isEmpty ||
                                  _phoneController.text.isEmpty ||
                                  _addressController.text.isEmpty ||
                                  _passwordController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("All fields are required!")),
                                );
                                return;
                              }

                              try {
                                // Check if the user already exists
                                var existingUser = await _firestore
                                    .collection("users")
                                    .where("email", isEqualTo: _emailController.text)
                                    .get();

                                if (existingUser.docs.isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("User already exists! Please log in.")),
                                  );
                                  return;
                                }

                                // Register new user
                                UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );

                                // Store user details in Firestore
                                await _firestore.collection("users").doc(userCredential.user!.uid).set({
                                  "createdAt": FieldValue.serverTimestamp(),
                                  "name": _nameController.text,
                                  "email": _emailController.text,
                                  "phone": _phoneController.text,
                                  "address": _addressController.text,
                                  "uid": userCredential.user!.uid,
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Signup Successful!")),
                                );

                                // Navigator.pop(context); // Navigate back to login page

                                navigateBasedOnUser(context);

                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => Navbar()), // Navigate to HomePage
                                // );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error: ${e.toString()}")),
                                );
                              }
                              // Handle signup logic

                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFE91E63),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              'SIGN UP',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Already have account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: GoogleFonts.poppins(
                                color: Color(0xFF494949),
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginPage()),
                                );
                              },
                              child: Text(
                                'Login',
                                style: GoogleFonts.poppins(
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}