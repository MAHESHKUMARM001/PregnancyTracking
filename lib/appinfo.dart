import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF4F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFFE75480)),
        title: Text(
          'About This App',
          style: GoogleFonts.poppins(
            color: Color(0xFFE75480),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // App banner image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/pregnanacylogo.png"), // replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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
                  Text(
                    'Welcome to PreggyCare 🌸',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE75480),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'PreggyCare is your trusted companion throughout your pregnancy journey. Track baby development, get expert advice, and stay informed with weekly insights tailored just for you.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(),

                  _buildFeatureTile(
                    icon: FontAwesomeIcons.baby,
                    title: 'Baby Growth Tracker',
                    description: 'Monitor your baby’s progress with weekly growth charts and development milestones.',
                  ),
                  _buildFeatureTile(
                    icon: FontAwesomeIcons.notesMedical,
                    title: 'Health Tips & Alerts',
                    description: 'Get personalized tips, nutrition advice, and doctor appointment reminders.',
                  ),
                  _buildFeatureTile(
                    icon: FontAwesomeIcons.bookOpen,
                    title: 'Pregnancy Journal',
                    description: 'Write your beautiful journey, moods, and thoughts in a secure journal.',
                  ),
                  _buildFeatureTile(
                    icon: FontAwesomeIcons.headset,
                    title: '24/7 Support',
                    description: 'Contact experts or chat with our support team for any pregnancy-related questions.',
                  ),

                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      'Version 1.0.0 • Made with ❤️ for moms',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FaIcon(icon, color: Color(0xFFE75480), size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE75480),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
