//BCB Homepage
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseAuth Helper.dart';



class BlackCountryBeatsHomePage extends StatefulWidget {
  const BlackCountryBeatsHomePage({super.key});


  @override
  State<BlackCountryBeatsHomePage> createState() =>
      _BlackCountryBeatsHomePageState();
}


///class state definitions and logic control
class _BlackCountryBeatsHomePageState
    extends State<BlackCountryBeatsHomePage> {
  String? firstName;


  Future<void> _loadFirstName() async {
    final name = await AuthService().getCurrentUserFirstName();

    setState(() {
      firstName = name;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFirstName();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1F1F1F),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false, // controls bottom padding globally
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 18),
                // Logo image for Login Page
                child: SvgPicture.asset(
                  'assets/images/BCBLongLogo.svg',
                  width: 230,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 110, left: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: 45,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              firstName == null ? 'Welcome' : 'Welcome, $firstName',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(width: 165),
                            const Icon(
                              Icons.notifications,
                              color: Colors.white,
                              size: 40,
                            ),
                          ]
                      ),
                      const SizedBox(height: 35),
                      Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 10),
                            Text(
                              'Latest News',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ]
                      ),
                    ]
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}