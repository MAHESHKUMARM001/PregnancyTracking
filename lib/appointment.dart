import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class BookAppointmentPage extends StatefulWidget {
  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _selectedDate;
  List<String> _selectedSymptoms = [];
  bool _isSubmitting = false;

  final List<String> _symptoms = [
    'Nausea/Vomiting',
    'Fatigue',
    'Back Pain',
    'Swelling',
    'Headaches',
    'Heartburn',
    'Frequent Urination',
    'Shortness of Breath',
    'Bleeding',
    'Decreased Fetal Movement',
    'Contractions',
    'Other'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFFE75480),
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
        _dateController.text = DateFormat('MMM dd, yyyy').format(picked);
      });
    }
  }

  Future<void> _submitAppointment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      await FirebaseFirestore.instance.collection('appointments').add({
        'userId': user.uid,
        'date': _selectedDate,
        'symptoms': _selectedSymptoms,
        'description': _descriptionController.text,
        'status': 'pending', // Initial status
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _showConfirmationDialog(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to book appointment: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF6F6),
      appBar: AppBar(
        title: Text(
          'Book Appointment',
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset(
                'images/appointment.jpg',
                height: 150,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),

              // Date Picker Field
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Appointment Date',
                  labelStyle: GoogleFonts.poppins(),
                  hintText: 'Select a date',
                  prefixIcon: Icon(Icons.calendar_today, color: Color(0xFFE75480)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFFE75480)),
                  ),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Symptoms Multi-Select
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: MultiSelectDialogField(
                  items: _symptoms
                      .map((symptom) => MultiSelectItem<String>(symptom, symptom))
                      .toList(),
                  title: Text(
                    'Select Symptoms',
                    style: GoogleFonts.poppins(),
                  ),
                  selectedColor: Color(0xFFE75480),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  buttonIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFFE75480),
                  ),
                  buttonText: Text(
                    _selectedSymptoms.isEmpty
                        ? 'Select your symptoms'
                        : '${_selectedSymptoms.length} selected',
                    style: GoogleFonts.poppins(),
                  ),
                  onConfirm: (results) {
                    setState(() {
                      _selectedSymptoms = results.cast<String>();
                    });
                  },
                  chipDisplay: MultiSelectChipDisplay<String>(
                    textStyle: GoogleFonts.poppins(color: Colors.white),
                    chipColor: Color(0xFFE75480),
                    items: _selectedSymptoms
                        .map((symptom) => MultiSelectItem<String>(symptom, symptom))
                        .toList(),
                    onTap: (value) {
                      setState(() {
                        _selectedSymptoms.remove(value);
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: GoogleFonts.poppins(),
                  hintText: 'Describe your condition or concerns...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFFE75480)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe your condition';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitAppointment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE75480),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  child: _isSubmitting
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'BOOK APPOINTMENT',
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
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Appointment Booked!',
            style: GoogleFonts.poppins(
              color: Color(0xFFE75480),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
              SizedBox(height: 20),
              Text(
                'Your appointment has been successfully scheduled for ${_dateController.text}',
                style: GoogleFonts.poppins(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              if (_selectedSymptoms.isNotEmpty)
                Text(
                  'Symptoms: ${_selectedSymptoms.join(', ')}',
                  style: GoogleFonts.poppins(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'OK',
                style: GoogleFonts.poppins(
                  color: Color(0xFFE75480),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to previous screen
              },
            ),
          ],
        );
      },
    );
  }
}