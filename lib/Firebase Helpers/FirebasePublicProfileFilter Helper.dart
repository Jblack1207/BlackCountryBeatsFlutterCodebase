import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseAuth Helper.dart';

class PublicProfileSearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> searchPublicProfiles({
    required String query,
    String? genre,
    int? profileType,
    int? minimumRating,
    double? maxPrice,
    int? maxMembers,
  }) async {
    final trimmedQuery = query.trim().toLowerCase();
    final currentUser = AuthService().getCurrentUser();
    final currentUserId = currentUser?.uid;

    final hasTextSearch = trimmedQuery.length >= 3;
    final hasFilters = genre != null ||
        profileType != null ||
        minimumRating != null ||
        maxPrice != null ||
        maxMembers != null;

    if (!hasTextSearch && !hasFilters) {
      return [];
    }

    Query<Map<String, dynamic>> firebaseQuery =
    _firestore.collection('publicProfiles');

    if (genre != null && genre.isNotEmpty) {
      firebaseQuery = firebaseQuery.where('genre', isEqualTo: genre);
    }

    if (profileType != null) {
      firebaseQuery = firebaseQuery.where('profileType', isEqualTo: profileType);
    }

    final snapshot = await firebaseQuery.get();

    return snapshot.docs
        .map((doc) => {
      'id': doc.id,
      ...doc.data(),
    })
        .where((profile) {
      final profileUserId = (profile['userId'] ?? '').toString();
      final isCurrentUser =
          currentUserId != null && profileUserId == currentUserId;

      final profileName =
      (profile['profileName'] ?? '').toString().toLowerCase();
      final matchesQuery =
          !hasTextSearch || profileName.contains(trimmedQuery);

      final rating = ((profile['rating'] ?? 0) as num).toDouble();
      final matchesRating =
          minimumRating == null || rating >= minimumRating;

      final avgPrice =
      ((profile['avgPricePerNight'] ?? 0) as num).toDouble();
      final matchesPrice = maxPrice == null || avgPrice <= maxPrice;

      final members = ((profile['memberCount'] ??
          profile['numberOfMembers'] ??
          0) as num)
          .toInt();
      final matchesMembers = maxMembers == null || members <= maxMembers;

      return !isCurrentUser &&
          matchesQuery &&
          matchesRating &&
          matchesPrice &&
          matchesMembers;
    })
        .toList();
  }
}
