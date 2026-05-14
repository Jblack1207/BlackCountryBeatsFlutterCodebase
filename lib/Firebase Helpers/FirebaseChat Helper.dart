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
      'unreadCounts': {
        currentUserId: 0,
        otherUserId: 0,
      },
    });

    return chatDoc.id;
  }

  Future<void> persistMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    final chatRef = _firestore.collection('chats').doc(chatId);
    final chatSnapshot = await chatRef.get();

    if (!chatSnapshot.exists) return;

    final chatData = chatSnapshot.data()!;
    final members = List<String>.from(chatData['members'] ?? []);
    final unreadCounts = Map<String, dynamic>.from(chatData['unreadCounts'] ?? {});

    final recipientId = members.firstWhere(
          (id) => id != senderId,
      orElse: () => '',
    );

    await chatRef.collection('messages').add({
      'senderId': senderId,
      'text': text,
      'sentAt': FieldValue.serverTimestamp(),
      'readBy': [senderId],
    });

    final updatedUnreadCounts = <String, dynamic>{
      ...unreadCounts,
      senderId: 0,
    };

    if (recipientId.isNotEmpty) {
      updatedUnreadCounts[recipientId] =
          ((unreadCounts[recipientId] ?? 0) as num).toInt() + 1;
    }

    await chatRef.update({
      'lastMessage': text,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'lastSenderId': senderId,
      'unreadCounts': updatedUnreadCounts,
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

  Future<void> markChatAsRead({
    required String chatId,
    required String currentUserId,
  }) async {
    final chatRef = _firestore.collection('chats').doc(chatId);

    await chatRef.update({
      'unreadCounts.$currentUserId': 0,
    });

    final unreadMessages = await chatRef
        .collection('messages')
        .where('senderId', isNotEqualTo: currentUserId)
        .get();

    for (final doc in unreadMessages.docs) {
      final data = doc.data();
      final readBy = List<String>.from(data['readBy'] ?? []);

      if (!readBy.contains(currentUserId)) {
        await doc.reference.update({
          'readBy': FieldValue.arrayUnion([currentUserId]),
        });
      }
    }
  }
}
