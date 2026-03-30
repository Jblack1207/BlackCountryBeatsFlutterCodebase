import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Pages/BlackCountryBeatsLoginPage.dart';
import 'package:google_fonts/google_fonts.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print("Firebase Connected");
  runApp(const BlackCountryBeatsApp());
}

class BlackCountryBeatsApp extends StatelessWidget {
  const BlackCountryBeatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Black Country Beats',
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const BlackCountryBeatsLoginScreen(),
    );
  }
}
