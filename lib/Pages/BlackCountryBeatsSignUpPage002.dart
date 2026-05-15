// sign_UpPage2.dart
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_cmp3023/Pages/BlackCountryBeatsLoginPage.dart';
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseAuth Helper.dart';

class BlackCountryBeatsSignUpPage002 extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String addressLine01;
  final String addressLine02;
  final String postcode;
  final String county;
  const BlackCountryBeatsSignUpPage002({super.key,
    required this.firstName,
    required this.lastName,
    required this.addressLine01,
    required this.addressLine02,
    required this.postcode,
    required this.county
  });


  @override
  State<BlackCountryBeatsSignUpPage002> createState() =>
      _BlackCountryBeatsSignUpPage002State();
}

class _BlackCountryBeatsSignUpPage002State
    extends State<BlackCountryBeatsSignUpPage002> {

  bool _obscurePassword = true;
  bool _obscureConPassword = true;



  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController= TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');



  bool get _isNextEnabled {
    final userName = _userNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    return userName.isNotEmpty && emailRegex.hasMatch(email) && password.isNotEmpty && confirmPassword.isNotEmpty && password == confirmPassword;
  }

  //dispose method, prevents memory leakage
  @override
  void dispose() {
    super.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final bool isEnabled = _isNextEnabled;


    //controls keyboard height and when Log In panel height when keyboard is open or not
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final panelTop = keyboardHeight > 0 ? 80.0 : 290.0;

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

                        // username inpit controller
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _userNameController,
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(color: Colors.white, height: 1.2),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.verified_user,
                                color: Colors.white,
                              ),
                              hintText: 'Username',
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

                        //email input controller
                        const SizedBox(height: 18),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(color: Colors.white, height: 1.2),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Colors.white,
                              ),
                              hintText: 'Email',
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

                        //password 01 input controller
                        const SizedBox(height: 18),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(color: Colors.white, height: 1.2),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.password,
                                color: Colors.white,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              hintText: 'Password',
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

                        //password 02 controller
                        const SizedBox(height: 18),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConPassword,
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(color: Colors.white, height: 1.2),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.password_outlined,
                                color: Colors.white,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConPassword = !_obscureConPassword;
                                  });
                                },
                              ),
                              hintText: 'Confirm Password',
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



                        //next Button design
                        const SizedBox(height: 22),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: SizedBox(
                              width: 200,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: isEnabled ? () async{
                                  // handle login
                                  try{
                                    await AuthService().registerUser(
                                        email: _emailController.text.trim(),
                                        userName: _userNameController.text.trim(),
                                        password: _passwordController.text.trim(),
                                        firstName: widget.firstName,
                                        lastName: widget.lastName,
                                        addressLine01: widget.addressLine01,
                                        addressLine02: widget.addressLine02,
                                        postcode: widget.postcode,
                                        county: widget.county
                                    );
                                    //Navigate back to login if account creation is successful
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const BlackCountryBeatsLoginScreen()
                                        ),
                                    );
                                  } on FirebaseAuthException catch (e){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Registration failed')),
                                    );
                                  } catch (e, st) {
                                    debugPrint('Unexpected error: $e');
                                    debugPrintStack(stackTrace: st);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Unexpected error: $e')),
                                    );
                                  }
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
                                  'Create Account',
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

                        //back button text
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: TextButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Color(0xffB3B3B5),
                                  size: 14,
                                ),
                                label: const Text(
                                  'Back',
                                  style: TextStyle(
                                    color: Color(0xffB3B3B5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ),
                            const SizedBox(width: 22),
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
                          ],
                        ),

                        //log in text access link
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