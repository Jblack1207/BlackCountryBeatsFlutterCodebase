import 'package:cloud_firestore/cloud_firestore.dart';

class NewsItem {
  final String id;
  final String newsTitle;
  final String newsDescription;
  final String newsImage;
  final bool isPublished;
  final int order;

  NewsItem({
    required this.id,
    required this.newsTitle,
    required this.newsDescription,
    required this.newsImage,
    required this.isPublished,
    required this.order
  });

  factory NewsItem.fromMap(String id, Map<String, dynamic> map) {

    print('Creating NeswsItem from map: $map');

    return NewsItem(
      id: id,
      newsTitle: map['newsTitle'] ?? '',
      newsDescription: map['newsDescription'] ?? '',
      newsImage: map['newsImage'] ?? '',
      isPublished: map['isPublished'] ?? false,
      order: map['order']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': newsTitle,
      'body': newsDescription,
      'imageUrl': newsImage,
      'isPublished': isPublished,
      'order': order
    };
  }
}

class NewsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<NewsItem>> getPublishedNews() async {
    try {
      final snapshot = await _firestore
          .collection('news')
          .where('isPublished', isEqualTo: true)
          .orderBy('order', descending: true)
          .get();

      print('Query completed');
      print('Documents found: ${snapshot.docs.length}');

      for (final doc in snapshot.docs) {
        print('Doc ID: ${doc.id}');
        print('Doc Data: ${doc.data()}');
      }

      final newsList = snapshot.docs.map((doc) {
        print('Mapping doc: ${doc.id}');
        return NewsItem.fromMap(doc.id, doc.data());
      }).toList();

      print('Mapped NewsItem count: ${newsList.length}');
      return newsList;
    } catch (e, st) {
      print('Error in getPublishedNews(): $e');
      print(st);
      rethrow;
    }
  }
}