// login_screen.dart
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_cmp3023/Firebase%20Helpers/FirebaseAuth%20Helper.dart';
import 'package:flutter_project_cmp3023/Pages/BlackCountryBeatsSignUpPage001.dart';
import 'package:flutter_project_cmp3023/Pages/BlackCountryBeatsShellPage.dart';



class BlackCountryBeatsLoginScreen extends StatefulWidget {
  const BlackCountryBeatsLoginScreen({super.key});


  @override
  State<BlackCountryBeatsLoginScreen> createState() =>
      _BlackCountryBeatsLoginScreenState();
}


///class state definitions and logic control
class _BlackCountryBeatsLoginScreenState
    extends State<BlackCountryBeatsLoginScreen> {
  bool _obscurePassword = true;
  bool _emailError = false;
  bool _passwordError = false;


  //email and password validation for enabling log in button
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool get _isLoginEnabled {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

    return emailRegex.hasMatch(email) && password.isNotEmpty;
  }


  //dispose method, prevents memory leakage
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }



  //external login button Widget
  Widget _socialLogoButton({
    required String assetPath,
    required Color backgroundColor,
    VoidCallback? onPressed,
    Color? borderColor,
  }) {
    return SizedBox(
      width: 70,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(
              color: borderColor ?? backgroundColor,
              width: 2,
            ),
          ),
        ),
        child: Image.asset(
          assetPath,
          width: 150,
          height: 150,
        ),
      ),
    );
  }


///beginning of visuals

  @override
  Widget build(BuildContext context) {

    //setting isEnabled to _isLoginEnabled
    final bool isEnabled = _isLoginEnabled;

    //controls keyboard height and when Log In panel height when keyboard is open or not
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final panelTop = keyboardHeight > 0 ? 170.0 : 330.0;

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
                // Logo image for Login Page
                child: Image.asset(
                  'assets/images/BCBLogoHP.png',
                  width: 180,
                  fit: BoxFit.contain,
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
                          'Welcome',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Email input
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,


                          onChanged: (_) => setState(() {_emailError = false;}),

                          style: const TextStyle(color: Colors.white, height: 1.2),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.alternate_email,
                              color: Colors.white,
                            ),
                            hintText: 'Email',
                            hintStyle: const TextStyle(color: Colors.white60, fontWeight: FontWeight.w500),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  color: _emailError ? Colors.red : Colors.white,
                                  width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: _emailError ? Colors.red : Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ),

                        //Password Designs
                        const SizedBox(height: 16),

                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,

                          onChanged: (_) => setState(() {_passwordError = false;}),
                          keyboardType: TextInputType.text,

                          style: const TextStyle(color: Colors.white, height: 1.2),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock_open_sharp,
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
                              borderSide: BorderSide(color: _passwordError ? Colors.red : Colors.white, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: _passwordError ? Colors.red : Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
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
                                onPressed: _isLoginEnabled
                                    ? () async {
                                  try {
                                    await AuthService().loginUser(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text,
                                    );

                                    setState(() {
                                      _emailError = false;
                                      _passwordError = false;
                                    });

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const BlackCountryBeatsShellPage(initialIndex: 0),
                                      ),
                                    );
                                  } on FirebaseAuthException catch (e) {
                                    setState(() {
                                      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
                                        _emailError = true;
                                        _passwordError = false;
                                      } else if (e.code == 'wrong-password' ||
                                          e.code == 'invalid-credential') {
                                        _emailError = true;
                                        _passwordError = true;
                                      } else {
                                        _emailError = true;
                                        _passwordError = true;
                                      }
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.message ?? 'Login failed')),
                                    );
                                  } catch (e) {
                                    setState(() {
                                      _emailError = true;
                                      _passwordError = true;
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Unexpected error: $e')),
                                    );
                                  }
                                }
                                    : null,


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
                                  'Log In',
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

                        //forgot password text and handling
                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              // handle forgot password
                              AuthService().validateUserAuth();
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Forgot password?',
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

                        //ext login buttons and handling
                        const SizedBox(height: 18),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _socialLogoButton(
                              assetPath: 'assets/images/image8.png',
                              backgroundColor: const Color(0xcc27272A),
                              borderColor: const Color (0xFF394046),
                              onPressed: () async {
                                await AuthService().signInWithGoogle();
                              },
                            ),
                            const SizedBox(width: 24),
                            _socialLogoButton(
                              assetPath: 'assets/images/image9.png',
                              backgroundColor: const Color(0xcc27272A),
                              borderColor: const Color (0xFF394046),
                              onPressed: () {
                                // fb sign in
                              },
                            ),
                            const SizedBox(width: 24),
                            _socialLogoButton(
                              assetPath: 'assets/images/image7.png' ,
                              backgroundColor: const Color(0xcc27272A),
                              borderColor: const Color (0xFF394046),
                              onPressed: () {
                                // apple sign in
                              },
                            ),
                          ],
                        ),

                        //sign up text
                        const SizedBox(height: 14),

                        Align(
                          alignment: Alignment.center,
                            child: const Text(
                              "Don't have an Account?",
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
                              // handle sign up page nav
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => const BlackCountryBeatsSignUpPage001(),
                                  )
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Sign Up',
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
