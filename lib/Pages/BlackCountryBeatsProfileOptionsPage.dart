import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseAuth Helper.dart';

class BlackCountryBeatsProfileOptionsPage extends StatefulWidget {
  final Future<void> Function(BuildContext context) onLogOut;

  const BlackCountryBeatsProfileOptionsPage({
    super.key,
    required this.onLogOut,
  });

  @override
  State<BlackCountryBeatsProfileOptionsPage> createState() =>
      _BlackCountryBeatsProfileOptionsPageState();
}

class _BlackCountryBeatsProfileOptionsPageState
    extends State<BlackCountryBeatsProfileOptionsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //state variable
  bool _isLoading = true;
  //profile declarations
  String _profileName = '';
  String _profileImage = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }
//load publicProfile details
  Future<void> _loadProfile() async {
    try {
      final user = AuthService().getCurrentUser();
      if (user == null) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        return;
      }

      //firestore query for logged in user publicProfile
      final snapshot = await _firestore
          .collection('publicProfiles')
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (!mounted) return;

      //if found, set profileName and profileImage respectively
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        setState(() {
          _profileName = (data['profileName'] ?? '').toString();
          _profileImage = (data['profileImage'] ?? '').toString();
          _isLoading = false;
        });
      } else {
        //query done so loading done
        setState(() {
          _isLoading = false;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _optionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF27272A),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            children: [
              //icon colour based on property isDestructive
              Icon(
                icon,
                color: isDestructive
                    ? const Color(0xFFFF8A80)
                    : const Color(0xFFFFC21C),
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isDestructive ? const Color(0xFFFF8A80) : Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white54,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //height of top section
    const double topSectionHeight = 130;

    return Scaffold(
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
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            top: topSectionHeight - 8,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF27272A),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: _isLoading
                        ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: CircularProgressIndicator(),
                      ),
                    )
                        : Column(
                      children: [
                        CircleAvatar(
                          radius: 38,
                          backgroundColor: const Color(0xFF3A3A3D),
                          backgroundImage: _profileImage.isNotEmpty
                              ? NetworkImage(_profileImage)
                              : null,
                          child: _profileImage.isEmpty
                              ? const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 34,
                          )
                              : null,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _profileName.isEmpty
                              ? 'Unnamed Profile'
                              : _profileName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Manage your public profile and personal settings here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Add edit profile navigation here later
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFC21C)
                                  .withOpacity(0.95),
                              foregroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  _optionTile(
                    icon: Icons.diamond,
                    title: 'Premium',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _optionTile(
                    icon: Icons.settings,
                    title: 'Accessibility Settings',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _optionTile(
                    icon: Icons.logout,
                    title: 'Log out',
                    isDestructive: true,
                    onTap: () async {
                      await widget.onLogOut(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
