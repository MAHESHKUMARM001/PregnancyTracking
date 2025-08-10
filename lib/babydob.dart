// lib/pages/baby_dob_page.dart
import 'package:allobaay/babycare.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BabyDOBPage extends StatefulWidget {
  const BabyDOBPage({super.key});

  @override
  State<BabyDOBPage> createState() => _BabyDOBPageState();
}

class _BabyDOBPageState extends State<BabyDOBPage> {
  DateTime? _selectedDate;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE75480),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveBabyDOB() async {
    if (_selectedDate == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = _auth.currentUser;
      if (user != null) {
        final dateFormat = DateFormat('dd MMMM yyyy \'at\' HH:mm:ss \'UTC\'Z');
        final formattedDate = dateFormat.format(_selectedDate!);

        await _firestore.collection('child').add({
          'date_of_birth': formattedDate,
          // 'uid': user.uid,
          'user_id': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Baby date of birth saved successfully!',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: const Color(0xFF1ABBAC),
          ),
        );

        // Optionally navigate back or to another page
        // Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BabyCarePage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error saving date: ${e.toString()}',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF6F6),
      appBar: AppBar(
        title: Text(
          'Baby Date of Birth',
          style: GoogleFonts.poppins(
            color: const Color(0xFFE75480),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFE75480)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        // Header with illustration
        Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE6EF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset('images/12month.jpg', width: 80), // Add your baby image asset
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Little One!',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFE75480),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Record your baby\'s birth date to track milestones',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF4f4e4d),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 30),

      // Date selection card
      Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Select Baby\'s Date of Birth',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFE75480),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE75480).withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: const Icon(Icons.calendar_today, color: Color(0xFFE75480)),
                  title: Text(
                    _selectedDate == null
                        ? 'Select a date'
                        : DateFormat('dd MMMM yyyy').format(_selectedDate!),
                    style: GoogleFonts.poppins(),
                  ),
                  trailing: const Icon(Icons.arrow_drop_down, color: Color(0xFFE75480)),
                  onTap: () => _selectDate(context),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE75480),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: _selectedDate == null || _isLoading ? null : _saveBabyDOB,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Save Date',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      const SizedBox(height: 30),

      // Information section
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.infoCircle,
                  color: Color(0xFF1ABBAC),
                ),
                const SizedBox(width: 8),
                Text(
                  'Why this is important',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Text(
              'Recording your baby\'s exact date of birth helps us provide accurate:\n\n• Growth milestone tracking\n• Vaccination reminders\n• Developmental guidance\n• Personalized baby care tips',
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
    );
  }
}