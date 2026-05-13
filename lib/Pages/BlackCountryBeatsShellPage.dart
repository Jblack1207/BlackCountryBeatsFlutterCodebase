import 'package:flutter/material.dart';
import 'package:flutter_project_cmp3023/Helpers/PresenceHelper.dart';
import 'package:flutter_project_cmp3023/Pages/BlackCountryBeatsHomePage.dart';
import 'package:flutter_project_cmp3023/Pages/BlackCountryBeatsMessageHomePage.dart';
import 'package:flutter_project_cmp3023/Pages/BlackCountryBeatsSearchPage.dart';
import '../Helpers/NavBar Helper.dart';
import 'BlackCountryBeatsPublicProfilePage.dart';

class BlackCountryBeatsShellPage extends StatefulWidget {
  const BlackCountryBeatsShellPage({super.key});

  @override
  State<BlackCountryBeatsShellPage> createState() =>
      _BlackCountryBeatsShellPageState();
}

class _BlackCountryBeatsShellPageState
    extends State<BlackCountryBeatsShellPage>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;
  final PresenceHelper _presenceService = PresenceHelper();

  final List<Widget> _pages = const [
    BlackCountryBeatsHomePage(),
    BlackCountryBeatsSearchPage(),
    SizedBox(),
    BlackCountryBeatsMessageHomePage(),
    BlackCountryBeatsPublicProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _presenceService.setOnline(true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _presenceService.setOnline(false);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _presenceService.setOnline(true);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _presenceService.setOnline(false);
    }
  }

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
              padding: const EdgeInsets.only(
                top: 34,
                right: 25,
                left: 25,
                bottom: 6,
              ),
              child: BcbBottomNav(
                selectedIndex: _selectedIndex,
                onTap: (index) {
                  if (index == 2) {
                    return;
                  }

                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
