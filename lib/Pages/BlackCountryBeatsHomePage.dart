import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseAuth Helper.dart';
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseChat Helper.dart';
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseNews Helper.dart';
import 'package:flutter_project_cmp3023/Pages/BlackCountryBeatsViewChatPage.dart';

class BlackCountryBeatsHomePage extends StatefulWidget {
  const BlackCountryBeatsHomePage({super.key});

  @override
  State<BlackCountryBeatsHomePage> createState() =>
      _BlackCountryBeatsHomePageState();
}

class _BlackCountryBeatsHomePageState
    extends State<BlackCountryBeatsHomePage> {
  String? firstName;
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();

  Future<void> _loadFirstName() async {
    final name = await AuthService().getCurrentUserFirstName();

    setState(() {
      firstName = name;
    });
  }

  Future<List<Map<String, dynamic>>> _buildLatestMessages(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> chatDocs,
      String currentUserId,
      ) async {
    final results = <Map<String, dynamic>>[];

    for (final chatDoc in chatDocs) {
      final chatData = chatDoc.data();
      final members = List<String>.from(chatData['members'] ?? []);

      final otherUserId = members.firstWhere(
            (id) => id != currentUserId,
        orElse: () => '',
      );

      if (otherUserId.isEmpty) continue;

      final profileSnapshot = await FirebaseFirestore.instance
          .collection('publicProfiles')
          .where('userId', isEqualTo: otherUserId)
          .limit(1)
          .get();

      if (profileSnapshot.docs.isEmpty) continue;

      final profileData = profileSnapshot.docs.first.data();

      results.add({
        'chatId': chatDoc.id,
        'otherUserId': otherUserId,
        'profileName': profileData['profileName'] ?? 'Unknown',
        'profileImage': profileData['profileImage'] ?? '',
        'lastMessage': chatData['lastMessage'] ?? '',
      });
    }

    return results;
  }

  @override
  void initState() {
    super.initState();
    _loadFirstName();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().getCurrentUser();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        top: 80,
        left: 18,
        right: 18,
        bottom: 130,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SvgPicture.asset(
              'assets/images/BCBLongLogo.svg',
              width: 240,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      await AuthService().logoutUser(context);
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.account_circle,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: firstName == null
                        ? const Text(
                      'Welcome',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                        : RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Welcome, ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: firstName,
                            style: const TextStyle(
                              color: Color(0xffffc21c),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 34,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 10),
                  const Text(
                    'Latest News',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: const Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              FutureBuilder<List<NewsItem>>(
                future: NewsService().getPublishedNews(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Failed to load news',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final newsList = snapshot.data ?? [];

                  if (newsList.isEmpty) {
                    return const Center(
                      child: Text(
                        'No news available',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return SizedBox(
                    height: 160,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: newsList.length,
                      itemBuilder: (context, index) {
                        final news = newsList[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            padding: const EdgeInsets.only(
                              right: 20,
                              left: 8,
                              top: 5,
                              bottom: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xff27272A),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF3A3A3D),
                                width: 1.5,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    news.newsImage,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) {
                                      return Container(
                                        width: 90,
                                        height: 90,
                                        color: Colors.grey,
                                        child: const Icon(
                                          Icons.broken_image,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        news.newsTitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Color(0xffffc21c),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        news.newsDescription,
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 10),
                  const Text(
                    'Quick Search',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 30,
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: false,
                  child: ListView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    children: [
                      SizedBox(
                        width: 105,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3A3A3D),
                            foregroundColor: Colors.black,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                color: Colors.white24,
                                width: 1,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Band',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 105,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3A3A3D),
                            foregroundColor: Colors.black,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                color: Colors.white24,
                                width: 1,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Rock',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 105,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3A3A3D),
                            foregroundColor: Colors.black,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                color: Colors.white24,
                                width: 1,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Pop',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 105,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3A3A3D),
                            foregroundColor: Colors.black,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                color: Colors.white24,
                                width: 1,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Solo',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 105,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3A3A3D),
                            foregroundColor: Colors.black,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                color: Colors.white24,
                                width: 1,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Acoustic',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 10),
                  const Text(
                    'Latest Messages',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: const Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (user == null)
                const Center(
                  child: Text(
                    'No user session found',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              else
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _chatService.messageHomeStream(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Failed to load latest messages: ${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final chatDocs = snapshot.data!.docs;

                    if (chatDocs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No messages yet',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return FutureBuilder<List<Map<String, dynamic>>>(
                      future: _buildLatestMessages(chatDocs, user.uid),
                      builder: (context, messageSnapshot) {
                        if (messageSnapshot.hasError) {
                          return Center(
                            child: Text(
                              'Failed to build messages: ${messageSnapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        if (!messageSnapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final messages = messageSnapshot.data!;

                        if (messages.isEmpty) {
                          return const Center(
                            child: Text(
                              'No messages yet',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        final latestMessages = messages.take(3).toList();

                        return SizedBox(
                            height: 260,
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: latestMessages.length,
                              separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = latestMessages[index];
                            final otherUserId = (item['otherUserId'] ?? '').toString();

                            return InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: otherUserId.isEmpty
                                  ? null
                                  : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChatThreadPage(
                                      chatId:
                                      (item['chatId'] ?? '').toString(),
                                      otherUserId: otherUserId,
                                      otherUserName:
                                      (item['profileName'] ?? 'Unknown')
                                          .toString(),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF27272A),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundColor:
                                      const Color(0xFF3A3A3D),
                                      backgroundImage: (item['profileImage'] ?? '')
                                          .toString()
                                          .isNotEmpty
                                          ? NetworkImage(item['profileImage'])
                                          : null,
                                      child: (item['profileImage'] ?? '')
                                          .toString()
                                          .isEmpty
                                          ? const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      )
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['profileName'] ?? 'Unknown',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Color(0xFFFFD000),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item['lastMessage'] ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                            )
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
