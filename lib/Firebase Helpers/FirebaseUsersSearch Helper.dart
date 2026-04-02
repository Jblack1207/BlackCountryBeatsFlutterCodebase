import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> searchProfiles(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty || trimmedQuery.length < 3) {
      return [];
    }

    if (trimmedQuery.length > 2) {
      try {
        print('Searching for: $trimmedQuery');

        final snapshot = await _firestore
            .collection('publicProfiles')
            .where('profileName', isGreaterThanOrEqualTo: trimmedQuery)
            .where('profileName', isLessThanOrEqualTo: '$trimmedQuery\uf8ff')
            .get();

        print('Results found: ${snapshot.docs.length}');

        return snapshot.docs.map((doc) {
          print('Doc: ${doc.data()}');
          return {
            'id': doc.id,
            ...doc.data(),
          };
        }).toList();
      } catch (e, st) {
        print('searchProfiles error: $e');
        print(st);
        rethrow;
      }
    }; return [];
  }
}
