import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlackCountryBeatsUserProfilePage extends StatelessWidget {
  final String userId;

  const BlackCountryBeatsUserProfilePage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1F1F1F),
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('publicProfiles')
              .doc(userId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
              return const Center(
                child: Text(
                  'Failed to load profile',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final user = snapshot.data!.data()!;

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if ((user['profileImage'] ?? '').toString().isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        user['profileImage'],
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    user['profileName'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user['Bio'] ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Genre: ${user['genre'] ?? ''}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Location: ${user['location'] ?? ''}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Rating: ${user['rating'] ?? ''}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Followers: ${user['followerCount'] ?? ''}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
