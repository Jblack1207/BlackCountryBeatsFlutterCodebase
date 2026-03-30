import 'package:cloud_firestore/cloud_firestore.dart';

class NewsItem {
  final String id;
  final String newsTitle;
  final String newsDescription;
  final String newsImage;
  final bool isPublished;

  NewsItem({
    required this.id,
    required this.newsTitle,
    required this.newsDescription,
    required this.newsImage,
    required this.isPublished,
  });

  factory NewsItem.fromMap(String id, Map<String, dynamic> map) {
    return NewsItem(
      id: id,
      newsTitle: map['title'] ?? '',
      newsDescription: map['desc'] ?? '',
      newsImage: map['imageUrl'] ?? '',
      isPublished: map['isPublished'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': newsTitle,
      'body': newsDescription,
      'imageUrl': newsImage,
      'isPublished': isPublished,
    };
  }
}

class NewsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<NewsItem>> getPublishedNews() async {
    final snapshot = await _firestore
        .collection('news')
        .where('isPublished', isEqualTo: true)
        .orderBy('publishedAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return NewsItem.fromMap(doc.id, doc.data());
    }).toList();
  }
}
