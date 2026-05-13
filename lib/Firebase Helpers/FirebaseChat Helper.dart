import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getOrCreateChat({
    required String currentUserId,
    required String otherUserId,
    required String currentUserProfileId,
    required String otherUserProfileId,
  }) async {
    final snapshot = await _firestore
        .collection('chats')
        .where('members', arrayContains: currentUserId)
        .get();

    for (final doc in snapshot.docs) {
      final members = List<String>.from(doc['members'] ?? []);
      if (members.contains(otherUserId) && members.length == 2) {
        return doc.id;
      }
    }

    final chatDoc = await _firestore.collection('chats').add({
      'members': [currentUserId, otherUserId],
      'memberProfileIds': [currentUserProfileId, otherUserProfileId],
      'lastMessage': '',
      'lastMessageAt': FieldValue.serverTimestamp(),
      'lastSenderId': '',
    });

    return chatDoc.id;
  }

  Future<void> persistMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    await _firestore.collection('chats').doc(chatId).collection('messages').add({
      'senderId': senderId,
      'text': text,
      'sentAt': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': text,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'lastSenderId': senderId,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> chatMessagesStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> messageHomeStream(String userId) {
    return _firestore
        .collection('chats')
        .where('members', arrayContains: userId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots();
  }
}
