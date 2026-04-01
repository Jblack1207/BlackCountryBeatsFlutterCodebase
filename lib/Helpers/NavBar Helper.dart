import 'package:flutter/material.dart';

class BcbBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const BcbBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const double barHeight = 64;
    const double highlightSize = 60;
    const double centerButtonSize = 74;

    return SizedBox(
      height: 90,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double barWidth = constraints.maxWidth;
          final double slotWidth = barWidth / 5;
          final double highlightLeft =
              (slotWidth * selectedIndex) + (slotWidth - highlightSize) / 2;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 13,
                child: Container(
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: const Color(0xFF27272A),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Colors.white24,
                      width: 1,
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOut,
                left: highlightLeft,
                top: 15,
                child: IgnorePointer(
                  child: Container(
                    width: highlightSize,
                    height: highlightSize,
                    decoration: const BoxDecoration(
                      color: Color(0xffffc21c),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 13,
                height: barHeight,
                child: Row(
                  children: [
                    _navSlot(icon: Icons.home, index: 0, onTap: onTap),
                    _navSlot(icon: Icons.search_sharp, index: 1, onTap: onTap),
                    const Expanded(child: SizedBox()),
                    _navSlot(icon: Icons.message, index: 3, onTap: onTap),
                    _navSlot(icon: Icons.person_pin, index: 4, onTap: onTap),
                  ],
                ),
              ),
              Positioned(
                left: (barWidth - centerButtonSize) / 2,
                top: 5,
                child: IgnorePointer(
                  child: Container(
                    width: centerButtonSize,
                    height: centerButtonSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF27272A),
                      border: Border.all(
                        color: const Color(0xFF1F1F1F),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        'assets/images/NavBarImg.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _navSlot({
    required IconData icon,
    required int index,
    required ValueChanged<int> onTap,
  }) {
    return Expanded(
      child: Center(
        child: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            print('Nav icon tapped: $index');
            onTap(index);
          },
          icon: Icon(
            icon,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}
