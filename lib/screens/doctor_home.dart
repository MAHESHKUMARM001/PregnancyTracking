// screens/doctor_home.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth_service.dart';
import '../../chat_service.dart';
import 'chat_screen.dart';

class DoctorHomeScreen extends StatefulWidget {
  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  // String _doctorName = '';

  @override
  void initState() {
    super.initState();
    // _loadDoctorName();
  }

  // Future<void> _loadDoctorName() async {
  //   final authService = Provider.of<AuthService>(context, listen: false);
  //   String name = await authService.getUserName();
  //   setState(() {
  //     _doctorName = name;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Doctor: $_doctorName'),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.logout),
          //   onPressed: () {
          //     Provider.of<AuthService>(context, listen: false).signOut();
          //   },
          // ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Provider.of<ChatService>(context).getAllPatients(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No patients available'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var patient = snapshot.data!.docs[index];
                    return ListTile(
                      leading: CircleAvatar(child: Icon(Icons.person)),
                      title: Text(patient['name']),
                      subtitle: Text(patient['email']),
                      onTap: () {
                        Provider.of<ChatService>(context, listen: false)
                            .setCurrentChatUser(patient.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              otherUserId: patient.id,
                              otherUserName: patient['name'],
                            ),
                          ),
                        );
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
}