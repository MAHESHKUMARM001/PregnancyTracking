import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CertificatePage extends StatefulWidget {
  @override
  _CertificatePageState createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  final ScreenshotController screenshotController = ScreenshotController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();
  final TextEditingController placeOfBirthController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;
  final List<String> _genders = ['Male', 'Female'];
  bool isGenerating = false;

  Future<void> _generateAndSaveCertificate() async {
    if (!_formKey.currentState!.validate()) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      setState(() => isGenerating = true);
      final Uint8List? imageBytes = await screenshotController.capture(
        pixelRatio: 3.0,
      );

      if (imageBytes == null) throw Exception('Failed to capture certificate');

      final certificateImage = img.decodeImage(imageBytes);
      if (certificateImage == null) throw Exception('Failed to decode image');

      final correctedImage = img.flipVertical(certificateImage);
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'certificate_${nameController.text.isNotEmpty ? nameController.text : 'unnamed'}.png';
      final filePath = '${directory.path}/$fileName';

      await File(filePath).writeAsBytes(img.encodePng(correctedImage));

      final params = SaveFileDialogParams(
        sourceFilePath: filePath,
        fileName: fileName,
      );

      final savedPath = await FlutterFileDialog.saveFile(params: params);

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(savedPath != null
              ? 'Certificate saved successfully!'
              : 'Save operation cancelled'),
          backgroundColor: Color(0xFFE75480),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Failed to generate certificate: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      setState(() => isGenerating = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFFE75480),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFFE75480),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Widget buildCertificateLayout() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          Image.asset(
            'images/certificate.png',
            fit: BoxFit.contain,
          ),
          Positioned(
            top: 224,
            left: 34,
            child: Text(
              nameController.text,
              style: GoogleFonts.tinos(
                fontSize: 6.5,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            top: 290,
            left: 34,
            child: Text(
              motherNameController.text,
              style: GoogleFonts.tinos(
                fontSize: 6.5,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            top: 290,
            left: 194,
            child: Text(
              fatherNameController.text,
              style: GoogleFonts.tinos(
                fontSize: 6.5,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            top: 255,
            left: 34,
            child: Text(
              _selectedDate != null ? DateFormat('dd/MM/yyyy').format(_selectedDate!) : '',
              style: GoogleFonts.tinos(
                fontSize: 6.5,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            top: 243,
            left: 192,
            child: Text(
              placeOfBirthController.text,
              style: GoogleFonts.tinos(
                fontSize: 6.5,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            top: 224,
            left: 192,
            child: Text(
              _selectedGender ?? '',
              style: GoogleFonts.tinos(
                fontSize: 6.5,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF6F6),
      appBar: AppBar(
        title: Text(
          'Birth Certificate',
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
              // Header section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFFFE6EF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.certificate,
                        size: 40, color: Color(0xFFE75480)),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Generate Birth Certificate',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE75480),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Fill the details to create official certificate',
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

              // Form section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildPinkTextField(
                          controller: nameController,
                          labelText: "Baby's Name",
                          icon: FontAwesomeIcons.baby,
                          validator: (value) =>
                          value!.isEmpty ? 'Please enter baby name' : null,
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildPinkTextField(
                                controller: fatherNameController,
                                labelText: "Father's Name",
                                icon: FontAwesomeIcons.person,
                                validator: (value) =>
                                value!.isEmpty ? 'Please enter father name' : null,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildPinkTextField(
                                controller: motherNameController,
                                labelText: "Mother's Name",
                                icon: FontAwesomeIcons.personDress,
                                validator: (value) =>
                                value!.isEmpty ? 'Please enter mother name' : null,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        _buildDateField(),
                        SizedBox(height: 16),
                        _buildPinkTextField(
                          controller: placeOfBirthController,
                          labelText: "Place of Birth",
                          icon: FontAwesomeIcons.locationDot,
                          validator: (value) =>
                          value!.isEmpty ? 'Please enter place of birth' : null,
                        ),
                        SizedBox(height: 16),
                        _buildGenderDropdown(),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Preview section
              Text(
                'Certificate Preview',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4f4e4d),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Screenshot(
                  controller: screenshotController,
                  child: buildCertificateLayout(),
                ),
              ),
              SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: _buildPinkButton(
                      icon: FontAwesomeIcons.eye,
                      text: 'Preview',
                      onPressed: () => setState(() {}),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildPinkButton(
                      icon: isGenerating ? null : FontAwesomeIcons.download,
                      text: isGenerating ? 'Generating...' : 'Download',
                      onPressed: isGenerating ? null : _generateAndSaveCertificate,
                      isLoading: isGenerating,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinkTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.poppins(color: Color(0xFF4f4e4d)),
        prefixIcon: Icon(icon, color: Color(0xFFE75480), size: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFFF5C6D8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFFF5C6D8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFFE75480)),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      style: GoogleFonts.poppins(),
      validator: validator,
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: TextEditingController(
            text: _selectedDate != null
                ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                : '',
          ),
          decoration: InputDecoration(
            labelText: 'Date of Birth',
            labelStyle: GoogleFonts.poppins(color: Color(0xFF4f4e4d)),
            prefixIcon: Icon(FontAwesomeIcons.calendar,
                color: Color(0xFFE75480), size: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xFFF5C6D8)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xFFF5C6D8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xFFE75480)),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          style: GoogleFonts.poppins(),
          validator: (value) =>
          value!.isEmpty ? 'Please select date of birth' : null,
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      hint: Text('Select Gender', style: GoogleFonts.poppins()),
      value: _selectedGender,
      decoration: InputDecoration(
        labelText: 'Gender',
        labelStyle: GoogleFonts.poppins(color: Color(0xFF4f4e4d)),
        prefixIcon: Icon(FontAwesomeIcons.venusMars,
            color: Color(0xFFE75480), size: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFFF5C6D8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFFF5C6D8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFFE75480)),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      style: GoogleFonts.poppins(),
      validator: (value) =>
      value == null ? 'Please select gender' : null,
      onChanged: (String? newValue) {
        setState(() => _selectedGender = newValue);
      },
      items: _genders.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: GoogleFonts.poppins(color: Colors.black),),
        );
      }).toList(),
    );
  }

  Widget _buildPinkButton({
    IconData? icon,
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFE75480),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 14),
      ),
      child: isLoading
          ? SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: Colors.white,),
            SizedBox(width: 8),
          ],
          Text(
            text,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}