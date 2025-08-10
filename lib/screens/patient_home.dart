// screens/patient_home.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth_service.dart';
import '../../chat_service.dart';
import 'chat_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class PatientHomeScreen extends StatefulWidget {
  @override
  _PatientHomeScreenState createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  String _patientName = '';
  String? _doctorId;

  @override
  void initState() {
    super.initState();
    // _loadPatientName();
    _findDoctor();
  }

  // Future<void> _loadPatientName() async {
  //   final authService = Provider.of<AuthService>(context, listen: false);
  //   String name = await authService.getUserName();
  //   setState(() {
  //     _patientName = name;
  //   });
  // }

  Future<void> _findDoctor() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: "doctor001@gmail.com")
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        _doctorId = snapshot.docs.first.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      // body: Center(
      //   child: _doctorId == null
      //       ? CircularProgressIndicator()
      //       : ElevatedButton(
      //     onPressed: () {
      //       Provider.of<ChatService>(context, listen: false)
      //           .setCurrentChatUser(_doctorId!);
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => ChatScreen(
      //             otherUserId: _doctorId!,
      //             otherUserName: 'Doctor',
      //           ),
      //         ),
      //       );
      //     },
      //     child: Text('Chat with Doctor'),
      //   ),
      // ),
      body: Center(
        child: _doctorId == null
            ? CircularProgressIndicator()
            : SingleChildScrollView(
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
                    Provider.of<ChatService>(context, listen: false)
                              .setCurrentChatUser(_doctorId!);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                otherUserId: _doctorId!,
                                otherUserName: 'Doctor',
                              ),
                            ),
                          );
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
        )
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
