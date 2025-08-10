import 'package:allobaay/appinfo.dart';
import 'package:allobaay/help.dart';
import 'package:allobaay/login.dart';
import 'package:allobaay/privacy.dart';
import 'package:allobaay/terms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localization.dart';
// import 'locale_provider.dart'; // Import the LocaleProvider
import 'local_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String name = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          name = userDoc['name'] ?? 'No Name';
          email = userDoc['email'] ?? 'No Email';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final currentLocale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: const Color(0xFFFEF6F6),
      appBar: AppBar(
        title: Text(
          appLocalizations?.translate('settings') ?? 'Settings',
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
          children: [
            // User Profile Card
            Container(
              padding: const EdgeInsets.all(16),
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
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFFFFE6EF),
                    child: const Icon(
                      Icons.person,
                      size: 30,
                      color: Color(0xFFE75480),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.isNotEmpty ? name : 'Loading...',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? 'user@example.com',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Settings Options
            _buildSettingsSection(
              context,
              title: appLocalizations?.translate('general') ?? 'General',
              children: [
                _buildSettingsItem(
                  icon: FontAwesomeIcons.language,
                  title: appLocalizations?.translate('language') ?? 'Language',
                  trailing: Text(
                    currentLocale == 'ta' ? 'தமிழ்' : 'English',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFE75480),
                    ),
                  ),
                  onTap: () {
                    _showLanguageDialog(context);
                  },
                ),
                _buildSettingsItem(
                  icon: FontAwesomeIcons.fileAlt,
                  title:
                  appLocalizations?.translate('terms') ?? 'Terms & Conditions',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  TermsConditionsPage()),
                    );
                  },
                ),
                _buildSettingsItem(
                  icon: FontAwesomeIcons.lock,
                  title:
                  appLocalizations?.translate('privacy') ?? 'Privacy Policy',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  PrivacyPolicyPage()),
                    );
                  },
                ),
                _buildSettingsItem(
                  icon: FontAwesomeIcons.questionCircle,
                  title:
                  appLocalizations?.translate('help') ?? 'Help & Support',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  HelpSupportPage()),
                    );
                  },
                ),
                _buildSettingsItem(
                  icon: FontAwesomeIcons.infoCircle,
                  title:
                  appLocalizations?.translate('appInfo') ?? 'App Information',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  AppInfoPage()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 30),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFE6EF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  _showLogoutConfirmation(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      FontAwesomeIcons.signOutAlt,
                      color: Color(0xFFE75480),
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      appLocalizations?.translate('logout') ?? 'Logout',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFE75480),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            appLocalizations?.translate('select_language') ?? 'Select Language',
            style: GoogleFonts.poppins(
              color: const Color(0xFFE75480),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.language, color: Color(0xFFE75480)),
                title: Text(
                  appLocalizations?.translate('english') ?? 'English',
                ),
                onTap: () {
                  localeProvider.setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language, color: Color(0xFFE75480)),
                title: Text(
                  appLocalizations?.translate('tamil') ?? 'தமிழ்',
                ),
                onTap: () {
                  localeProvider.setLocale(const Locale('ta'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsSection(
      BuildContext context, {
        required String title,
        required List<Widget> children,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: const Color(0xFFE75480),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
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
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: FaIcon(
        icon,
        color: const Color(0xFFE75480),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(),
      ),
      trailing: trailing ??
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
      onTap: onTap,
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            '${appLocalizations?.translate('logout') ?? 'Logout'}?',
            style: GoogleFonts.poppins(
              color: const Color(0xFFE75480),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            appLocalizations?.translate('logout_confirmation') ??
                'Are you sure you want to logout?',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              child: Text(
                appLocalizations?.translate('cancel') ?? 'Cancel',
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                appLocalizations?.translate('logout') ?? 'Logout',
                style: GoogleFonts.poppins(
                  color: const Color(0xFFE75480),
                ),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}