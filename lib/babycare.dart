import 'package:allobaay/certificatepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class BabyCarePage extends StatefulWidget {
  @override
  _BabyCarePageState createState() => _BabyCarePageState();
}

class _BabyCarePageState extends State<BabyCarePage> {
  final List<Map<String, dynamic>> babyCareMilestones = [
    {
      'title': 'Newborn (0-4 weeks)',
      'minAge': 0,
      'maxAge': 4,
      'image': 'images/newbaby.jpg',
      'vaccines': [
        {'name': 'Hepatitis B', 'week': 'At birth'},
      ],
      'medications': [
        {'name': 'Vitamin K', 'week': 'At birth'},
      ],
      'careTips': [
        'Feed every 2-3 hours (8-12 times/day)',
        'Ensure 14-17 hours of sleep',
        'Practice tummy time for 3-5 minutes daily',
        'Watch for jaundice symptoms'
      ],
      'icon': FontAwesomeIcons.baby,
    },
    {
      'title': '1-2 Months',
      'minAge': 4,
      'maxAge': 8,
      'image': 'images/1month.jpg',
      'vaccines': [
        {'name': 'DTaP, Hib, Polio, PCV13, Rotavirus', 'week': '6-8 weeks'},
      ],
      'medications': [
        {'name': 'Vitamin D drops', 'week': 'Daily'},
      ],
      'careTips': [
        'Continue feeding on demand',
        'Begin establishing sleep routine',
        'Respond to crying promptly',
        'Start tracking developmental milestones'
      ],
      'icon': FontAwesomeIcons.calendarWeek,
    },
    {
      'title': '3-4 Months',
      'minAge': 8,
      'maxAge': 16,
      'image': 'images/3month.jpg',
      'vaccines': [
        {'name': 'Second doses of 2-month vaccines', 'week': '14-16 weeks'},
      ],
      'medications': [
        {'name': 'Continue Vitamin D', 'week': 'Daily'},
      ],
      'careTips': [
        'Increase tummy time to 15-30 minutes',
        'Introduce early bedtime routine',
        'Watch for hand-to-mouth coordination',
        'Begin reading to baby daily'
      ],
      'icon': FontAwesomeIcons.babyCarriage,
    },
    {
      'title': '5-6 Months',
      'minAge': 16,
      'maxAge': 24,
      'image': 'images/6month.jpg',
      'vaccines': [
        {'name': 'Third doses of DTaP, Hib, Polio, PCV13', 'week': '6 months'},
        {'name': 'Influenza (optional)', 'week': '6 months'},
      ],
      'medications': [
        {'name': 'Iron supplements (if needed)', 'week': 'As prescribed'},
      ],
      'careTips': [
        'Introduce solid foods (with pediatrician approval)',
        'Establish consistent nap schedule',
        'Begin baby-proofing home',
        'Encourage sitting with support'
      ],
      'icon': FontAwesomeIcons.appleAlt,
    },
    {
      'title': '7-9 Months',
      'minAge': 24,
      'maxAge': 36,
      'image': 'images/9month.jpeg',
      'vaccines': [
        {'name': 'Hepatitis B, Polio', 'week': '6-9 months'},
      ],
      'medications': [
        {'name': 'Continue Vitamin D', 'week': 'Daily'},
      ],
      'careTips': [
        'Introduce finger foods',
        'Encourage crawling and exploration',
        'Begin teaching "no" for safety',
        'Establish consistent bedtime routine'
      ],
      'icon': FontAwesomeIcons.walking,
    },
    {
      'title': '10-12 Months',
      'minAge': 36,
      'maxAge': 52,
      'image': 'images/12month.jpg',
      'vaccines': [
        {'name': 'MMR, Varicella, Hepatitis A', 'week': '12 months'},
        {'name': 'PCV13, Hib', 'week': '12-15 months'},
      ],
      'medications': [
        {'name': 'Continue Vitamin D', 'week': 'Daily'},
      ],
      'careTips': [
        'Transition to whole milk at 12 months',
        'Encourage walking with support',
        'Begin teaching simple words',
        'Establish healthy eating habits'
      ],
      'icon': FontAwesomeIcons.birthdayCake,
    },
  ];

  DateTime? babyDOB;
  int? babyAgeInWeeks;
  bool isLoading = true;
  double progress = 0.0;
  String? childDocId;

  @override
  void initState() {
    super.initState();
    _fetchBabyDOB();
  }

  Future<void> _fetchBabyDOB() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('child')
            .where('user_id', isEqualTo: user.uid)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final doc = snapshot.docs.first;
          final childData = doc.data();
          final dobString = childData['date_of_birth'] as String?;
          final progressValue = childData['progress'] as int? ?? 0;

