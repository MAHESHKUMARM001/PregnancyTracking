// lib/pages/home_page.dart
import 'package:allobaay/awarenesspost.dart';
import 'package:allobaay/babycare.dart';
import 'package:allobaay/babydob.dart';
import 'package:allobaay/patientappointment.dart';
import 'package:allobaay/pregnancy.dart';
import 'package:allobaay/pregnancydate.dart';
import 'package:allobaay/report.dart';
import 'package:allobaay/screening.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'localization.dart'; // Import localization

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _checkIfUserExistsInChildCollection() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Fetch the document for the current user
      final childCollection = FirebaseFirestore.instance.collection('child');
      final querySnapshot = await childCollection.where('user_id', isEqualTo: user.uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BabyCarePage()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BabyDOBPage()),
        );
      }
    } // Return false if the user is not authenticated
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!; // Access localizations

    return Scaffold(
      backgroundColor: const Color(0xFFFEF6F6),
      appBar: AppBar(
        title: Text(
          localizations.translate('app_title'), // Translated app title
          style: GoogleFonts.poppins(
            color: const Color(0xFFE75480),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFE75480)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE6EF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Image.asset('images/pregnanacyimage.png', width: 80),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.translate('welcome_message'), // Translated
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFE75480),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            localizations.translate('track_journey'), // Translated
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF4f4e4d),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Week progress
              Text(
                localizations.translate('track_pregnancy'), // Translated
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // LinearProgressIndicator(
              //   value: 0.3,
              //   backgroundColor: Color(0xFFF5C6D8),
              //   valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE75480)),
              //   minHeight: 12,
              // ),
              const SizedBox(height: 8),
              // Text(
              //   localizations.translate('progress_text'), // Uncomment and translate if needed
              //   style: GoogleFonts.poppins(
              //     fontSize: 12,
              //     color: Color(0xFF4f4e4d),
              //   ),
              // ),
              const SizedBox(height: 24),

              // Features grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildFeatureButton(
                    icon: FontAwesomeIcons.calendar,
                    title: localizations.translate('pregnancy_date'), // Translated
                    color: const Color(0xFFFF86B0),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PregnancyDatePage()),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    icon: FontAwesomeIcons.newspaper,
                    title: localizations.translate('awareness_post'), // Translated
                    color: const Color(0xFFCE58E3),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AwarenessPostPage()),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    icon: FontAwesomeIcons.userDoctor,
                    title: localizations.translate('appointment'), // Translated
                    color: const Color(0xFF864CEE),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PatientAppointmentsPage()),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    icon: FontAwesomeIcons.microscope,
                    title: localizations.translate('screening'), // Translated
                    color: const Color(0xFF6477E1),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HealthMonitoringScreen()),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    icon: FontAwesomeIcons.fileLines,
                    title: localizations.translate('reports'), // Translated
                    color: const Color(0xFF3AC1FF),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PatientReportsPage()),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    icon: FontAwesomeIcons.baby,
                    title: localizations.translate('baby_growth'), // Translated
                    color: const Color(0xFF1ABBAC),
                    onTap: () {
                      _checkIfUserExistsInChildCollection();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Daily tip
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb_outline, color: Color(0xFFFFC107)),
                        const SizedBox(width: 8),
                        Text(
                          localizations.translate('daily_tip'), // Translated
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localizations.translate('daily_tip_text'), // Translated
                      style: GoogleFonts.poppins(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: FaIcon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}