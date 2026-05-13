import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FollowingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getFollowingProfilesStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    final currentUserId = user.uid;
    final controller = StreamController<List<Map<String, dynamic>>>.broadcast();

    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? followingSub;
    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? profilesSub;

    Future<void> emitProfiles() async {
      await profilesSub?.cancel();

      final currentUserSnapshot = await _firestore
          .collection('publicProfiles')
          .where('userId', isEqualTo: currentUserId)
          .limit(1)
          .get();

      final currentUserDoc =
      currentUserSnapshot.docs.isNotEmpty ? currentUserSnapshot.docs.first : null;

      final followingSnapshot = await _firestore
          .collection('followingLinks')
          .where('userId', isEqualTo: currentUserId)
          .get();

      final followedIds = followingSnapshot.docs
          .map((doc) => doc.data()['followingUserId']?.toString())
          .whereType<String>()
          .toSet()
          .toList();

      final idsToWatch = <String>[
        if (currentUserDoc != null) currentUserDoc.id,
        ...followedIds.where((id) => currentUserDoc == null || id != currentUserDoc.id),
      ];

      if (idsToWatch.isEmpty) {
        controller.add([]);
        return;
      }

      profilesSub = _firestore
          .collection('publicProfiles')
          .where(FieldPath.documentId, whereIn: idsToWatch)
          .snapshots()
          .listen((profilesSnapshot) {
        final docsById = {
          for (final doc in profilesSnapshot.docs) doc.id: doc.data(),
        };

        final orderedProfiles = <Map<String, dynamic>>[];

        for (final id in idsToWatch) {
          final data = docsById[id];
          if (data != null) {
            orderedProfiles.add({
              'id': id,
              ...data,
            });
          }
        }

        controller.add(orderedProfiles);
      });
    }

    followingSub = _firestore
        .collection('followingLinks')
        .where('userId', isEqualTo: currentUserId)
        .snapshots()
        .listen((_) async {
      await emitProfiles();
    });

    emitProfiles();

    controller.onCancel = () async {
      await followingSub?.cancel();
      await profilesSub?.cancel();
    };

    return controller.stream;
  }
}
