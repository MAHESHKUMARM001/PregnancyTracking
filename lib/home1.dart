// lib/pages/home_page.dart
import 'package:allobaay/awarenesspost.dart';
import 'package:allobaay/doctorappointment.dart';
import 'package:allobaay/doctorreport.dart';
import 'package:allobaay/patientappointment.dart';
import 'package:allobaay/pregnancydate.dart';
import 'package:allobaay/report.dart';
import 'package:allobaay/screening.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({super.key});

  @override
  State<HomePage1> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF6F6),
      appBar: AppBar(
        title: Text(
          'Pregnancy Companion',
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFFFE6EF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Image.asset('images/pregnanacyimage.png', width: 80),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, Mom-to-be!',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE75480),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Track your pregnancy journey with us',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF4f4e4d),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Week progress
              Text(
                'Your Patients and post details this page',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // SizedBox(height: 8),
              // LinearProgressIndicator(
              //   value: 0.3,
              //   backgroundColor: Color(0xFFF5C6D8),
              //   valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE75480)),
              //   minHeight: 12,
              // ),
              // SizedBox(height: 8),
              // Text(
              //   '30% completed - 28 weeks to go!',
              //   style: GoogleFonts.poppins(
              //     fontSize: 12,
              //     color: Color(0xFF4f4e4d),
              //   ),
              // ),
              SizedBox(height: 24),

              // Features grid
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [

                  _buildFeatureButton(
                    icon: FontAwesomeIcons.newspaper,
                    title: 'Awareness Post',
                    color: Color(0xFFCE58E3),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AwarenessPostPage()),
                      );
                    },
                  ),
                  _buildFeatureButton(
                    icon: FontAwesomeIcons.userDoctor,
                    title: 'Appointment',
                    color: Color(0xFF864CEE),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DoctorAppointmentPage()),
                      );
                    },
                  ),

                  _buildFeatureButton(
                    icon: FontAwesomeIcons.fileLines,
                    title: 'Reports',
                    color: Color(0xFF3AC1FF),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DoctorReportPage()),
                      );
                    },
                  ),

                ],
              ),

              SizedBox(height: 24),

              // Daily tip
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Color(0xFFFFC107)),
                        SizedBox(width: 8),
                        Text(
                          'Daily Tip',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Stay hydrated! Drink at least 8-10 glasses of water daily to support your increased blood volume and amniotic fluid.',
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
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: FaIcon(icon, color: color, size: 24),
            ),
            SizedBox(height: 12),
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