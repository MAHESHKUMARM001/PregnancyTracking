import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class DoctorBenefitsPage extends StatefulWidget {
  const DoctorBenefitsPage({super.key});

  @override
  State<DoctorBenefitsPage> createState() => _DoctorBenefitsPageState();
}

class _DoctorBenefitsPageState extends State<DoctorBenefitsPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF6F6),
      appBar: AppBar(
        title: Text(
          'Patients Benefits',
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
              'images/doctoradvice.png',
              height: 180,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),

            // Main Benefits Section
            Text(
              'Why Connect With Our Doctors?',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE75480),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Benefits Grid
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                _buildBenefitCard(
                  icon: FontAwesomeIcons.stethoscope,
                  title: 'Expert Guidance',
                  color: Color(0xFFE75480),
                ),
                _buildBenefitCard(
                  icon: FontAwesomeIcons.clock,
                  title: '24/7 Availability',
                  color: Color(0xFF6A1B9A),
                ),
                _buildBenefitCard(
                  icon: FontAwesomeIcons.shieldAlt,
                  title: 'Safe Pregnancy',
                  color: Color(0xFF4CAF50),
                ),
                _buildBenefitCard(
                  icon: FontAwesomeIcons.calendarCheck,
                  title: 'Appointment Booking',
                  color: Color(0xFF2196F3),
                ),
              ],
            ),
            SizedBox(height: 30),

            // Chart Section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Doctor Consultations Improve Outcomes',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 250,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      series: <CartesianSeries>[
                        ColumnSeries<ChartData, String>(
                          dataSource: [
                            ChartData('No Consultations', 35),
                            ChartData('With Consultations', 82),
                          ],
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                          color: Color(0xFFE75480),
                        )
                      ],
                    ),
                  ),
                  Text(
                    'Pregnancy success rates with vs without doctor consultations',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Connect Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to doctor chat/booking
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE75480),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.userDoctor, size: 20, color: Colors.white,),
                    SizedBox(width: 10),
                    Text(
                      'Connect With Doctor Now',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            icon,
            color: color,
            size: 30,
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}