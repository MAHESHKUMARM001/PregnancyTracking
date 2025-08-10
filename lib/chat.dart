import 'package:allobaay/screens/patient_home.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF6F6),
      appBar: AppBar(
        title: Text(
          'Chat Support',
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
          children: [
            // Header Image
            Image.asset(
              'images/chart.png',
              height: 250,
              // width: 300,
              fit: BoxFit.fill,
            ),

            Column(
              children: [
                Text(
                  "Get Connected with doctors",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20,),
                Text(
                  "To get connected with a doctor, you can utilize various online platforms and tools like telemedicine apps or online doctor consultation services. ",
                  style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 16,
                    color: Colors.grey
                  ),
                  textAlign: TextAlign.justify,
                )
              ],
            ),
            SizedBox(height: 30),

            // Connect with Doctor Button
            _buildChatOption(
              context,
              icon: FontAwesomeIcons.userDoctor,
              title: 'Connect with Doctor',
              subtitle: 'Chat with certified pregnancy specialists',
              color: Color(0xFFE75480),
              image: 'images/doctor.png',
              onTap: () {
                // Navigate to doctor chat
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PatientHomeScreen()),
                );
              },
            ),
            SizedBox(height: 25),

            // Connect with Bot Button
            // _buildChatOption(
            //   context,
            //   icon: FontAwesomeIcons.robot,
            //   title: 'Connect with HealthBot',
            //   subtitle: 'Get instant answers to common questions',
            //   color: Color(0xFF6A1B9A),
            //   image: 'images/bot.png',
            //   onTap: () {
            //     // Navigate to bot chat
            //   },
            // ),
            SizedBox(height: 30),

            // Additional Help Section
            // Container(
            //   padding: EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: Color(0xFFFFE6EF),
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: Row(
            //     children: [
            //     Icon(Icons.help_outline, color: Color(0xFFE75480),),
            //     SizedBox(width: 12),
            //     Expanded(
            //       child: Text(
            //         'Need urgent help? Call our 24/7 pregnancy helpline',
            //         style: GoogleFonts.poppins(),
            //       ),
            //     ),
            //     IconButton(
            //       icon: Icon(Icons.phone, color: Colors.green),
            //       onPressed: () {
            //         // Launch phone call
            //       },
            //     ),
            //
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatOption(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Color color,
        required String image,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            // Image on Left
            Image.asset(
              image,
              width: 80,
              height: 80,
            ),
            SizedBox(width: 16),
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Color(0xFF1F1E1E),
                    ),
                  ),
                ],
              ),
            ),
            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}