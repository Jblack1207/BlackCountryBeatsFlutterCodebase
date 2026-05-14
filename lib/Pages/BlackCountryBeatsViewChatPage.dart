import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseAuth Helper.dart';
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseChat Helper.dart';
import 'package:flutter_project_cmp3023/Helpers/SocketHelper.dart';

class ChatThreadPage extends StatefulWidget {
  final String chatId;
  final String otherUserId;
  final String otherUserName;

  const ChatThreadPage({
    super.key,
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  State<ChatThreadPage> createState() => _ChatThreadPageState();
}

class _ChatThreadPageState extends State<ChatThreadPage> {
  final ChatService _chatService = ChatService();
  final SocketService _socketService = SocketService();
  final TextEditingController _messageController = TextEditingController();

  String? _userId;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    final user = AuthService().getCurrentUser();
    if (user == null || !mounted) return;

    setState(() {
      _userId = user.uid;
    });

    await _chatService.markChatAsRead(
      chatId: widget.chatId,
      currentUserId: _userId!,
    );

    _socketService.connect(
      serverUrl: 'http://192.168.0.113:3000',
      userId: _userId!,
    );

    _socketService.joinChat(widget.chatId);
  }

  @override
  void dispose() {
    _socketService.leaveChat(widget.chatId);
    _socketService.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _userId == null) return;

    _messageController.clear();

    _socketService.sendMessage(
      chatId: widget.chatId,
      senderId: _userId!,
      text: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF27272A),
        title: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('publicProfiles')
              .where('userId', isEqualTo: widget.otherUserId)
              .limit(1)
              .snapshots(),
          builder: (context, snapshot) {
            final doc = snapshot.hasData && snapshot.data!.docs.isNotEmpty
                ? snapshot.data!.docs.first.data()
                : null;

            final profileName =
            (doc?['profileName'] ?? widget.otherUserName).toString();
            final profileImage = (doc?['profileImage'] ?? '').toString();
            final isOnline = (doc?['isOnline'] ?? false) == true;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFF3A3A3D),
                  backgroundImage:
                  profileImage.isNotEmpty ? NetworkImage(profileImage) : null,
                  child: profileImage.isEmpty
                      ? const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 18,
                  )
                      : null,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          profileName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isOnline) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _chatService.chatMessagesStream(widget.chatId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data();
                    final isMine = data['senderId'] == _userId;

                    return Align(
                      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.5,
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isMine
                                ? const Color(0xFF2F6BFF)
                                : const Color(0xFF3A3A3D),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isMine ? 16 : 4),
                              bottomRight: Radius.circular(isMine ? 4 : 16),
                            ),
                          ),
                          child: Text(
                            (data['text'] ?? '').toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            minimum: const EdgeInsets.only(left: 12, right: 12, bottom: 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    maxLength: 300,
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Message...',
                      hintStyle: const TextStyle(color: Colors.white60),
                      counterStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF27272A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
