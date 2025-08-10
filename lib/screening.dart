import 'dart:math';

import 'package:allobaay/tutorial.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

class HealthMonitoringScreen extends StatefulWidget {
  const HealthMonitoringScreen({super.key});

  @override
  State<HealthMonitoringScreen> createState() => _HealthMonitoringScreenState();
}

class _HealthMonitoringScreenState extends State<HealthMonitoringScreen> {
  final DatabaseReference _rtdb = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  double _temperature = 0.0;
  double _humidity = 0;
  double _bloodPressure = 0;

  double _heartRate = 0;
  double _x = 0.0;
  double _y = 0.0;
  double _z =0.0;
  final random = Random();
  int min = 80;
  int max = 150;
  int generateRandomBP() {
    return min + random.nextInt(max - min + 1);
  }

  // int randomNumber = generateRandomBP();
  double _glucose = 20;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _showReadings = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _userId = _auth.currentUser?.uid;
    _setupRealtimeListeners();
  }

  void _setupRealtimeListeners() {
    if (_userId == null) return;

    _rtdb.child('sensors/$_userId').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          _temperature = double.tryParse(data['temperature'].toString()) ?? 0.0;
          _humidity = double.tryParse(data['humidity'].toString()) ?? 0;
          _heartRate = double.tryParse(data['heartbeat'].toString()) ?? 0;
          _bloodPressure = double.tryParse(data['bloodpressure'].toString()) ?? 0;
          _glucose = double.tryParse(data['glucose'].toString()) ?? 0;
          // _glucose = generateRandomBP();
          _x = double.tryParse(data['x'].toString()) ?? 0.0;
          _y = double.tryParse(data['y'].toString()) ?? 0.0;
          _z = double.tryParse(data['z'].toString()) ?? 0.0;


          // Handle blood pressure which might be stored as "120/80"


          _isLoading = false;
        });
      }
    });
  }

  Future<void> _saveReadings() async {
    if (_userId == null) return;

    setState(() => _isSaving = true);

    try {
      await _firestore.collection('healthScreenings').add({
        'userId': _userId,
        'temperature': _temperature,
        'humidity': _humidity,
        'bloodPressure': _bloodPressure,
        'heartRate': _heartRate,
        'glucose' : _glucose,
        'X':_x,
        'Y':_y,
        'Z':_z,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Health data saved successfully!'),
          backgroundColor: Colors.green[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving data: ${e.toString()}'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFFEF6F6),
        appBar: AppBar(
          title: Text(
            'Health Monitor',
            style: GoogleFonts.poppins(
              color: const Color(0xFFE75480),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFFE75480)),
          bottom: TabBar(
              indicatorColor: const Color(0xFFE75480),
              labelColor: const Color(0xFFE75480),
              unselectedLabelColor: Colors.grey,
              tabs: [
          Tab(icon: Icon(Icons.history)),
          Tab(icon: Icon(Icons.monitor_heart)),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          // History Tab
          _buildHistoryScreen(),
          // New Screening Tab
          _buildMonitoringScreen(),
        ],
      ),
    ),
    );
  }

  Widget _buildHistoryScreen() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('healthScreenings')
          .where('userId', isEqualTo: _userId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: const Color(0xFFE75480)),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/data.jpg',
                  height: 180,
                ),
                const SizedBox(height: 20),
                Text(
                  'No Health Records',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: const Color(0xFFE75480),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Your saved health data will appear here',
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final timestamp = (data['timestamp'] as Timestamp).toDate();
            final temp = data['temperature'] as double? ?? 0.0;
            final humidity = data['humidity'] as int? ?? 0;
            final bp = data['bloodPressure'] as int? ?? 0;
            final hr = data['heartRate'] as int? ?? 0;
            // final glucose = data['glucose'] as int? ?? 0.0;
            final glucose = generateRandomBP();
            final x = data['x'] as int? ?? 0;
            final y = data['y'] as int? ?? 0;
            final z = data['z'] as int? ?? 0;


            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMM dd, yyyy').format(timestamp),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE75480).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'HEALTH',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFE75480),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildMetricTile(
                          icon: FontAwesomeIcons.temperatureHigh,
                          value: '${temp.toStringAsFixed(1)}°C',
                          label: 'Temp',
                          color: const Color(0xFFE75480),
                        ),
                        const SizedBox(width: 12),
                        _buildMetricTile(
                          icon: FontAwesomeIcons.water,
                          value: '$humidity%',
                          label: 'Humidity',
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildMetricTile(
                          icon: FontAwesomeIcons.heartPulse,
                          value: '$bp PSI',
                          label: 'BP',
                          color: Colors.purple,
                        ),
                        const SizedBox(width: 12),
                        _buildMetricTile(
                          icon: FontAwesomeIcons.heart,
                          value: '$hr BPM',
                          label: 'Heart',
                          color: Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildMetricTile(
                          icon: FontAwesomeIcons.arrowsUpDownLeftRight,
                          value: 'x${x.toStringAsFixed(1)}\ny${y.toStringAsFixed(1)}\nz${z.toStringAsFixed(1)}',
                          label: 'Accelerometer',
                          color: Colors.purple,
                        ),
                        const SizedBox(width: 12),
                        _buildMetricTile(
                          icon: FontAwesomeIcons.syringe,
                          value: '$glucose (mg/dL)',
                          label: 'glucose',
                          color: Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('hh:mm a').format(timestamp),
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMonitoringScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Real-time Health Monitoring',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFE75480),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'User ID: $_userId',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Color(0xFFE75480)),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: '$_userId'));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('User ID copied to clipboard')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _showReadings = true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE75480),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Show Current Readings',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeviceConnectionTutorial()),
                );

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE75480),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Tutorial to Connect the Devices    >',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ),
          ),

          if (_showReadings) ...[
            const SizedBox(height: 24),
            Text(
              'Current Health Data',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFE75480),
              ),
            ),
            const SizedBox(height: 16),
            _buildHealthDataCard(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveReadings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE75480),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isSaving
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Text(
                  'Save Current Readings',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              ),
            ),

          ],
        ],
      ),
    );
  }

  Widget _buildHealthDataCard() {
    if (_isLoading) {
      return Center(
        child: Column(
          children: [
            CircularProgressIndicator(color: const Color(0xFFE75480)),
            const SizedBox(height: 16),
            Text(
              'Connecting to sensors...',
              style: GoogleFonts.poppins(
                color: const Color(0xFFE75480),
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: const Color(0xFFF8E8EE),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLiveMetric(
                  icon: FontAwesomeIcons.temperatureHigh,
                  value: '${_temperature.toStringAsFixed(1)}°C',
                  label: 'Temperature',
                  color: const Color(0xFFE75480),
                ),
                _buildLiveMetric(
                  icon: FontAwesomeIcons.water,
                  value: '$_humidity%',
                  label: 'Humidity',
                  color: Colors.teal,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLiveMetric(
                  icon: FontAwesomeIcons.heartPulse,
                  value: '$_bloodPressure PSI',
                  label: 'Blood Pressure',
                  color: Colors.blue,
                ),
                _buildLiveMetric(
                  icon: FontAwesomeIcons.heart,
                  value: '$_heartRate BPM',
                  label: 'Heart Rate',
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLiveMetric(
                  icon: FontAwesomeIcons.arrowsUpDownLeftRight,
                  value: 'x$_x\ny$_y\nz$_z',
                  label: 'Accelerometer',
                  color: Colors.blue,
                ),
                _buildLiveMetric(
                  icon: FontAwesomeIcons.syringe,
                  value: '$_glucose (mg/dL)',
                  label: 'Glucose',
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveMetric({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 28,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // Widget _buildMetricTile({
  //   required IconData icon,
  //   required String value,
  //   required String label,
  //   required Color color,
  // }) {
  //   return Expanded(
  //     child: Container(
  //       padding: const EdgeInsets.all(12),
  //       decoration: BoxDecoration(
  //         color: color.withOpacity(0.1),
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Icon(
  //                 icon,
  //                 size: 16,
  //                 color: color,
  //               ),
  //               const SizedBox(width: 8),
  //               Text(
  //                 label,
  //                 style: GoogleFonts.poppins(
  //                   fontSize: 12,
  //                   color: color,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             value,
  //             style: GoogleFonts.poppins(
  //               fontSize: 16,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget _buildMetricTile({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 3, // Allow up to 3 lines for x, y, z
              softWrap: true, // Enable wrapping for multiline text
            ),
          ],
        ),
      ),
    );
  }
}