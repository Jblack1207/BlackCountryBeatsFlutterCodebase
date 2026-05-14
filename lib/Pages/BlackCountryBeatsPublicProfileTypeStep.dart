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
    const double topSectionHeight = 120;

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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Create Your Profile',
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
            child: Padding(
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
                  Align(
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _selectedProfileType == null
                            ? null
                            : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  BlackCountryBeatsCreatePublicProfilePage(
                                    profileType: _selectedProfileType!,
                                  ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xffffc21c).withOpacity(0.95),
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
