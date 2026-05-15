import 'package:cloud_firestore/cloud_firestore.dart'; //import for cloud firestore
import 'package:flutter/material.dart'; //import material flutter components
import 'package:flutter_svg/flutter_svg.dart'; //import flutter svg manager
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseAuth Helper.dart'; //import Firebase Auth Functions
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseChat Helper.dart'; //import Firebase Chat Helper for Latest Messages Section
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseNews Helper.dart'; //import Firebase News Helper for Latest News Section
import 'package:flutter_project_cmp3023/Pages/BlackCountryBeatsViewChatPage.dart'; //for navigation when clicking on Latest Messages section

import 'BlackCountryBeatsProfileOptionsPage.dart';

class BlackCountryBeatsHomePage extends StatefulWidget {
  const BlackCountryBeatsHomePage({super.key});

  @override //creates Home Page State
  State<BlackCountryBeatsHomePage> createState() =>
      _BlackCountryBeatsHomePageState();
}

class _BlackCountryBeatsHomePageState
    extends State<BlackCountryBeatsHomePage> {
  String? firstName;
  final ScrollController _scrollController = ScrollController(); //scroll controller for 3 main elements of the page
  final ChatService _chatService = ChatService(); //chat service from Chat Helper that allows for connection to nodeJs Server and Firebase Storage

  Future<void> _loadFirstName() async {
    final name = await AuthService().getCurrentUserFirstName(); //retrieves currently authenticated users first name

    setState(() {
      firstName = name; //sets first name
    });
  }

  //builds the LatestMessages component
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

      //searches firebase collection publicProfiles where userId field matches otherUserId (any user id that does not match currently authenticated user)
      final profileSnapshot = await FirebaseFirestore.instance
          .collection('publicProfiles')
          .where('userId', isEqualTo: otherUserId)
          .limit(1)
          .get();

      //empty field protection
      if (profileSnapshot.docs.isEmpty) continue;

      final profileData = profileSnapshot.docs.first.data();

      //sets unreadCounts from Firebase Collection Document for user
      final unreadCounts =
      Map<String, dynamic>.from(chatData['unreadCounts'] ?? {});

      results.add({
        'chatId': chatDoc.id,
        'otherUserId': otherUserId,
        'profileName': profileData['profileName'] ?? 'Unknown',
        'profileImage': profileData['profileImage'] ?? '',
        'lastMessage': chatData['lastMessage'] ?? '',
        'unreadCount': ((unreadCounts[currentUserId] ?? 0) as num).toInt(),
      });
    }

    return results;
  }

  //initialise required states
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
    //sets User as currently Logged In user
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
            //Top of the Page Logo
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
                    //Navigation logic for sending user to the ProfileOptions page from the acccount_circle logo
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlackCountryBeatsProfileOptionsPage(
                            onLogOut: (context) async {
                              await AuthService().logoutUser(context);
                            },
                          ),
                        ),
                      );
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
                  //if statement for whether firstName is present or not and whether to display Welcome or Welcome {{firstName}}
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

              //LATEST NEWS SECTION
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

              //fetches and displays News Documents from Firebase
              FutureBuilder<List<NewsItem>>(
                future: NewsService().getPublishedNews(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  //error protection
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Failed to load news',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final newsList = snapshot.data ?? [];

                  //empty news protection
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

                        //NEWS BOX
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

                            //NEWS IMAGE
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

                                //NEWS TITLE
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

                                      //NEWS DESCRIPTION
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

              //QUICK SEARCH SCROLLER
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

              //QUICK SEARCH SCROLLBAR LOGIC
              SizedBox(
                height: 30,
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: false,
                  child: ListView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    children: [
                      //Band quick search box
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
                      //Rock quick search box

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

                      //Pop quick search box

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

                      //Solo quick search box

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

                      //Acoustic quick search box
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

              //LATEST MESSAGES
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
              //error protection against nullable users
              if (user == null)
                const Center(
                  child: Text(
                    'No user session found',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              else
                //Stream builder to connect chat service to nodeJS Server and Firebase
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

                    //if messages are retrieved, message section is built
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

                        //empty message protection
                        if (messages.isEmpty) {
                          return const Center(
                            child: Text(
                              'No messages yet',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        //only 3 latest messages shown
                        final latestMessages = messages.take(3).toList();

                        return SizedBox(
                            height: 160,
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: latestMessages.length,
                              separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final item = latestMessages[index];
                                  final otherUserId = (item['otherUserId'] ?? '').toString();
                                  final unreadCount = ((item['unreadCount'] ?? 0) as num).toInt(); //amount of unread messages from user
                                  final hasUnread = unreadCount > 0;

                                  return InkWell(
                                    borderRadius: BorderRadius.circular(18),
                                    onTap: otherUserId.isEmpty
                                        ? null
                                        : () {
                                      //navigation to clicked User Messages and Profile
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ChatThreadPage(
                                            chatId: (item['chatId'] ?? '').toString(),
                                            otherUserId: otherUserId,
                                            otherUserName:
                                            (item['profileName'] ?? 'Unknown').toString(),
                                          ),
                                        ),
                                      );
                                    },
                                    //unread message bubble and box highlighting
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: hasUnread
                                            ? const Color(0xFF333337)
                                            : const Color(0xFF27272A),
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                          color: hasUnread ? Colors.white24 : Colors.white24,
                                          width: hasUnread ? 1.4 : 1,
                                        ),
                                        boxShadow: hasUnread
                                            ? const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 8,
                                            offset: Offset(0, 4),
                                          ),
                                        ]
                                            : null,
                                      ),
                                      //fetches User Profile Image
                                      child: Row(
                                        children: [
                                          Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              CircleAvatar(
                                                radius: 28,
                                                backgroundColor: const Color(0xFF3A3A3D),
                                                backgroundImage: (item['profileImage'] ?? '')
                                                    .toString()
                                                    .isNotEmpty
                                                    ? NetworkImage(item['profileImage'])
                                                    : null,
                                                child: (item['profileImage'] ?? '').toString().isEmpty
                                                    ? const Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                )
                                                    : null,
                                              ),
                                              if (hasUnread)
                                                Positioned(
                                                  right: -270,
                                                  top: 17,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 7,
                                                      vertical: 3,
                                                    ),
                                                    decoration: const BoxDecoration(
                                                      color: Color(0xFFFF0505),
                                                      borderRadius: BorderRadius.all(Radius.circular(999)),
                                                    ),
                                                    child: Text(
                                                      '$unreadCount',
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w800,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),

                                          //fetches User Profilename
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item['profileName'] ?? 'Unknown',
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: const Color(0xFFFFD000),
                                                    fontSize: 16,
                                                    fontWeight: hasUnread ? FontWeight.w800 : FontWeight.w700,
                                                  ),
                                                ),

                                                //fetches Users Last Message in chat
                                                const SizedBox(height: 4),
                                                Text(
                                                  item['lastMessage'] ?? '',
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: hasUnread ? Colors.white : Colors.white70,
                                                    fontSize: 14,
                                                    fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w400,
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
