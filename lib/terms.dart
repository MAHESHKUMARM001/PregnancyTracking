import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF6F6),
      appBar: AppBar(
        title: Text(
          'Terms & Conditions',
          style: GoogleFonts.poppins(
            color: Color(0xFFE75480),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFE75480)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Icon
            Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFE6EF),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      FontAwesomeIcons.fileContract,
                      size: 40,
                      color: Color(0xFFE75480),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'MommyCare Terms of Service',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE75480),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Last updated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Terms Content
            _buildTermSection(
              icon: FontAwesomeIcons.handshake,
              title: 'Acceptance of Terms',
              content:
              'By using the MommyCare pregnancy monitoring app, you agree to be bound by these Terms and Conditions. If you do not agree with any part of these terms, you must not use our services.',
            ),
            SizedBox(height: 20),

            _buildTermSection(
              icon: FontAwesomeIcons.userShield,
              title: 'Privacy & Data Protection',
              content:
              'We collect pregnancy-related health data to provide personalized care recommendations. All data is encrypted and stored securely. You may request deletion of your data at any time by contacting our support team.',
            ),
            SizedBox(height: 20),

            _buildTermSection(
              icon: FontAwesomeIcons.baby,
              title: 'Medical Disclaimer',
              content:
              'The information provided by MommyCare is for general educational purposes only and is not a substitute for professional medical advice. Always consult your healthcare provider regarding your pregnancy.',
            ),
            SizedBox(height: 20),

            _buildTermSection(
              icon: FontAwesomeIcons.mobileScreen,
              title: 'App Usage',
              content:
              'You agree to use this app only for lawful purposes related to pregnancy monitoring. Any misuse of the app features may result in termination of your account.',
            ),
            SizedBox(height: 20),

            _buildTermSection(
              icon: FontAwesomeIcons.exclamationTriangle,
              title: 'Limitation of Liability',
              content:
              'MommyCare shall not be liable for any indirect, incidental, or consequential damages arising from the use of this app, including but not limited to errors in tracking or recommendations.',
            ),
            SizedBox(height: 20),

            _buildTermSection(
              icon: FontAwesomeIcons.pencilAlt,
              title: 'Changes to Terms',
              content:
              'We may modify these terms at any time. Continued use of the app after changes constitutes acceptance of the new terms. We will notify you of significant changes.',
            ),
            SizedBox(height: 30),

            // Acceptance Checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: true,
                  onChanged: (value) {},
                  activeColor: Color(0xFFE75480),
                ),
                Expanded(
                  child: Text(
                    'I have read and agree to the Terms and Conditions of MommyCare Pregnancy Monitoring App',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Back Button
            Center(
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE75480),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'I Understand',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(
                icon,
                color: Color(0xFFE75480),
                size: 20,
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            content,
            style: GoogleFonts.poppins(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}