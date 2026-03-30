//BCB Homepage
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';



class BlackCountryBeatsHomePage extends StatefulWidget {
  const BlackCountryBeatsHomePage({super.key});


  @override
  State<BlackCountryBeatsHomePage> createState() =>
      _BlackCountryBeatsHomePageState();
}


///class state definitions and logic control
class _BlackCountryBeatsHomePageState
    extends State<BlackCountryBeatsHomePage> {



  //dispose method, prevents memory leakage
  @override
  void dispose() {
    super.dispose();
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
                  width: 220,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 110, left: 20),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.person_pin_circle,
                        color: Colors.white,
                        size: 35,
                  ),
                      const SizedBox(width: 20),
                      Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
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