import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Pages/BlackCountryBeatsLoginPage.dart';
import '../Helpers/PresenceHelper.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final PresenceHelper _presenceService = PresenceHelper();

  Future<void> registerUser({
    required String email,
    required String userName,
    required String password,
    required String firstName,
    required String lastName,
    required String addressLine01,
    required String addressLine02,
    required String postcode,
    required String county,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    final uid = user!.uid;

    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'username': userName,
      'addressLine01': addressLine01,
      'addressLine02': addressLine02,
      'postcode': postcode,
      'county': county,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await user.sendEmailVerification();

    await _auth.signOut();
  }


  Future<void> validateUserAuth() async {
    print(_auth.currentUser?.uid);
    print(_auth.currentUser?.email);
  }

  Future<String?> getCurrentUserFirstName() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    final firstName = doc.data()?['firstName'] as String?;
    if (firstName == null || firstName.length > 10) return null;

    return firstName;
  }

  Future<UserCredential?> loginUser({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await credential.user?.reload();

    return credential;
  }


  Future<void> logoutUser(BuildContext context) async {
    await _presenceService.setOnline(false);

    try {
      await _googleSignIn.signOut();
    } catch (_) {}

    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) =>
        const BlackCountryBeatsLoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          );

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
          (route) => false,
    );
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> setUserOnlineStatus(bool isOnline) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('publicProfiles')
        .where('userId', isEqualTo: user.uid)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      await snapshot.docs.first.reference.update({
        'isOnline': isOnline,
      });
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    print('Google sign-in started');

    await _googleSignIn.initialize();
    print('GoogleSignIn initialized');

    final GoogleSignInAccount googleUser =
    await _googleSignIn.authenticate();
    print('Google user authenticated: ${googleUser.email}');

    final GoogleSignInAuthentication googleAuth =
        googleUser.authentication;
    print('Google auth token received');

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    print('Firebase credential sign-in complete: ${userCredential.user?.uid}');

    return userCredential;
  }
}
