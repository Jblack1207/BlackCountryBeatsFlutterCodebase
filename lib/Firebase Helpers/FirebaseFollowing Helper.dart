import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FollowingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> getFollowingProfiles() async {
    final user = _auth.currentUser;
    if (user == null) {
      return [];
    }

    final currentUserId = user.uid;
    final List<Map<String, dynamic>> profiles = [];

    final currentUserSnapshot = await _firestore
        .collection('publicProfiles')
        .where('userId', isEqualTo: currentUserId)
        .limit(1)
        .get();

    if (currentUserSnapshot.docs.isNotEmpty) {
      final currentUserDoc = currentUserSnapshot.docs.first;
      profiles.add({
        'id': currentUserDoc.id,
        ...currentUserDoc.data(),
      });
    }

    final followingSnapshot = await _firestore
        .collection('followingLinks')
        .where('userId', isEqualTo: currentUserId)
        .get();

    final followedUserIds = followingSnapshot.docs
        .map((doc) => doc.data()['followingUserId']?.toString())
        .whereType<String>()
        .toSet()
        .toList();

    for (final followedUserId in followedUserIds) {
      if (profiles.any((profile) => profile['id'] == followedUserId)) {
        continue;
      }

      final followedDoc =
      await _firestore.collection('publicProfiles').doc(followedUserId).get();

      if (followedDoc.exists && followedDoc.data() != null) {
        profiles.add({
          'id': followedDoc.id,
          ...followedDoc.data()!,
        });
      }
    }

    return profiles;
  }
}
