import 'package:flutter/material.dart';

class BlackCountryBeatsMyPublicProfileViewPage extends StatelessWidget {
  final Map<String, dynamic> profile;

  const BlackCountryBeatsMyPublicProfileViewPage({
    super.key,
    required this.profile,
  });

  //_profileType label conversaion num -> string
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
                  text: value.isEmpty ? 'Not set' : value,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //gap between image and top of screen
    final topInset = (MediaQuery.of(context).padding.top - 60).clamp(0.0, double.infinity);
    //profile banner image
    final bannerImage = (profile['backgroundImage'] ?? '').toString();
    //profile image
    final profileImage = (profile['profileImage'] ?? '').toString();
    //profile Name
    final profileName = (profile['profileName'] ?? '').toString();
    //bio
    final bio = (profile['bio'] ?? '').toString();
    //location
    final location = (profile['location'] ?? '').toString();
    //genre
    final genre = (profile['genre'] ?? '').toString();
    //avg price per night
    final priceValue = profile['avgPricePerNight'];
    //follows
    final followers = '${profile['followers'] ?? 0}';
    //rating - needs expansion
    final rating = (profile['rating'] as num?)?.toDouble() ?? 0;


    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
                                    child: Container(
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2A2823),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.person_add_alt_1,
                                              size: 22,
                                              color: Colors.black26,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Follow',
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
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Container(
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2A2823),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.mail_outline,
                                              size: 22,
                                              color: Colors.black26,
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
                                'Add a Post +',
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
        },
      ),
    );
  }
}
