import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseAuth Helper.dart';
import 'package:flutter_project_cmp3023/Pages/BlackCountryBeatsPublicProfileTypeStep.dart';
import 'BlackCountryBeatsMyPublicProfileViewPage.dart';

class BlackCountryBeatsPublicProfilePage extends StatefulWidget {
  const BlackCountryBeatsPublicProfilePage({super.key});

  @override
  State<BlackCountryBeatsPublicProfilePage> createState() =>
      _BlackCountryBeatsPublicProfilePageState();
}

class _BlackCountryBeatsPublicProfilePageState
    extends State<BlackCountryBeatsPublicProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> _getMyPublicProfile() async {
    final user = AuthService().getCurrentUser();
    if (user == null) return null;

    final snapshot = await _firestore
        .collection('publicProfiles')
        .where('userId', isEqualTo: user.uid)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QueryDocumentSnapshot<Map<String, dynamic>>?>(
      future: _getMyPublicProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF1F1F1F),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFF1F1F1F),
            body: Center(
              child: Text(
                'Failed to load profile: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        final profileDoc = snapshot.data;

        if (profileDoc == null) {
          return const Scaffold(
            backgroundColor: Color(0xFF1F1F1F),
            body: BlackCountryBeatsPublicProfileTypeStep(),
          );
        }

        return BlackCountryBeatsMyPublicProfileViewPage(
          profile: profileDoc.data(),
        );
      },
    );
  }
}