          if (dobString != null) {
            // Parse the date string (format: "18 April 2025 at 00:00:00 UTC")
            final dateFormat = DateFormat("dd MMMM yyyy 'at' HH:mm:ss 'UTC'");
            final dob = dateFormat.parse(dobString);

            setState(() {
              babyDOB = dob;
              progress = progressValue.toDouble();
              babyAgeInWeeks = _calculateAgeInWeeks(dob);
              childDocId = doc.id;
              isLoading = false;
            });

            // Update progress if needed
            _updateChildProgress(dob);
          }
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching baby DOB: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  int _calculateAgeInWeeks(DateTime dob) {
    final now = DateTime.now();
    final difference = now.difference(dob);
    return (difference.inDays / 7).floor();
  }

  Future<void> _updateChildProgress(DateTime dob) async {
    if (childDocId == null) return;

    final ageInWeeks = _calculateAgeInWeeks(dob);
    final newProgress = (ageInWeeks / 52 * 100).clamp(0, 100).toInt();

    if (newProgress > progress) {
      await FirebaseFirestore.instance
          .collection('child')
          .doc(childDocId)
          .update({'progress': newProgress});

      setState(() {
        progress = newProgress.toDouble();
      });
    }
  }

  Widget _buildMilestoneCard(Map<String, dynamic> milestone, bool isCurrent) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Milestone Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF8E1E7),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                FaIcon(
                  milestone['icon'],
                  color: Color(0xFFE75480),
                ),
                SizedBox(width: 12),
                Text(
                  milestone['title'],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE75480),
                  ),
                ),
                if (isCurrent) ...[
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFE75480),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Current',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Milestone Image
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(0),
              bottom: Radius.circular(0),
            ),
            child: Image.asset(
              milestone['image'],
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Vaccination Schedule
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vaccinations',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE75480),
                  ),
                ),
                SizedBox(height: 8),
                ...milestone['vaccines'].map<Widget>((vaccine) => Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.syringe,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${vaccine['name']} - ${vaccine['week']}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ],
            ),
          ),

          // Medications
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medications',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE75480),
                  ),
                ),
                SizedBox(height: 8),
                ...milestone['medications'].map<Widget>((med) => Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.pills,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${med['name']} - ${med['week']}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ],
            ),
          ),

          // Care Tips
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF9F9F9),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Care Tips',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE75480),
                  ),
                ),
                SizedBox(height: 8),
                ...milestone['careTips'].map<Widget>((tip) => Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.checkCircle,
                        size: 12,
                        color: Colors.green,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tip,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFFFEF6F6),
        body: Center(child: CircularProgressIndicator(color: Color(0xFFE75480))),
      );
    }

    if (babyDOB == null) {
      return Scaffold(
        backgroundColor: Color(0xFFFEF6F6),
        appBar: AppBar(
          title: Text(
            'Baby Care Guide',
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.child_care, size: 60, color: Color(0xFFE75480)),
                SizedBox(height: 20),
                Text(
                  'No baby information found',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE75480),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Please add your baby\'s date of birth to access the care guide',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: Colors.grey[600]),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE75480),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  onPressed: () {
                    // Navigate to baby DOB entry page
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => BabyDOBPage()));
                  },
                  child: Text(
                    'Add Baby DOB',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentMilestones = babyCareMilestones.where((milestone) {
      return babyAgeInWeeks! >= milestone['minAge'] && babyAgeInWeeks! <= milestone['maxAge'];
    }).toList();

    final upcomingMilestones = babyCareMilestones.where((milestone) {
      return babyAgeInWeeks! < milestone['minAge'];
    }).toList();

    return Scaffold(
      backgroundColor: Color(0xFFFEF6F6),
      appBar: AppBar(
        title: Text(
          'Baby Care Guide',
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
            children: [
              // Progress indicator
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.certificate, color: Color(0xFFE75480)),
                    SizedBox(width: 15),
                    Text(
                      'Get Certificate',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE75480),
                      ),
                    ),
                    SizedBox(width: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE75480),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      ),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CertificatePage()),
                        );
                      },
                      child: Text(
                        'Get Certificate',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        FaIcon(FontAwesomeIcons.baby, color: Color(0xFFE75480)),
                        SizedBox(width: 10),
                        Text(
                          'Baby Progress',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE75480),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: progress / 100,
                      backgroundColor: Color(0xFFF5C6D8),
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE75480)),
                      minHeight: 12,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${progress.toStringAsFixed(0)}% completed - ${52 - babyAgeInWeeks!} weeks to go!',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Color(0xFF4f4e4d),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Age: $babyAgeInWeeks weeks',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE75480),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Current milestones
              if (currentMilestones.isNotEmpty)
                ...currentMilestones.map((milestone) => _buildMilestoneCard(milestone, true)).toList(),

              // Upcoming milestones
              if (upcomingMilestones.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Coming Up Next',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE75480),
                        ),
                      ),
                      SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: upcomingMilestones.length,
                        itemBuilder: (context, index) {
                          final milestone = upcomingMilestones[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: FaIcon(milestone['icon'], color: Color(0xFFE75480)),
                            title: Text(
                              milestone['title'],
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE75480),
                              ),
                            ),
                            subtitle: Text(
                              'Starts at ${milestone['minAge']} weeks',
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                            trailing: Icon(Icons.arrow_forward, color: Color(0xFFE75480)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}