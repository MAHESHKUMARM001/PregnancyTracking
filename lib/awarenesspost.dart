import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AwarenessPostPage extends StatelessWidget {
  final List<Map<String, String>> awarenessPosts = [
    {
      'title': 'Nutrition During Pregnancy',
      'image': 'images/nutritionimage.jpg',
      'content':
      'Eating a balanced diet is crucial for your baby’s growth. Include fruits, vegetables, whole grains, lean proteins, and dairy. Avoid raw fish, undercooked meat, and excessive caffeine.',
    },
    {
      'title': 'Exercise & Wellness',
      'image': 'images/excersice.jpg',
      'content':
      'Moderate exercise like walking, swimming, and prenatal yoga helps maintain a healthy pregnancy. Always consult your doctor before starting any new exercise routine.',
    },
    {
      'title': 'Common Pregnancy Symptoms',
      'image': 'images/symtoms.jpg',
      'content':
      'Morning sickness, fatigue, and backaches are common. Stay hydrated, rest well, and seek medical advice if symptoms become severe.',
    },
    {
      'title': 'Mental Health Matters',
      'image': 'images/mentalhealth.jpg',
      'content':
      'Pregnancy can bring mood swings and anxiety. Practice mindfulness, talk to loved ones, and seek professional help if needed.',
    },
    {
      'title': 'Preparing for Labor',
      'image': 'images/labor.jpg',
      'content':
      'Attend prenatal classes, pack a hospital bag early, and discuss your birth plan with your healthcare provider.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF6F6),
      appBar: AppBar(
        title: Text(
          'Awareness Posts',
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
              // Search Bar (Optional)
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 16),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(12),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.withOpacity(0.1),
              //         blurRadius: 8,
              //         spreadRadius: 2,
              //       ),
              //     ],
              //   ),
              //   child: TextField(
              //     decoration: InputDecoration(
              //       hintText: 'Search awareness topics...',
              //       hintStyle: GoogleFonts.poppins(color: Colors.grey),
              //       border: InputBorder.none,
              //       prefixIcon: Icon(Icons.search, color: Color(0xFFE75480)),
              //     ),
              //   ),
              // ),
              SizedBox(height: 20),

              // Awareness Posts List
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: awarenessPosts.length,
                itemBuilder: (context, index) {
                  final post = awarenessPosts[index];
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
                        // Post Image
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.asset(
                            post['image']!,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Post Content
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post['title']!,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE75480),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                post['content']!,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 12),
                              // Row(
                              //   children: [
                              //     Icon(Icons.favorite_border, color: Colors.pink),
                              //     SizedBox(width: 8),
                              //     Text('24 Likes', style: GoogleFonts.poppins(color: Colors.grey)),
                              //     Spacer(),
                              //     Icon(Icons.share, color: Colors.pink),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}