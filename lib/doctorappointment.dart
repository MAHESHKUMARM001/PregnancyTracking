import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorAppointmentPage extends StatefulWidget {
  const DoctorAppointmentPage({super.key});

  @override
  State<DoctorAppointmentPage> createState() => _DoctorAppointmentPageState();
}

class _DoctorAppointmentPageState extends State<DoctorAppointmentPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String statusFilter = 'all';
  String searchQuery = '';
  final Map<String, Map<String, String>> _userCache = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Appointment Management',
          style: GoogleFonts.poppins(
            color: const Color(0xFFE75480),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFFEF6F6),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                statusFilter = 'all';
                searchQuery = '';
                _userCache.clear();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('appointments').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildEmptyState();
                }

                return FutureBuilder<List<Appointment>>(
                  future: _processAppointments(snapshot.data!.docs),
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!asyncSnapshot.hasData || asyncSnapshot.data!.isEmpty) {
                      return _buildEmptyState();
                    }

                    var appointments = asyncSnapshot.data!;

                    // Apply filters
                    appointments = appointments.where((appointment) {
                      final matchesStatus = statusFilter == 'all' ||
                          appointment.status == statusFilter;
                      final matchesSearch = searchQuery.isEmpty ||
                          appointment.userEmail.toLowerCase().contains(searchQuery.toLowerCase()) ||
                          appointment.userName.toLowerCase().contains(searchQuery.toLowerCase());
                      return matchesStatus && matchesSearch;
                    }).toList();

                    if (appointments.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        return _buildAppointmentCard(appointments[index]);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Appointment>> _processAppointments(List<QueryDocumentSnapshot> docs) async {
    List<Appointment> appointments = [];

    for (var doc in docs) {
      var data = doc.data() as Map<String, dynamic>;
      String userId = data['userId'] ?? '';

      // Get user data from cache or Firestore
      Map<String, String>? userData = _userCache[userId];
      if (userData == null) {
        userData = await _fetchUserData(userId);
        if (userData != null) {
          _userCache[userId] = userData;
        }
      }

      appointments.add(Appointment(
        id: doc.id,
        userId: userId,
        userName: userData?['name'] ?? 'Unknown',
        userEmail: userData?['email'] ?? 'No email',
        date: (data['date'] as Timestamp).toDate(),
        description: data['description'] ?? 'No description',
        symptoms: List<String>.from(data['symptoms'] ?? []),
        status: data['status'] ?? 'pending',
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      ));
    }

    return appointments;
  }

  Future<Map<String, String>?> _fetchUserData(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        return {
          'name': userData['name'] ?? 'Unknown',
          'email': userData['email'] ?? 'No email',
        };
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
    return null;
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: statusFilter,
                  decoration: InputDecoration(
                    labelText: 'Filter by Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.filter_alt_outlined),
                  ),
                  items: [
                    'all',
                    'pending',
                    'approved',
                    'cancelled',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.capitalize()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      statusFilter = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Search by email/name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusIndicator('Pending', Colors.orange),
              _buildStatusIndicator('Approved', Colors.green),
              _buildStatusIndicator('Cancelled', Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appointment.userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(appointment.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    appointment.status.capitalize(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              appointment.userEmail,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                    color: Color(0xFFE75480)
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMM dd, yyyy - hh:mm a').format(appointment.date),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.medical_services,
                  size: 16,
                    color: Color(0xFFE75480)
                ),
                const SizedBox(width: 8),
                Text(appointment.description),
              ],
            ),
            const SizedBox(height: 12),
            if (appointment.symptoms.isNotEmpty) ...[
              const Text(
                'Symptoms:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: appointment.symptoms
                    .map((symptom) => Chip(
                  label: Text(symptom),
                  backgroundColor: const Color(0xFFFEF6F6),
                  labelStyle: const TextStyle(
                      color: Color(0xFFE75480)
                  ),
                ))
                    .toList(),
              ),
              const SizedBox(height: 12),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Created: ${DateFormat('MMM dd, yyyy').format(appointment.createdAt)}',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
                if (appointment.status == 'pending')
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const FaIcon(
                          FontAwesomeIcons.check,
                          size: 14,
                        ),
                        label: const Text('Approve'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        onPressed: () {
                          _updateAppointmentStatus(appointment.id, 'approved');
                        },
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        icon: const FaIcon(
                          FontAwesomeIcons.times,
                          size: 14,
                        ),
                        label: const Text('Cancel'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        onPressed: () {
                          _updateAppointmentStatus(appointment.id, 'cancelled');
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateAppointmentStatus(String id, String status) async {
    try {
      await _firestore.collection('appointments').doc(id).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update appointment: $e')),
      );
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/noappointment.png',
            height: 200,
            width: 200,
          ),
          const SizedBox(height: 16),
          const Text(
            'No appointments found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class Appointment {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final DateTime date;
  final String description;
  final List<String> symptoms;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Appointment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.date,
    required this.description,
    required this.symptoms,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}