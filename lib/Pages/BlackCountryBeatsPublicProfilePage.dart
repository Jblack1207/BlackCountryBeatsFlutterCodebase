import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseAuth Helper.dart';
import 'package:flutter_project_cmp3023/Pages/BlackCountryBeatsMyPublicProfileViewPage.dart';
import 'package:flutter_project_cmp3023/Pages/BlackCountryBeatsPublicProfileTypeStep.dart';

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
    const double topSectionHeight = 120;

    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: topSectionHeight,
                padding: EdgeInsets.fromLTRB(
                  16,
                  MediaQuery.of(context).padding.top + 8,
                  16,
                  12,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF27272A),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Create Public Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
                top: topSectionHeight - 8,
                child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 130),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<QueryDocumentSnapshot<Map<String, dynamic>>?>(
                            future: _getMyPublicProfile(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    'Failed to load profile: ${snapshot.error}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }

                              final profileDoc = snapshot.data;

                              if (profileDoc == null) {
                                return const BlackCountryBeatsPublicProfileTypeStep();
                              }

                              return BlackCountryBeatsMyPublicProfileViewPage(
                                profile: profileDoc.data(),
                              );
                            },
                          ),
                        ]
                    )
                )
            )
          ]
      ),
    );
  }
}
