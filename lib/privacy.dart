import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFE75480)),
        centerTitle: true,
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.poppins(
            color: Color(0xFFE75480),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildCard(
              icon: FontAwesomeIcons.database,
              title: 'What We Collect',
              content:
              'We collect basic information such as name, email, due date, and health preferences to personalize your pregnancy journey.',
            ),
            SizedBox(height: 20),
            _buildCard(
              icon: FontAwesomeIcons.lock,
              title: 'How We Store It',
              content:
              'Your data is encrypted and stored securely. We use industry-standard protection methods to prevent unauthorized access.',
            ),
            SizedBox(height: 20),
            _buildCard(
              icon: FontAwesomeIcons.userSecret,
              title: 'What We Share',
              content:
              'We do not sell or share your data with third-party marketers. Data may only be shared with trusted healthcare tools if you give permission.',
            ),
            SizedBox(height: 20),
            _buildCard(
              icon: FontAwesomeIcons.userShield,
              title: 'Your Rights',
              content:
              'You can view, update, or delete your information anytime. We believe in full transparency and user control.',
            ),
            SizedBox(height: 20),
            _buildCard(
              icon: FontAwesomeIcons.sync,
              title: 'Policy Updates',
              content:
              'Our privacy policy may be updated periodically. Significant changes will be communicated clearly in the app.',
            ),
            SizedBox(height: 30),
            Text(
              'Your privacy matters. Thank you for trusting us with your journey to motherhood. 💗',
              style: GoogleFonts.poppins(
                fontStyle: FontStyle.italic,
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFFFFE6EF),
                child: FaIcon(
                  icon,
                  color: Color(0xFFE75480),
                  size: 18,
                ),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFFE75480),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
