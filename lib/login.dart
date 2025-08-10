// lib/pages/login_page.dart
import 'package:allobaay/navigation.dart';
import 'package:allobaay/navigation1.dart';
import 'package:allobaay/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
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
        height: double.infinity,
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
              child: Image.asset(
                'images/pregnanacyimage.png',
                width: MediaQuery.of(context).size.width * 0.7,
                opacity: AlwaysStoppedAnimation(0.3),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  // App Logo/Title
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Image.asset(
                          'images/pregnanacylogo.png',
                          width: 150,
                          height: 150,

                        ),
                      ),

                      SizedBox(height: 16),
                      Text(
                        'MommyCare',
                        style: GoogleFonts.pacifico(
                          fontSize: 36,
                          color: Color(0xFFE91E63),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Your Pregnancy Companion',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Color(0xFF4A4A4A),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),

                  // Login Form
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
                        Text(
                          'Welcome Back',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE91E63),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Sign in to continue your journey',
                          style: GoogleFonts.poppins(
                            color: Color(0xFF4A4A4A),
                          ),
                        ),
                        SizedBox(height: 24),

                        // Email Field
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined, color: Colors.pink),
                            labelText: 'Email',
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
                        // SizedBox(height: 8),
                        //
                        // // Remember Me & Forgot Password
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Row(
                        //       children: [
                        //         Checkbox(
                        //           value: true,
                        //           onChanged: (value) {},
                        //           activeColor: Colors.pink,
                        //         ),
                        //         Text(
                        //           'Remember me',
                        //           style: GoogleFonts.poppins(
                        //             fontSize: 12,
                        //             color: Colors.grey,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //     TextButton(
                        //       onPressed: () {},
                        //       child: Text(
                        //         'Forgot Password?',
                        //         style: GoogleFonts.poppins(
                        //           fontSize: 12,
                        //           color: Colors.pink,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(height: 16),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_emailController.text.isEmpty ||
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

                                if (existingUser.docs.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("User not found. Please sign up.")),
                                  );
                                  return;
                                }

                                UserCredential userCredential = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);

                                print("home");

                                navigateBasedOnUser(context);

                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => Navbar()), // Navigate to HomePage
                                // );
                              }
                              catch (e) {
                                print(
                                    'Error during login: $e'); // Print the full error message
                                if (e is FirebaseAuthException &&
                                    e.code == 'wrong-password') {
                                  String errorMessage = 'Password is wrong. Please try again.';
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(errorMessage),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFE91E63),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              'LOGIN',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        //
                        // // Divider
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Divider(
                        //         color: Colors.grey.withOpacity(0.5),
                        //       ),
                        //     ),
                        //     Padding(
                        //       padding: EdgeInsets.symmetric(horizontal: 8),
                        //       child: Text(
                        //         'or continue with',
                        //         style: GoogleFonts.poppins(
                        //           fontSize: 12,
                        //           color: Colors.grey,
                        //         ),
                        //       ),
                        //     ),
                        //     Expanded(
                        //       child: Divider(
                        //         color: Colors.grey.withOpacity(0.5),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 16),
                        //
                        // // Social Login
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     IconButton(
                        //       icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
                        //       onPressed: () {},
                        //     ),
                        //     IconButton(
                        //       icon: FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
                        //       onPressed: () {},
                        //     ),
                        //     IconButton(
                        //       icon: FaIcon(FontAwesomeIcons.apple, color: Colors.black),
                        //       onPressed: () {},
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.poppins(
                          color: Color(0xFF494949),
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SignupPage()),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.poppins(
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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