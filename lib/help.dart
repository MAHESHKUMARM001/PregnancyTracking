import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HelpSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFE75480)),
        centerTitle: true,
        title: Text(
          'Help & Support',
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
            _buildSupportCard(
              icon: FontAwesomeIcons.questionCircle,
              title: 'FAQs',
              content:
              'Find answers to commonly asked questions about pregnancy tracking, app features, and user account settings.',
            ),
            SizedBox(height: 20),
            _buildSupportCard(
              icon: FontAwesomeIcons.envelopeOpenText,
              title: 'Contact Us',
              content:
              'Need help? Reach out to us anytime at support@preggyapp.com. We respond within 24 hours!',
            ),
            SizedBox(height: 20),
            _buildSupportCard(
              icon: FontAwesomeIcons.tools,
              title: 'Technical Issues',
              content:
              'Having trouble using the app? Report bugs or app crashes so we can fix them quickly.',
            ),
            SizedBox(height: 20),
            _buildSupportCard(
              icon: FontAwesomeIcons.comments,
              title: 'Feedback & Suggestions',
              content:
              'Your voice matters! Let us know what features you love or improvements you’d like to see.',
            ),
            SizedBox(height: 30),
            Text(
              'We’re here for you, every step of your journey. 💕',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSupportCard({
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
            color: Colors.grey.withOpacity(0.07),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFFE75480),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  content,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
