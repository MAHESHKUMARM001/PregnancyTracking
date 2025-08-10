import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PregnancyStartDatePage extends StatefulWidget {
  @override
  _PregnancyStartDatePageState createState() => _PregnancyStartDatePageState();
}

class _PregnancyStartDatePageState extends State<PregnancyStartDatePage> {
  DateTime? _selectedDate;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final String oneSignalAppId = '389d5078-988a-4245-9350-e8aca3b563dc'; // Replace with your real App ID
  final String oneSignalRestApiKey = 'os_v2_app_hcova6eyrjbele2q5cwkhnld3rdtmspfxq6udp4ltl4ykaxk6grovt7gfvnoiaak5nmfhgb7nmi655brmnuv7eufvwwulskt6gtxmea'; // Replace with your real API key

  @override
  void initState() {
    super.initState();
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(oneSignalAppId);
    _savePlayerIdToFirestore(); // Save player ID when screen loads
  }

  Future<void> _savePlayerIdToFirestore() async {
    final playerId = await OneSignal.User.getOnesignalId();
    // final playerId = status?.userId;


    final user = _auth.currentUser;
    if (user != null && playerId != null && playerId.isNotEmpty) {
      await _firestore.collection('users').doc(user.uid).set({
        'playerId': playerId,
      }, SetOptions(merge: true));
    } else {
      print("Failed to retrieve playerId or user is not logged in.");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 280)),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _savePregnancyDate() async {
    final user = _auth.currentUser;
    if (user == null || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a date and ensure you are logged in.')),
      );
      return;
    }

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'pregnancyStartDate': Timestamp.fromDate(_selectedDate!),
      }, SetOptions(merge: true));

      await _scheduleNotifications(_selectedDate!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pregnancy start date saved successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving date: $e')),
      );
    }
  }

  Future<void> _scheduleNotifications(DateTime startDate) async {
    final List<Map<String, dynamic>> milestones = [
      {
        'weeks': 1,
        'title': 'First Trimester Scan',
        'message': 'Time for your first trimester ultrasound scan!',
      },
      {
        'weeks': 2,
        'title': 'First Trimester Scan',
        'message': 'Time for your first trimester ultrasound scan!',
      },
      {
        'weeks': 3,
        'title': 'First Trimester Scan',
        'message': 'Time for your first trimester ultrasound scan!',
      },

      {
        'weeks': 20,
        'title': 'Anomaly Scan',
        'message': 'Schedule your anomaly scan to check your baby\'s development.',
      },
      {
        'weeks': 32,
        'title': 'Third Trimester Scan',
        'message': 'Time for your third trimester growth scan.',
      },
      {
        'weeks': 8,
        'title': 'Prenatal Vitamin Reminder',
        'message': 'Don\'t forget to take your prenatal vitamins!',
      },
      {
        'weeks': 16,
        'title': 'Tetanus Injection',
        'message': 'Schedule your tetanus toxoid injection.',
      },
    ];

    for (var milestone in milestones) {
      final notificationDate = startDate.add(Duration(days: (milestone['weeks'] as int) * 7));
      if (notificationDate.isAfter(DateTime.now())) {
        await _sendOneSignalNotification(
          milestone['title'],
          milestone['message'],
          notificationDate,
        );
      }
    }
  }

  Future<void> _sendOneSignalNotification(String title, String message, DateTime scheduledTime) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final playerId = userDoc.data()?['playerId'];

    if (playerId == null) {
      print("No OneSignal player ID found for user.");
      return;
    }

    final response = await http.post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Basic $oneSignalRestApiKey',
      },
      body: jsonEncode({
        'app_id': oneSignalAppId,
        'include_player_ids': [playerId], // 💡 Send only to this user
        'headings': {'en': title},
        'contents': {'en': message},
        'send_after': scheduledTime.toUtc().toIso8601String(),
      }),
    );

    if (response.statusCode != 200) {
      print("Error scheduling: ${response.body}");
    } else {
      print("Notification scheduled for $title");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF6F6),
      appBar: AppBar(
        title: Text(
          'Set Pregnancy Start Date',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select the start date of your pregnancy',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'Select Date'
                          : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                      style: GoogleFonts.poppins(
                        color: _selectedDate == null ? Colors.grey : Colors.black,
                      ),
                    ),
                    Icon(Icons.calendar_today, color: Color(0xFFE75480)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _savePregnancyDate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE75480),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Save Date',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
