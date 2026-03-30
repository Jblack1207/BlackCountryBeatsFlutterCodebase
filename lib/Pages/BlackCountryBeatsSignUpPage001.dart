// sign_UpPage1.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_project_cmp3023/Pages/BlackCountryBeatsLoginPage.dart';
import 'package:flutter_project_cmp3023/Pages/BlackCountryBeatsSignUpPage002.dart';


class BlackCountryBeatsSignUpPage001 extends StatefulWidget {
  const BlackCountryBeatsSignUpPage001({super.key});


  @override
  State<BlackCountryBeatsSignUpPage001> createState() =>
      _BlackCountryBeatsSignUpPage001State();
}

class _BlackCountryBeatsSignUpPage001State
    extends State<BlackCountryBeatsSignUpPage001> {

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressLine01Controller= TextEditingController();
  final TextEditingController _addressLine02Controller = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _countyController = TextEditingController();

  bool get _isNextEnabled {
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final addressLine01 = _addressLine01Controller.text;
    final addressLine02 = _addressLine02Controller.text;
    final postCode = _postCodeController.text;
    final county = _countyController.text;
    final postcodeRegex = RegExp(r'^([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([AZa-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9]?[A-Za-z]))))[0-9][A-Za-z]{2})$');

    return firstName.isNotEmpty && lastName.isNotEmpty && addressLine01.isNotEmpty && addressLine02.isNotEmpty && postcodeRegex.hasMatch(postCode)  && county.isNotEmpty;
  }

  //dispose method, prevents memory leakage
  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressLine01Controller.dispose();
    _addressLine02Controller.dispose();
    _postCodeController.dispose();
    _countyController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final bool isEnabled = _isNextEnabled;


    //controls keyboard height and when Log In panel height when keyboard is open or not
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final panelTop = keyboardHeight > 0 ? 80.0 : 220.0;

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
                padding: const EdgeInsets.only(top: 36),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                // Logo image for Login Page
                  child: Image.asset(
                    'assets/images/BCBLogoHP.png',
                    width: 180,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // controls position of Log In Component, moves up and down depending on keyboard display = true or false
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastEaseInToSlowEaseOut,
              left: 0,
              right: 0,
              bottom: 0,
              top: panelTop,

              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xff27272A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45),
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 16,
                      spreadRadius: 2,
                      offset: Offset(0, -6), // shadow control
                    ),
                  ],
                ),



                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  //controls width and height of objects within the lifted tab (i.e Log In, Email)
                  padding: EdgeInsets.fromLTRB(40, 22, 40, MediaQuery.of(context).viewInsets.bottom+24),

                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // first name inpit controller
                            SizedBox(
                              width: 300,
                              child: TextField(
                                controller: _firstNameController,
                                onChanged: (_) => setState(() {}),
                                style: const TextStyle(color: Colors.white, height: 1.2),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                                hintText: 'First Name',
                                hintStyle: const TextStyle(color: Colors.white60, fontWeight: FontWeight.w500),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(color: Colors.white, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            //last name input controller
                            const SizedBox(height: 18),
                            SizedBox(
                              width: 300,
                              child: TextField(
                                controller: _lastNameController,
                                onChanged: (_) => setState(() {}),
                                style: const TextStyle(color: Colors.white, height: 1.2),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  hintText: 'Last Name',
                                  hintStyle: const TextStyle(color: Colors.white60, fontWeight: FontWeight.w500),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(color: Colors.white, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                        //address line 01 input controller
                        const SizedBox(height: 18),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _addressLine01Controller,
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(color: Colors.white, height: 1.2),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.home,
                                color: Colors.white,
                              ),
                              hintText: 'First Line of Address',
                              hintStyle: const TextStyle(color: Colors.white60, fontWeight: FontWeight.w500),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(color: Colors.white, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),

                        //address line 02 controller
                        const SizedBox(height: 18),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _addressLine02Controller,
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(color: Colors.white, height: 1.2),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.home,
                                color: Colors.white,
                              ),
                              hintText: 'Second Line of Address',
                              hintStyle: const TextStyle(color: Colors.white60, fontWeight: FontWeight.w500),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(color: Colors.white, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        //row for postcode and county

                        Row(
                          children: [
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _postCodeController,
                                onChanged: (_) => setState(() {}),
                                style: const TextStyle(color: Colors.white, height: 1.2),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.pin_drop,
                                    color: Colors.white,
                                  ),
                                  hintText: 'Postcode',
                                  hintStyle: const TextStyle(color: Colors.white60, fontWeight: FontWeight.w500),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(color: Colors.white, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 15),

                            //county controller
                            Expanded(
                              child: TextField(
                                controller: _countyController,
                                onChanged: (_) => setState(() {}),
                                style: const TextStyle(color: Colors.white, height: 1.2),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.location_city,
                                    color: Colors.white,
                                  ),
                                  hintText: 'County',
                                  hintStyle: const TextStyle(color: Colors.white60, fontWeight: FontWeight.w500),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(color: Colors.white, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),


                        //Login Button design
                        const SizedBox(height: 22),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: SizedBox(
                              width: 200,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: isEnabled ? (){
                                  // handle next page nav
                                  //print(_firstNameController.text);
                                  //print(_firstNameController.text.runtimeType);

                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => BlackCountryBeatsSignUpPage002(
                                          firstName: _firstNameController.text.trim(),
                                          lastName: _lastNameController.text.trim(),
                                          addressLine01: _addressLine01Controller.text.trim(),
                                          addressLine02: _addressLine02Controller.text.trim(),
                                          postcode: _postCodeController.text.trim(),
                                          county: _countyController.text.trim()
                                        ),
                                      )
                                  );
                                }: null,
                                style: ElevatedButton.styleFrom(
                                  //enabled colouring
                                  backgroundColor: const Color(0xffffc21c).withOpacity(0.95),
                                  foregroundColor: Colors.black,
                                  //disabled colouring
                                  disabledBackgroundColor: const Color(0xffffc21c).withOpacity(0.2),
                                  disabledForegroundColor: Colors.black54,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(
                                      color: Colors.white24,
                                      width: isEnabled ? 3 : 0,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Continue',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        //sign up text
                        const SizedBox(height: 16),

                        Align(
                          alignment: Alignment.center,
                          child: const Text(
                            "Already have an account?",
                            style: TextStyle(
                              color: Color(0xffB3B3B5),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        //sign up text access link
                        const SizedBox(height: 4),

                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              //handle return to log in page
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => const BlackCountryBeatsLoginScreen(),
                                  )
                              );                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                  color: Color(0xffB3B3B5),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                  decorationThickness: 2
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}