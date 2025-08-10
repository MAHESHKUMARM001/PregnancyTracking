import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'dart:convert';

class PatientReportsPage extends StatefulWidget {
  const PatientReportsPage({super.key});

  @override
  State<PatientReportsPage> createState() => _PatientReportsPageState();
}

class _PatientReportsPageState extends State<PatientReportsPage> {
  final List<String> _reportTypes = [
    'Blood Test',
    'Ultrasound',
    'HCG Test',
    'ECG',
    'MRI',
    'X-Ray',
    'CT Scan',
    'Mammogram',
    'Other'
  ];
  String? _selectedReportType;
  final TextEditingController _descriptionController = TextEditingController();
  List<File?> _reportImages = [null, null, null];
  bool _isUploading = false;

  // Cloudinary configuration
  final String _cloudName = 'dbihdlrkh';
  final String _uploadPreset = 'mahesh001';
  final String _apiKey = '892724771292187';

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(int index) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _reportImages[index] = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadToCloudinary(File image) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/image/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = _uploadPreset
      ..fields['api_key'] = _apiKey
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        image.path,
        filename: path.basename(image.path),
      ));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      return responseData; // You'll need to parse the JSON to get the URL
    } else {
      throw Exception('Failed to upload image to Cloudinary');
    }
  }

  Future<void> _uploadReport() async {
    if (_selectedReportType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a report type')),
      );
      return;
    }

    if (_reportImages.every((image) => image == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload at least one image')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isEmpty) throw Exception('User not logged in');

      // Upload images to Cloudinary and get URLs
      List<String> imageUrls = [];
      for (var image in _reportImages) {
        if (image != null) {
          final response = await _uploadToCloudinary(image);
          // Parse response to get URL (you'll need to implement this)
          final imageUrl = _parseCloudinaryResponse(response);
          imageUrls.add(imageUrl);
        }
      }

      // Save report data to Firestore
      await FirebaseFirestore.instance.collection('reports').add({
        'userId': userId,
        'reportType': _selectedReportType,
        'description': _descriptionController.text,
        'imageUrls': imageUrls,
        'createdAt': Timestamp.now(),
        'date': Timestamp.now(), // You might want to add a specific date field
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report uploaded successfully!')),
      );

      // Clear form
      setState(() {
        _reportImages = [null, null, null];
        _selectedReportType = null;
        _descriptionController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading report: ${e.toString()}')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  String _parseCloudinaryResponse(String response) {
    try {
      // Parse the JSON response
      final Map<String, dynamic> responseData = json.decode(response);

      // Extract the secure_url from the response
      final String? secureUrl = responseData['secure_url'];

      if (secureUrl == null) {
        throw Exception('No secure_url found in Cloudinary response');
      }

      return secureUrl;
    } catch (e) {
      // Handle any parsing errors
      throw Exception('Failed to parse Cloudinary response: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFFFEF6F6),
        appBar: AppBar(
          title: Text(
            'Medical Reports',
            style: GoogleFonts.poppins(
              color: Color(0xFFE75480),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFFE75480)),
          bottom: TabBar(
            indicatorColor: Color(0xFFE75480),
            labelColor: Color(0xFFE75480),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'My Reports'),
              Tab(text: 'Upload Report'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Existing Reports Tab
            _buildReportsList(),
            // Upload Report Tab
            _buildUploadForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsList() {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reports')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Color(0xFFE75480)));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/report.png',
                  height: 150,
                ),
                SizedBox(height: 20),
                Text(
                  'No Reports Yet',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Color(0xFFE75480),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Upload your first medical report',
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final report = snapshot.data!.docs[index];
            final createdAt = (report['createdAt'] as Timestamp).toDate();
            final reportType = report['reportType'] as String? ?? 'Unknown';
            final description = report['description'] as String? ?? '';
            final imageUrls = List<String>.from(report['imageUrls'] ?? []);

            return Container(
              margin: EdgeInsets.only(bottom: 16),
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
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          reportType,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFE75480).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'REPORT',
                            style: GoogleFonts.poppins(
                              color: Color(0xFFE75480),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(color: Colors.grey[200]),
                    SizedBox(height: 10),
                    if (description.isNotEmpty) ...[
                      Text(
                        'Description:',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        description,
                        style: GoogleFonts.poppins(
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                    if (imageUrls.isNotEmpty) ...[
                      Text(
                        'Images:',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imageUrls.length,
                          itemBuilder: (context, imgIndex) {
                            return Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  imageUrls[imgIndex],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.calendarPlus,
                          size: 14,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Uploaded on ${DateFormat('dd MMM yyyy, hh:mm a').format(createdAt)}',
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

  Widget _buildUploadForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload New Report',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE75480),
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Report Type',
                labelStyle: GoogleFonts.poppins(
                  color: Color(0xFFE75480),
                ),
              ),
              value: _selectedReportType,
              items: _reportTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedReportType = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a report type';
                }
                return null;
              },
              icon: Icon(Icons.arrow_drop_down, color: Color(0xFFE75480)),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Upload Images',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: List.generate(1, (index) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => _pickImage(index),
                  child: Container(
                    margin: EdgeInsets.only(right: index < 2 ? 10 : 0),
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _reportImages[index] == null
                            ? Colors.grey[300]!
                            : Color(0xFFE75480),
                        width: 1,
                      ),
                    ),
                    child: _reportImages[index] == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          color: Color(0xFFE75480),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Add Image',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _reportImages[index]!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Description (Optional)',
              labelStyle: GoogleFonts.poppins(
                color: Color(0xFFE75480),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFE75480)),
              ),
              contentPadding: EdgeInsets.all(16),
            ),
          ),
          SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isUploading ? null : _uploadReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE75480),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isUploading
                  ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : Text(
                'Upload Report',
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
    );
  }
}