import 'package:flutter/material.dart';
import 'package:flutter_project_cmp3023/Pages/BlackCountryBeatsHomePage.dart';
import 'package:flutter_project_cmp3023/Pages/BlackCountryBeatsMessageHomePage.dart';

import '../Helpers/NavBar Helper.dart';
import 'package:flutter_project_cmp3023/Pages/BlackCountryBeatsSearchPage.dart';

class BlackCountryBeatsShellPage extends StatefulWidget {
  const BlackCountryBeatsShellPage({super.key});

  @override
  State<BlackCountryBeatsShellPage> createState() =>
      _BlackCountryBeatsShellPageState();
}

class _BlackCountryBeatsShellPageState
    extends State<BlackCountryBeatsShellPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    BlackCountryBeatsHomePage(),
    BlackCountryBeatsSearchPage(),
    SizedBox(),
    BlackCountryBeatsMessageHomePage(),
    Placeholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1F1F1F),
      body: Stack(
          children: [
            Positioned.fill(
              child: _pages[_selectedIndex],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.only(top: 34, right: 25, left: 25, bottom: 6),
                child: BcbBottomNav(
                  selectedIndex: _selectedIndex,
                  onTap: (index) {
                    print('Tapped index: $index');
                    if (index == 2) {
                      return;
                    }

                    setState(() {
                      _selectedIndex = index;
                      print('New selectedIndex: $_selectedIndex');
                    });
                  },
                ),
              ),
            )
          ],
        ),
      );
  }
}
