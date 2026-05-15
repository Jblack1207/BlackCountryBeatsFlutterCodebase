import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseAuth Helper.dart';
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseChat Helper.dart';
import 'package:flutter_project_cmp3023/Pages/BlackCountryBeatsViewChatPage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BlackCountryBeatsUserProfilePage extends StatefulWidget {
  final String userId;

  const BlackCountryBeatsUserProfilePage({
    super.key,
    required this.userId,
  });

  @override
  State<BlackCountryBeatsUserProfilePage> createState() =>
      _BlackCountryBeatsUserProfilePageState();
}

class _BlackCountryBeatsUserProfilePageState
    extends State<BlackCountryBeatsUserProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ChatService _chatService = ChatService();

  Map<String, dynamic>? _profileData;
  bool _isFollowing = false;
  bool _isBusyFollow = false;
  bool _isBusyMessage = false;
  bool _isLoading = true;
  bool _isOpeningMap = false;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initProfilePage();
  }

  Future<void> _initProfilePage() async {
    try {
      final currentUser = AuthService().getCurrentUser();
      _currentUserId = currentUser?.uid;

      final profileDoc = await _firestore
          .collection('publicProfiles')
          .doc(widget.userId)
          .get();

      if (!profileDoc.exists || !mounted) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      bool isFollowing = false;

      if (_currentUserId != null && _currentUserId!.isNotEmpty) {
        final followSnapshot = await _firestore
            .collection('followingLinks')
            .where('userId', isEqualTo: _currentUserId)
            .where('followingUserId', isEqualTo: widget.userId)
            .limit(1)
            .get();

        isFollowing = followSnapshot.docs.isNotEmpty;
      }

      if (!mounted) return;

      setState(() {
        _profileData = profileDoc.data();
        _isFollowing = isFollowing;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _followUser() async {
    final currentUser = AuthService().getCurrentUser();
    if (currentUser == null || _isFollowing || _isBusyFollow) return;

    setState(() {
      _isBusyFollow = true;
    });

    try {
      final existing = await _firestore
          .collection('followingLinks')
          .where('userId', isEqualTo: currentUser.uid)
          .where('followingUserId', isEqualTo: widget.userId)
          .limit(1)
          .get();

      if (existing.docs.isEmpty) {
        await _firestore.collection('followingLinks').add({
          'userId': currentUser.uid,
          'followingUserId': widget.userId,
          'createdAt': FieldValue.serverTimestamp(),
        });

        await _firestore.collection('publicProfiles').doc(widget.userId).update({
          'followerCount': FieldValue.increment(1),
        });
      }

      if (!mounted) return;

      setState(() {
        _isFollowing = true;
        if (_profileData != null) {
          final currentCount =
          ((_profileData!['followerCount'] ?? 0) as num).toInt();
          _profileData!['followerCount'] = currentCount + 1;
        }
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isBusyFollow = false;
      });
    }
  }

  Future<void> _unfollowUser() async {
    final currentUser = AuthService().getCurrentUser();
    if (currentUser == null || !_isFollowing || _isBusyFollow) return;

    final shouldUnfollow = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          title: const Text(
            'Unfollow User?',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18
            ),
          ),
          content: const Text(
            'Are you sure you want to unfollow this user?',
            style: TextStyle(
                color: Colors.white70,
                fontSize: 14
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text(
                'Unfollow',
                style: TextStyle(
                    color: Color(0xffff0505),
                    fontWeight: FontWeight.w700,
                    fontSize: 14
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldUnfollow != true) return;

    setState(() {
      _isBusyFollow = true;
    });

    try {
      final existing = await _firestore
          .collection('followingLinks')
          .where('userId', isEqualTo: currentUser.uid)
          .where('followingUserId', isEqualTo: widget.userId)
          .get();

      for (final doc in existing.docs) {
        await doc.reference.delete();
      }

      await _firestore.collection('publicProfiles').doc(widget.userId).update({
        'followerCount': FieldValue.increment(-1),
      });

      if (!mounted) return;

      setState(() {
        _isFollowing = false;
        if (_profileData != null) {
          final currentCount =
          ((_profileData!['followerCount'] ?? 0) as num).toInt();
          _profileData!['followerCount'] = currentCount > 0 ? currentCount - 1 : 0;
        }
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isBusyFollow = false;
      });
    }
  }


  Future<void> _messageUser() async {
    final currentUser = AuthService().getCurrentUser();
    final profile = _profileData;
    if (currentUser == null || profile == null || _isBusyMessage) return;

    final otherUserAuthId = (profile['userId'] ?? '').toString();
    if (otherUserAuthId.isEmpty) return;

    setState(() {
      _isBusyMessage = true;
    });

    try {
      final myProfileSnapshot = await _firestore
          .collection('publicProfiles')
          .where('userId', isEqualTo: currentUser.uid)
          .limit(1)
          .get();

      if (myProfileSnapshot.docs.isEmpty) return;

      final currentUserProfileId = myProfileSnapshot.docs.first.id;

      final chatId = await _chatService.getOrCreateChat(
        currentUserId: currentUser.uid,
        otherUserId: otherUserAuthId,
        currentUserProfileId: currentUserProfileId,
        otherUserProfileId: widget.userId,
      );

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatThreadPage(
            chatId: chatId,
            otherUserId: otherUserAuthId,
            otherUserName: (profile['profileName'] ?? 'Unknown').toString(),
          ),
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isBusyMessage = false;
      });
    }
  }

  Future<void> _openLocationOnMap(String address, String profileName) async {
    if (address.trim().isEmpty || _isOpeningMap) return;

    setState(() {
      _isOpeningMap = true;
    });

    try {
      final results = await locationFromAddress(address);

      if (!mounted) return;

      if (results.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not find that location on the map.'),
          ),
        );
        return;
      }

      final first = results.first;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlackCountryBeatsProfileMapPage(
            title: profileName,
            address: address,
            latitude: first.latitude,
            longitude: first.longitude,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open this location right now.'),
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isOpeningMap = false;
      });
    }
  }

  String _profileTypeLabel(int? value) {
    switch (value) {
      case 1:
        return 'Band';
      case 2:
        return 'Solo';
      case 3:
        return 'Venue';
      default:
        return 'Unknown';
    }
  }

  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
    bool isLoading = false,
  }) {
    final isTappable = onTap != null && value.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isTappable ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: '$label: ',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: value.isEmpty ? 'Not set' : value,
                        style: TextStyle(
                          color: isTappable
                              ? const Color(0xffffc21c).withOpacity(0.95)
                              : Colors.white70,
                          decoration:
                          isTappable ? TextDecoration.underline : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white70,
                  ),
                )
              else if (isTappable)
                const Icon(
                  Icons.open_in_new,
                  color: Colors.white54,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topInset = (MediaQuery.of(context).padding.top - 60).clamp(0.0, double.infinity);

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1F1F1F),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_profileData == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF1F1F1F),
        body: Center(
          child: Text(
            'Failed to load profile',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final profile = _profileData!;
    final bannerImage = (profile['backgroundImage'] ?? '').toString();
    final profileImage = (profile['profileImage'] ?? '').toString();
    final profileName = (profile['profileName'] ?? '').toString();
    final bio = (profile['bio'] ?? '').toString();
    final location = (profile['location'] ?? '').toString();
    final genre = (profile['genre'] ?? '').toString();
    final priceValue = profile['avgPricePerNight'];
    final followers = '${profile['followerCount'] ?? 0}';
    final rating = (profile['rating'] as num?)?.toDouble() ?? 0;
    final profileType =
    _profileTypeLabel((profile['profileType'] as num?)?.toInt());

    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
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
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: topInset),
                      Stack(
                        children: [
                          Container(
                            height: 170,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD9D9D9),
                              image: bannerImage.isNotEmpty
                                  ? DecorationImage(
                                image: NetworkImage(bannerImage),
                                fit: BoxFit.cover,
                              )
                                  : null,
                            ),
                            child: bannerImage.isEmpty
                                ? const Center(
                              child: Icon(
                                Icons.image_outlined,
                                color: Colors.black26,
                                size: 90,
                              ),
                            )
                                : null,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Rating',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                      5,
                                          (index) => Icon(
                                        index < rating.round()
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Followers: $followers',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    profileName.isEmpty
                                        ? 'Unnamed Profile'
                                        : profileName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE7E7E7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.verified,
                                    color: Colors.black87,
                                    size: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              bio.isEmpty ? 'No bio added yet.' : bio,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 38,
                                    child: ElevatedButton(
                                      onPressed: _isBusyFollow
                                          ? null
                                          : (_isFollowing ? _unfollowUser : _followUser),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xffffc21c).withOpacity(0.95),
                                        disabledBackgroundColor: const Color(0xFF2A2823),
                                        foregroundColor: Colors.black87,
                                        disabledForegroundColor: Colors.black38,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                      ),
                                      child: _isBusyFollow
                                          ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.black87,
                                        ),
                                      )
                                          : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            _isFollowing
                                                ? Icons.person_remove_alt_1
                                                : Icons.person_add_alt_1,
                                            size: 22,
                                            color: Colors.black87,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            _isFollowing ? 'Unfollow' : 'Follow',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: ElevatedButton(
                    onPressed: _isBusyMessage ? null : _messageUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffffc21c).withOpacity(0.95),
                      disabledBackgroundColor: const Color(0xFF2A2823),
                      foregroundColor: Colors.black87,
                      disabledForegroundColor: Colors.black38,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: _isBusyMessage
                        ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black87,
                      ),
                    )
                        : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mail_outline,
                          size: 22,
                          color: Colors.black87,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Message',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 18,
                    top: topInset + 95,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFD9D9D9),
                        border: Border.all(
                          color: const Color(0xFF394046),
                          width: 6,
                        ),
                        image: profileImage.isNotEmpty
                            ? DecorationImage(
                          image: NetworkImage(profileImage),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: profileImage.isEmpty
                          ? const Icon(
                        Icons.image_outlined,
                        size: 60,
                        color: Colors.black26,
                      )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Details',
                    style: TextStyle(
                      color: const Color(0xffffc21c).withOpacity(0.95),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _detailRow(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value: location,
                    isLoading: _isOpeningMap,
                    onTap: location.isEmpty
                        ? null
                        : () => _openLocationOnMap(location, profileName),
                  ),
                  const SizedBox(height: 10),
                  _detailRow(
                    icon: Icons.music_note_outlined,
                    label: 'Genre',
                    value: genre,
                  ),
                  const SizedBox(height: 12),
                  _detailRow(
                    icon: Icons.attach_money,
                    label: 'Price',
                    value: priceValue == null || '$priceValue' == '0'
                        ? ''
                        : '$priceValue per Night',
                  ),
                  const SizedBox(height: 34),
                  Text(
                    'Posts',
                    style: TextStyle(
                      color: const Color(0xffffc21c).withOpacity(0.95),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Container(
                      width: 260,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B2B30),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Center(
                        child: Text(
                          'This User currently has no Posts',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlackCountryBeatsProfileMapPage extends StatelessWidget {
  final String title;
  final String address;
  final double latitude;
  final double longitude;

  const BlackCountryBeatsProfileMapPage({
    super.key,
    required this.title,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    final marker = Marker(
      markerId: const MarkerId('profile_location'),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
        title: title.isEmpty ? 'Profile Location' : title,
        snippet: address,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: null,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 14,
        ),
        markers: {marker},
        myLocationButtonEnabled: false,
        mapToolbarEnabled: true,
        zoomControlsEnabled: false,
      ),
    );
  }
}
