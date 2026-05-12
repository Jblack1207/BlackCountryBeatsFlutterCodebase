import 'package:flutter/material.dart';
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseAuth Helper.dart';
import 'package:flutter_project_cmp3023/Helpers/SocketHelper.dart';
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseFollowing Helper.dart';


class BlackCountryBeatsMessageHomePage extends StatefulWidget {
  const BlackCountryBeatsMessageHomePage({super.key});

  @override
  State<BlackCountryBeatsMessageHomePage> createState() =>
      _BlackCountryBeatsMessageHomePageState();
}

class _BlackCountryBeatsMessageHomePageState
    extends State<BlackCountryBeatsMessageHomePage> {
  final SocketService _socketService = SocketService();
  String? _userId;
  final List<Map<String, dynamic>> followedProfiles = [];


  @override
  void initState() {
    super.initState();
    _initMessages();
    _loadFollowingProfiles();
  }

  Future<void> _initMessages() async {
    final user = AuthService().getCurrentUser();
    if (user == null) return;

    _userId = user.uid;

    _socketService.connect(
      serverUrl: 'http://192.168.0.113:3000',
      userId: _userId!,
    );

    _socketService.requestMessageHome(_userId!);
  }

  Future<void> _loadFollowingProfiles() async {
    final profiles = await FollowingService().getFollowingProfiles();

    if (!mounted) return;

    setState(() {
      followedProfiles
        ..clear()
        ..addAll(profiles);
    });
  }


  @override
  void dispose() {
    _socketService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double topSectionHeight = 216;
    const double contentTopGap = 0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF1F1F1F),
      body: Stack(
        children: [

          //FOLLOWING AND ACTIVE USERS SECTION
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
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: followedProfiles.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
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
                                      child: (profile['profileImage'] ?? '').toString().isEmpty
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
                                        errorBuilder: (_, __, ___) => Container(
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
                                  if ((profile['isOnline'] ?? false) == true)
                                    Positioned(
                                      right: 2,
                                      bottom: 2,
                                      child: Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF128a24),
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
                              Text(
                                index == 0 ? 'You' : (profile['profileName'] ?? ''),
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
                    ),
                  ),
                ],
              ),
            ),
          ),

          //SOCKET MESSAGE SECTION
          Positioned(
            top: topSectionHeight - 4,
            left: 15,
            right: 15,
            bottom: 130,
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _socketService.messagesStream,
              builder: (context, snapshot) {
                final messages = snapshot.data ?? [];

                if (_userId == null) {
                  return const Center(
                    child: Text(
                      'No user session found',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (messages.isEmpty) {
                  return ListView(
                    padding: const EdgeInsets.only(top: 8),
                    children: [
                      Row(
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
                            onPressed: () {},
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 0),
                        ],
                      ),


                      const SizedBox(height: 6),
                      const Center(
                        child: Text(
                          'No messages yet',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                }

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
                            onPressed: () {},
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 0),
                        ],
                      );
                    }

                    final item = messages[index - 1];

                    return Container(
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
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                          const SizedBox(width: 8),
                          Text(
                            item['time'] ?? '',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
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
    );
  }
}