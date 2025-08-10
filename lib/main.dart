// // lib/main.dart
// import 'package:allobaay/awarenesspost.dart';
// import 'package:allobaay/certificatepage.dart';
// // import 'package:allobaay/certificate.dart';
// import 'package:allobaay/chat.dart';
// import 'package:allobaay/chat_service.dart';
// import 'package:allobaay/doctorbenefit.dart';
// import 'package:allobaay/home.dart';
// import 'package:allobaay/login.dart';
// import 'package:allobaay/navigation.dart';
// import 'package:allobaay/navigation1.dart';
// import 'package:allobaay/pregnancy.dart';
// import 'package:allobaay/pregnancydate.dart';
// import 'package:allobaay/services_page.dart';
// import 'package:allobaay/settings.dart';
// import 'package:allobaay/signup.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:provider/provider.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//   runApp(MyApp());
// }
//
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//
//   Widget _getHomeScreen() {
//     User? user = FirebaseAuth.instance.currentUser;
//
//     if (user != null) {
//       // Check if the email is the admin's email
//       if (user.email == "doctor001@gmail.com") {
//         return MainNavigation1(); // Admin panel
//       } else {
//         return MainNavigation(); // Regular user panel
//       }
//     } else {
//       return LoginPage(); // If no user is logged in
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//         return MultiProvider(
//       providers: [
//         // ChangeNotifierProvider(create: (_) => AuthService()),
//         ChangeNotifierProvider(create: (_) => ChatService()),
//       ],
//       child: MaterialApp(
//       title: 'Pregnancy Monitoring',
//       theme: ThemeData(
//         primarySwatch: Colors.pink,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: _getHomeScreen(),
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }



// lib/main.dart
import 'package:allobaay/awarenesspost.dart';
import 'package:allobaay/certificatepage.dart';
import 'package:allobaay/chat.dart';
import 'package:allobaay/chat_service.dart';
import 'package:allobaay/doctorbenefit.dart';
import 'package:allobaay/home.dart';
import 'package:allobaay/login.dart';
import 'package:allobaay/navigation.dart';
import 'package:allobaay/navigation1.dart';
import 'package:allobaay/pregnancy.dart';
import 'package:allobaay/pregnancydate.dart';
import 'package:allobaay/services_page.dart';
import 'package:allobaay/settings.dart';
import 'package:allobaay/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localization.dart';
// import 'localization.dart'; // Import the LocaleProvider
import 'local_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _getHomeScreen() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Check if the email is the admin's email
      if (user.email == "doctor001@gmail.com") {
        return MainNavigation1(); // Admin panel
      } else {
        return MainNavigation(); // Regular user panel
      }
    } else {
      return const LoginPage(); // If no user is logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatService()),
      ],
      child: MaterialApp(
        title: 'Pregnancy Monitoring',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        locale: localeProvider.locale, // Use the provider's locale
        supportedLocales: const [
          Locale('en', ''),
          Locale('ta', ''),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        home: _getHomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}




























//
//
// import 'package:allobaay/awarenesspost.dart';
// import 'package:allobaay/certificatepage.dart';
// import 'package:allobaay/chat.dart';
// import 'package:allobaay/chat_service.dart';
// import 'package:allobaay/doctorbenefit.dart';
// import 'package:allobaay/home.dart';
// import 'package:allobaay/login.dart';
// import 'package:allobaay/navigation.dart';
// import 'package:allobaay/navigation1.dart';
// import 'package:allobaay/pregnancy.dart';
// import 'package:allobaay/pregnancydate.dart';
// import 'package:allobaay/services_page.dart';
// import 'package:allobaay/settings.dart';
// import 'package:allobaay/signup.dart';
// import 'package:allobaay/language_service.dart'; // Add this import
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:provider/provider.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => LanguageService()),
//         ChangeNotifierProvider(create: (_) => ChatService()),
//       ],
//       child: MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   Widget _getHomeScreen() {
//     User? user = FirebaseAuth.instance.currentUser;
//
//     if (user != null) {
//       if (user.email == "doctor001@gmail.com") {
//         return MainNavigation1(); // Admin panel
//       } else {
//         return MainNavigation(); // Regular user panel
//       }
//     } else {
//       return LoginPage(); // If no user is logged in
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<LanguageService>(
//       builder: (context, languageService, child) {
//         return MaterialApp(
//           title: 'Pregnancy Monitoring',
//           theme: ThemeData(
//             primarySwatch: Colors.pink,
//             visualDensity: VisualDensity.adaptivePlatformDensity,
//           ),
//           locale: languageService.locale,
//           supportedLocales: [
//             const Locale('en', ''), // English
//             const Locale('ta', ''), // Tamil
//           ],
//           home: _getHomeScreen(),
//           debugShowCheckedModeBanner: false,
//         );
//       },
//     );
//   }
// }
//
//





















//
// // main.dart
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';
// import 'auth_service.dart';
// import 'chat_service.dart';
// import 'screens/auth_screen.dart';
// import 'screens/doctor_home.dart';
// import 'screens/patient_home.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthService()),
//         ChangeNotifierProvider(create: (_) => ChatService()),
//       ],
//       child: MaterialApp(
//         title: 'Doctor-Patient Chat',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//         ),
//         home: AuthWrapper(),
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }
//
// class AuthWrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final authService = Provider.of<AuthService>(context);
//
//     if (authService.user == null) {
//       return AuthScreen();
//     } else {
//       // Check if user is doctor or patient
//       return FutureBuilder(
//         future: authService.isDoctor(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return snapshot.data == true ? DoctorHomeScreen() : PatientHomeScreen();
//           }
//           return Scaffold(body: Center(child: CircularProgressIndicator()));
//         },
//       );
//     }
//   }
// }
//



































































// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'localization.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   Locale _locale = Locale('en');
//
//   @override
//   void initState() {
//     super.initState();
//     _loadLocale();
//   }
//
//   Future<void> _loadLocale() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? languageCode = prefs.getString('language_code');
//     if (languageCode != null) {
//       setState(() {
//         _locale = Locale(languageCode);
//       });
//     }
//   }
//
//   void _setLocale(Locale locale) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('language_code', locale.languageCode);
//     setState(() {
//       _locale = locale;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       locale: _locale,
//       supportedLocales: [
//         Locale('en', ''),
//         Locale('ta', ''),
//       ],
//       localizationsDelegates: [
//         AppLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       home: HomeScreen(onLocaleChange: _setLocale),
//     );
//   }
// }
//
// class HomeScreen extends StatelessWidget {
//   final Function(Locale) onLocaleChange;
//
//   HomeScreen({required this.onLocaleChange});
//
//   @override
//   Widget build(BuildContext context) {
//     final localizations = AppLocalizations.of(context)!;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(localizations.translate('app_title')),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               localizations.translate('welcome_message'),
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             Text(localizations.translate('select_language')),
//             DropdownButton<Locale>(
//               value: Localizations.localeOf(context),
//               items: [
//                 DropdownMenuItem(
//                   value: Locale('en'),
//                   child: Text(localizations.translate('english')),
//                 ),
//                 DropdownMenuItem(
//                   value: Locale('ta'),
//                   child: Text(localizations.translate('tamil')),
//                 ),
//               ],
//               onChanged: (Locale? newValue) {
//                 if (newValue != null) {
//                   onLocaleChange(newValue);
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
