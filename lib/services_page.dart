import 'package:allobaay/appointment.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ServicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFEF6F6),
        appBar: AppBar(
          title: Text(
            'Services',
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
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Header Section
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFE6EF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'images/pregnanacyimage.png',
                        width: 80,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Professional Care',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE75480),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Get expert guidance for you and your baby',
                              style: GoogleFonts.poppins(
                                color: Color(0xFF212020),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Image.asset(
                  'images/service.png',
                  width: 90,
                ),
                SizedBox(height: 20),

                Column(
                  children: [
                    Text(
                      "As a companion in your pregnancy\nWe help you with the following",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                SizedBox(height: 50),

                // Main Service Buttons
                Column(
                  children: [
                    // Book Appointment Button
                    _buildServiceButton(
                      context,
                      icon: FontAwesomeIcons.calendarCheck,
                      title: 'Book Appointment',
                      subtitle: 'Schedule with your doctor',
                      color: Color(0xFFE75480),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BookAppointmentPage()),
                        );

                        // Navigate to appointment booking
                      },
                    ),
                    SizedBox(height: 20),

                    // Helpline Button
                    _buildServiceButton(
                      context,
                      icon: FontAwesomeIcons.phoneAlt,
                      title: '24/7 Helpline',
                      subtitle: 'Immediate medical assistance',
                      color: Color(0xFF6A1B9A),
                      onTap: () {
                        _showHelplineDialog(context);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        )
    );
  }

  // Function to show helpline dialog
  void _showHelplineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Emergency Helpline',
            style: GoogleFonts.poppins(
              color: Color(0xFFE75480),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.emergency,
                color: Colors.red,
                size: 50,
              ),
              SizedBox(height: 20),
              Text(
                'Call our 24/7 pregnancy helpline for immediate assistance',
                style: GoogleFonts.poppins(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.phone, color: Colors.green, size: 40),
                    onPressed: () async {
                      const phoneNumber = 'tel:+919360295163'; // Replace with your helpline number
                      final Uri phoneUri = Uri.parse("tel:$phoneNumber");

                      if (!await launchUrl(phoneUri)) {
                        // await launchUrl(Uri.parse(phoneNumber));
                        SnackBar(content: Text('Could not launch phone app'));
                      }
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 20),
                  Text(
                    '123-456-7890', // Replace with your helpline number
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'Close',
                style: GoogleFonts.poppins(
                  color: Color(0xFFE75480),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildServiceButton(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Color color,
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
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: FaIcon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            SizedBox(width: 16),
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
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
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