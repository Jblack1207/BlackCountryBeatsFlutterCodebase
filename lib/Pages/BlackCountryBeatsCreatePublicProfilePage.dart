import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseAuth Helper.dart';
import 'package:flutter_project_cmp3023/Pages/BlackCountryBeatsShellPage.dart';

class BlackCountryBeatsCreatePublicProfilePage extends StatefulWidget {
  final int profileType; //profile type init

  const BlackCountryBeatsCreatePublicProfilePage({
    super.key,
    required this.profileType,
  });

  @override
  State<BlackCountryBeatsCreatePublicProfilePage> createState() =>
      _BlackCountryBeatsCreatePublicProfilePageState();
}

class _BlackCountryBeatsCreatePublicProfilePageState
    extends State<BlackCountryBeatsCreatePublicProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; //create Firestore Instance

  //set expected values to ''
  String _bannerImage = '';
  String _profileImage = '';
  String _profileName = '';
  String _bio = '';
  String _location = '';
  String _genre = '';
  String _price = '';

  //for loading symbol checking
  bool _isSaving = false;

  //enabling save button logic
  bool get _canSave {
    return _bannerImage.trim().isNotEmpty &&
        _profileImage.trim().isNotEmpty &&
        _profileName.trim().isNotEmpty &&
        _bio.trim().isNotEmpty &&
        _location.trim().isNotEmpty &&
        _genre.trim().isNotEmpty &&
        _price.trim().isNotEmpty;
  }

  //profileType enum conversion
  String _profileTypeLabel(int value) {
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

  //edit field box, reused for each field to allow users to edit expected information
  Future<void> _editField({
    required String title,
    required String initialValue,
    required ValueChanged<String> onSaved,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) async {
    final controller = TextEditingController(text: initialValue);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF27272A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            18,
            18,
            18,
            MediaQuery.of(sheetContext).viewInsets.bottom + 0,
          ),
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
              const SizedBox(height: 18),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLines: maxLines,
                keyboardType: keyboardType,
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  //changes for each element
                  hintText: 'Enter $title',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF1F1F1F),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 150,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    onSaved(controller.text.trim());
                    Navigator.pop(sheetContext);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffffc21c).withOpacity(0.95),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  //save profile function
  Future<void> _saveProfile() async {
    //fetches current user
    final user = AuthService().getCurrentUser();
    if (user == null || !_canSave || _isSaving) return;

    //set state of saving to true if function is running
    setState(() {
      _isSaving = true;
    });

    //profileData assignment for passing to Firestore
    final profileData = {
      'userId': user.uid,
      'profileType': widget.profileType,
      'profileName': _profileName.trim(),
      'bio': _bio.trim(),
      'location': _location.trim(),
      'genre': _genre.trim(),
      'avgPricePerNight': double.tryParse(_price.trim()) ?? 0,
      'profileImage': _profileImage.trim(),
      'backgroundImage': _bannerImage.trim(),
      'followerCount': 0,
      'rating': 0,
      'isOnline': false,
      'createdAt': FieldValue.serverTimestamp(),
    };

    //try to publish profileData to publicProfiles collection
    try {
      await _firestore.collection('publicProfiles').add(profileData);

      if (!mounted) return;

      //dialog box appears for 'Profile Saved'
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          Future.delayed(const Duration(seconds: 1), () {
            if (Navigator.canPop(dialogContext)) {
              Navigator.pop(dialogContext);
            }
          });

          return Dialog(
            backgroundColor: const Color(0xFF27272A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Color(0xffffc21c),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.black,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Profile Saved',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      if (!mounted) return;

      //pushes user to Profile Page if successfully saved
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const BlackCountryBeatsShellPage(initialIndex: 4),
        ),
            (route) => false,
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
      });
    }
  }

  //edit button widget, utilises editfield
  Widget _editButton(VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          color: Color(0xFFE7E7E7),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.edit,
          size: 14,
          color: Colors.black87,
        ),
      ),
    );
  }

  //text box detail for each element of the page
  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onEdit,
  }) {
    return Row(
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
                  text: value.isEmpty ? 'Enter $label here...' : value,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        _editButton(onEdit),
      ],
    );
  }

  //page widget builder, builds the entire page for users to edit
  @override
  Widget build(BuildContext context) {
    final topInset = (MediaQuery.of(context).padding.top - 60).clamp(0.0, double.infinity);

    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
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
                                      image: _bannerImage.isNotEmpty
                                          ? DecorationImage(
                                        image: NetworkImage(_bannerImage),
                                        fit: BoxFit.cover,
                                      )
                                          : null,
                                    ),
                                    child: _bannerImage.isEmpty
                                        ? const Center(
                                      child: Icon(
                                        Icons.image_outlined,
                                        color: Colors.black26,
                                        size: 90,
                                      ),
                                    )
                                        : null,
                                  ),
                                  Positioned(
                                    right: 14,
                                    bottom: 14,
                                    child: _editButton(
                                          () => _editField(
                                        title: 'Banner Image URL',
                                        initialValue: _bannerImage,
                                        onSaved: (value) {
                                          setState(() {
                                            _bannerImage = value;
                                          });
                                        },
                                      ),
                                    ),
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
                                                  (index) => const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 2),
                                                child: Icon(
                                                  Icons.star_border,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          const Text(
                                            'Followers: 0',
                                            style: TextStyle(
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
                                            _profileName.isEmpty
                                                ? 'Enter Preferred Artist Name...'
                                                : _profileName,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        _editButton(
                                              () => _editField(
                                            title: 'Profile Name',
                                            initialValue: _profileName,
                                            onSaved: (value) {
                                              setState(() {
                                                _profileName = value;
                                              });
                                            },
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
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _bio.isEmpty ? 'Enter Bio here...' : _bio,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        _editButton(
                                              () => _editField(
                                            title: 'Bio',
                                            initialValue: _bio,
                                            maxLines: 4,
                                            onSaved: (value) {
                                              setState(() {
                                                _bio = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 38,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF2A2823),
                                              borderRadius: BorderRadius.circular(24),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Follow',
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 14,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Container(
                                            height: 38,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF2A2823),
                                              borderRadius: BorderRadius.circular(24),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Message',
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 14,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w700,
                                                ),
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
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: Stack(
                                children: [
                                  Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFFD9D9D9),
                                      border: Border.all(
                                        color: const Color(0xFF394046),
                                        width: 6,
                                      ),
                                      image: _profileImage.isNotEmpty
                                          ? DecorationImage(
                                        image: NetworkImage(_profileImage),
                                        fit: BoxFit.cover,
                                      )
                                          : null,
                                    ),
                                    child: _profileImage.isEmpty
                                        ? const Icon(
                                      Icons.image_outlined,
                                      size: 60,
                                      color: Colors.black26,
                                    )
                                        : null,
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 8,
                                    child: _editButton(
                                          () => _editField(
                                        title: 'Profile Image URL',
                                        initialValue: _profileImage,
                                        onSaved: (value) {
                                          setState(() {
                                            _profileImage = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                            value: _location,
                            onEdit: () => _editField(
                              title: 'Location',
                              initialValue: _location,
                              onSaved: (value) {
                                setState(() {
                                  _location = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          _detailRow(
                            icon: Icons.music_note_outlined,
                            label: 'Genre',
                            value: _genre,
                            onEdit: () => _editField(
                              title: 'Genre',
                              initialValue: _genre,
                              onSaved: (value) {
                                setState(() {
                                  _genre = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          _detailRow(
                            icon: Icons.attach_money,
                            label: 'Price',
                            value: _price.isEmpty ? '' : '$_price per Night',
                            onEdit: () => _editField(
                              title: 'Price',
                              initialValue: _price,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              onSaved: (value) {
                                setState(() {
                                  _price = value;
                                });
                              },
                            ),
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
                                  "You'll be able to add posts after creation",
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Center(
                            child: SizedBox(
                              width: 200,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: _canSave && !_isSaving ? _saveProfile : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffffc21c).withOpacity(0.95),
                                  disabledBackgroundColor: const Color(0xFF2A2823),
                                  foregroundColor: Colors.black87,
                                  disabledForegroundColor: Colors.black38,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                                child: _isSaving
                                    ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: Colors.black87,
                                  ),
                                )
                                    : const Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              'Profile Type: ${_profileTypeLabel(widget.profileType)}',
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}