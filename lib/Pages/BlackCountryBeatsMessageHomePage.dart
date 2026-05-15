import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseAuth Helper.dart';
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseFollowing Helper.dart';
import 'package:flutter_project_cmp3023/Helpers/SocketHelper.dart';
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseChat Helper.dart';

import 'BlackCountryBeatsViewChatPage.dart';


class BlackCountryBeatsMessageHomePage extends StatefulWidget {
  const BlackCountryBeatsMessageHomePage({super.key});

  @override
  State<BlackCountryBeatsMessageHomePage> createState() =>
      _BlackCountryBeatsMessageHomePageState();
}

class _BlackCountryBeatsMessageHomePageState
    extends State<BlackCountryBeatsMessageHomePage> {
  //creates SocketService for Page
  final SocketService _socketService = SocketService();
  //creates FollowingService for Page
  final FollowingService _followingService = FollowingService();
  //creates ChatService for Page
  final ChatService _chatService = ChatService();


  String? _userId;

  @override
  void initState() {
    super.initState();
    _initMessages();
  }

  //create socket connection to server.js
  Future<void> _initMessages() async {
    final user = AuthService().getCurrentUser();

    print('Init messages called');
    print('Firebase user: $user');
    print('Firebase uid: ${user?.uid}');

    if (user == null) return;
    if (!mounted) return;

    setState(() {
      _userId = user.uid;
    });

    _socketService.connect(
      serverUrl: 'http://10.128.3.63:3000',
      userId: _userId!,
    );
  }

  //show new chat pop up for it user clicks the +
  Future<void> _showNewChatPopup() async {
    //uses followingservice to fetch following userProfiles
    final profiles = await _followingService.getFollowingProfilesStream().first;

    final  chatTargets = profiles.where((profile) {
      return profile['userId'] != _userId;
    }).toList();

    if (!mounted) return;

    //bottom of the screen pop up
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        //uses TextEditingController to read and retrieve input for search
        final searchController = TextEditingController();
        List<Map<String, dynamic>> filteredProfiles = List.from(chatTargets);

        return StatefulBuilder(
          builder: (context, setModalState) {
            void filterProfiles(String value) {
              final query = value.trim().toLowerCase();

              setModalState(() {
                if (query.isEmpty) {
                  filteredProfiles = List.from(chatTargets);
                } else {
                  filteredProfiles = chatTargets.where((profile) {
                    final name = (profile['profileName'] ?? '')
                        .toString()
                        .toLowerCase();

                    return name.contains(query);
                  }).toList();
                }
              });
            }

            //Container Build for Start New Chat Pop Up
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFF27272A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Start New Chat',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: searchController,
                      onChanged: filterProfiles,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search users...',
                        hintStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(Icons.search, color: Colors.white54),
                        filled: true,
                        fillColor: const Color(0xFF1F1F1F),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    //no profiles = message
                    if (filteredProfiles.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'No matching users found',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    else
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: filteredProfiles.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          //if there are profiles, they are returned
                          itemBuilder: (context, index) {
                            final profile = filteredProfiles[index];

                            return InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () async {
                                //checking for whether chat already exists
                                final otherUserId =
                                (profile['userId'] ?? '').toString();
                                final otherUserProfileId =
                                (profile['id'] ?? '').toString();

                                //id validation
                                if (_userId == null ||
                                    otherUserId.isEmpty ||
                                    otherUserProfileId.isEmpty) {
                                  return;
                                }

                                final myProfiles = profiles.where((p) {
                                  return p['userId'] == _userId;
                                }).toList();

                                if (myProfiles.isEmpty) return;

                                final currentUserProfileId =
                                (myProfiles.first['id'] ?? '').toString();

                                if (currentUserProfileId.isEmpty) return;


                                //create chat relationship document
                                final chatId = await _chatService.getOrCreateChat(
                                  currentUserId: _userId!,
                                  otherUserId: otherUserId,
                                  currentUserProfileId: currentUserProfileId,
                                  otherUserProfileId: otherUserProfileId,
                                );

                                if (!mounted) return;

                                Navigator.pop(sheetContext);


                                //take user to chat thread page with profile id of other user
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChatThreadPage(
                                      chatId: chatId,
                                      otherUserId: otherUserId,
                                      //name protection if missing
                                      otherUserName: profile['profileName'] ?? 'Unknown',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1F1F1F),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white12),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      //profileImage displayed top of page
                                      backgroundColor: const Color(0xFF3A3A3D),
                                      backgroundImage: (profile['profileImage'] ?? '')
                                          .toString()
                                          .isNotEmpty
                                          ? NetworkImage(profile['profileImage'])
                                          : null,
                                      child: (profile['profileImage'] ?? '')
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
                                      //name missing protection
                                      child: Text(
                                        profile['profileName'] ?? 'Unknown',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Colors.white70,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  //build message list
  Future<List<Map<String, dynamic>>> _buildMessageHomeItems(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> chatDocs,
      ) async {
    final results = <Map<String, dynamic>>[];

    for (final chatDoc in chatDocs) {
      try {
        final chatData = chatDoc.data();
        final members = List<String>.from(chatData['members'] ?? []);
        //setting unreadCounts
        final unreadCounts =
        Map<String, dynamic>.from(chatData['unreadCounts'] ?? {});

        final otherUserId = members.firstWhere(
              (id) => id != _userId,
          orElse: () => '',
        );

        if (otherUserId.isEmpty) continue;

        //fetches publicProfile where userId is eq otherUserId (the one clicked by user)
        final profileSnapshot = await FirebaseFirestore.instance
            .collection('publicProfiles')
            .where('userId', isEqualTo: otherUserId)
            .limit(1)
            .get();

        if (profileSnapshot.docs.isEmpty) continue;

        final profileData = profileSnapshot.docs.first.data();

        //add message block
        results.add({
          'chatId': chatDoc.id,
          'otherUserId': otherUserId,
          'profileName': profileData['profileName'] ?? 'Unknown',
          'profileImage': profileData['profileImage'] ?? '',
          'lastMessage': chatData['lastMessage'] ?? '',
          'time': '',
          'unreadCount': ((unreadCounts[_userId] ?? 0) as num).toInt(),
        });
      } catch (e) {
        print('Error building chat item for ${chatDoc.id}: $e');
      }
    }

    return results;
  }



  @override
  void dispose() {
    _socketService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double topSectionHeight = 217;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF1F1F1F),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: topSectionHeight,
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.of(context).padding.top + 8,
                16,
                12,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF27272A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              //top section
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Messaging',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 93,
                    child: _userId == null
                        ? const SizedBox.shrink()
                        : StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _followingService.getFollowingProfilesStream(),
                      builder: (context, snapshot) {
                        final followedProfiles = snapshot.data ?? [];

                        if (followedProfiles.isEmpty) {
                          return const Center(
                            child: Text(
                              //only show when profiles are empty
                              'TIP: When you follow someone, their account will appear here',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }

                        //returns list of followed profiles
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: followedProfiles.length,
                          separatorBuilder: (_, __) =>
                          const SizedBox(width: 14),
                          itemBuilder: (context, index) {
                            final profile = followedProfiles[index];

                            return SizedBox(
                              width: 70,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: index == 0
                                                ? const Color(0xff394046)
                                                : Colors.white24,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: ClipOval(
                                          child: (profile['profileImage'] ?? '')
                                              .toString()
                                              .isEmpty
                                              ? Container(
                                            color: const Color(0xFF3A3A3D),
                                            child: const Icon(
                                              Icons.person,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          )
                                              : Image.network(
                                            profile['profileImage'],
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (_, __, ___) =>
                                                Container(
                                                  color: const Color(0xFF3A3A3D),
                                                  child: const Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                    size: 30,
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ),
                                      //presence detection dot shown if true, hidden if false
                                      if ((profile['isOnline'] ?? false) == true)
                                        Positioned(
                                          right: 2,
                                          bottom: 2,
                                          child: Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: const Color(0xFF27272A),
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  //own user shown on top section
                                  Text(
                                    index == 0
                                        ? 'You'
                                        : (profile['profileName'] ?? ''),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

      Positioned(
        top: topSectionHeight - 4,
        left: 15,
        right: 15,
        bottom: 130,

        //listens to user chat stream in real time
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _userId == null ? null : _chatService.messageHomeStream(_userId!),
          builder: (context, snapshot) {
            if (_userId == null) {
              return const Center(
                child: Text(
                  'No user session found',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            if (snapshot.hasError) {
              print('Chat stream error: ${snapshot.error}');
              return Center(
                child: Text(
                  'Chat stream error: ${snapshot.error}',
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

            //creates List view based on Stream results/existing messages
            return FutureBuilder<List<Map<String, dynamic>>>(
              future: _buildMessageHomeItems(chatDocs),
              builder: (context, messageSnapshot) {
                if (messageSnapshot.hasError) {
                  return Center(
                    child: Text(
                      'Message build error: ${messageSnapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }

                //progress indicator
                if (!messageSnapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final messages = messageSnapshot.data ?? [];

                //list view of messages
                return ListView.separated(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: messages.length + 1,
                  separatorBuilder: (_, index) =>
                  index == 0 ? const SizedBox(height: 6) : const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Row(
                        children: [
                          const SizedBox(width: 10),
                          const Text(
                            'Chat',
                            style: TextStyle(
                              color: Color(0xFFFFD000),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: _showNewChatPopup,
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ],
                      );
                    }

                    if (messages.isEmpty) {
                      return const Center(
                        child: Text(
                          'No messages yet',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }


                    final item = messages[index - 1];
                    final unreadCount = ((item['unreadCount'] ?? 0) as num).toInt();
                    final hasUnread = unreadCount > 0;

                    return InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatThreadPage(
                              chatId: item['chatId'],
                              otherUserId: item['otherUserId'],
                              otherUserName: item['profileName'] ?? 'Unknown',
                            ),
                          ),
                        );
                      },
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
                    );;
                  },
                );
              },
            );
          },
        ),
        ),
        ],
      ),
    );
  }
}
