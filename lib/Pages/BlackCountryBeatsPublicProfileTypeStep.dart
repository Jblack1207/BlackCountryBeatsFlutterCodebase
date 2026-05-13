import 'package:flutter/material.dart';
import 'package:flutter_project_cmp3023/Pages/BlackCountryBeatsCreatePublicProfilePage.dart';

class BlackCountryBeatsPublicProfileTypeStep extends StatefulWidget {
  const BlackCountryBeatsPublicProfileTypeStep({super.key});

  @override
  State<BlackCountryBeatsPublicProfileTypeStep> createState() =>
      _BlackCountryBeatsPublicProfileTypeStepState();
}

class _BlackCountryBeatsPublicProfileTypeStepState
    extends State<BlackCountryBeatsPublicProfileTypeStep> {
  int? _selectedProfileType;

  Widget _buildTypeCard({
    required int value,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedProfileType == value;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        setState(() {
          _selectedProfileType = value;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xffffc21c).withOpacity(0.95)
              : const Color(0xFF27272A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.white24,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(
                color: isSelected ? Colors.black87 : Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const Text(
            'Choose your Account Type',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This selection should be based on what type of User you are and what Accounts you want to attract.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),
          _buildTypeCard(
            value: 1,
            title: 'Band',
            subtitle: 'For groups, bands, and multi-member acts.',
          ),
          const SizedBox(height: 14),
          _buildTypeCard(
            value: 2,
            title: 'Solo',
            subtitle: 'For solo artists and independent performers.',
          ),
          const SizedBox(height: 14),
          _buildTypeCard(
            value: 3,
            title: 'Venue',
            subtitle: 'For venues, spaces, and event locations.',
          ),

          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedProfileType == null
                  ? null
                  : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlackCountryBeatsCreatePublicProfilePage(
                      profileType: _selectedProfileType!,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffffc21c).withOpacity(0.95),
                foregroundColor: Colors.black,
                disabledBackgroundColor: const Color(0xFF3A3A3D),
                disabledForegroundColor: Colors.white54,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Next',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
