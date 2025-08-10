import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DoctorReportPage extends StatefulWidget {
  const DoctorReportPage({super.key});

  @override
  State<DoctorReportPage> createState() => _DoctorReportPageState();
}

class _DoctorReportPageState extends State<DoctorReportPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String searchQuery = '';
  final Map<String, Map<String, String>> _userCache = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Patient Reports',
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
        color: const Color(0xFFE75480),
            onPressed: () {
              setState(() {
                searchQuery = '';
                _userCache.clear();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchFilter(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('reports').snapshots(),
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

                return FutureBuilder<List<Report>>(
                  future: _processReports(snapshot.data!.docs),
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!asyncSnapshot.hasData || asyncSnapshot.data!.isEmpty) {
                      return _buildEmptyState();
                    }

                    var reports = asyncSnapshot.data!;

                    // Apply search filter
                    reports = reports.where((report) {
                      return searchQuery.isEmpty ||
                          report.userEmail.toLowerCase().contains(searchQuery.toLowerCase());
                    }).toList();

                    if (reports.isEmpty) {
                      return _buildEmptyState(searchActive: true);
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        return _buildReportCard(reports[index]);
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

  Widget _buildSearchFilter() {
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
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Search by patient email',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                searchQuery = '';
              });
            },
          )
              : null,
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      ),
    );
  }

  Future<List<Report>> _processReports(List<QueryDocumentSnapshot> docs) async {
    List<Report> reports = [];

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

      reports.add(Report(
        id: doc.id,
        userId: userId,
        userName: userData?['name'] ?? 'Unknown',
        userEmail: userData?['email'] ?? 'No email',
        date: (data['date'] as Timestamp).toDate(),
        description: data['description'] ?? 'No description',
        imageUrls: List<String>.from(data['imageUrls'] ?? []),
        reportType: data['reportType'] ?? 'Unknown Type',
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      ));
    }

    // Sort by date (newest first)
    reports.sort((a, b) => b.date.compareTo(a.date));

    return reports;
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

  Widget _buildReportCard(Report report) {
    return Card(
      elevation: 3,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.userName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      report.userEmail,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    report.reportType,
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Uploaded: ${DateFormat('MMM dd, yyyy - hh:mm a').format(report.date)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            if (report.imageUrls.isNotEmpty) ...[
              const Text(
                'Report Images:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...report.imageUrls.map((url) => Column(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[100],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue[800],
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // ElevatedButton.icon(
                  //   icon: const FaIcon(
                  //     FontAwesomeIcons.download,
                  //     size: 14,
                  //   ),
                  //   label: const Text('Download',style: TextStyle(color: Colors.white),),
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.blue[800],
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 12,
                  //       vertical: 8,
                  //     ),
                  //   ),
                  //   onPressed: () => _downloadImage(url),
                  // ),
                  const SizedBox(height: 16),
                ],
              )).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _downloadImage(String url) async {
    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        throw 'Storage permission not granted';
      }

      final dir = await getExternalStorageDirectory();
      if (dir == null) {
        throw 'Could not get download directory';
      }

      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: dir.path,
        fileName: 'report_${DateTime.now().millisecondsSinceEpoch}.jpg',
        showNotification: true,
        openFileFromNotification: true,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Download started'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildEmptyState({bool searchActive = false}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/report.png',
            height: 200,
            width: 200,
          ),
          const SizedBox(height: 16),
          Text(
            searchActive ? 'No matching reports found' : 'No reports available',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            searchActive ? 'Try a different search' : 'Reports will appear here when available',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class Report {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final DateTime date;
  final String description;
  final List<String> imageUrls;
  final String reportType;
  final DateTime createdAt;

  Report({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.date,
    required this.description,
    required this.imageUrls,
    required this.reportType,
    required this.createdAt,
  });
}