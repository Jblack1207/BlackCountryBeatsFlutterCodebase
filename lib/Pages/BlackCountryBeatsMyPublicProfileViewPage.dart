import 'package:flutter/material.dart';

class BlackCountryBeatsMyPublicProfileViewPage extends StatelessWidget {
  final Map<String, dynamic> profile;

  const BlackCountryBeatsMyPublicProfileViewPage({
    super.key,
    required this.profile,
  });

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

  Widget _buildDetailCard(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF27272A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFFD000),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value.isEmpty ? 'Not set' : value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = (profile['profileImage'] ?? '').toString();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 38,
                backgroundColor: const Color(0xFF3A3A3D),
                backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                child: imageUrl.isEmpty
                    ? const Icon(Icons.person, color: Colors.white, size: 34)
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  (profile['profileName'] ?? 'Unknown').toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildDetailCard('Bio', (profile['bio'] ?? '').toString()),
          const SizedBox(height: 12),
          _buildDetailCard('Genre', (profile['genre'] ?? '').toString()),
          const SizedBox(height: 12),
          _buildDetailCard('Price', '${profile['price'] ?? 0}'),
          const SizedBox(height: 12),
          _buildDetailCard('Members', '${profile['members'] ?? 1}'),
          const SizedBox(height: 12),
          _buildDetailCard(
            'Profile Type',
            _profileTypeLabel((profile['profileType'] as num?)?.toInt()),
          ),
        ],
      ),
    );
  }
}
