//BCB Homepage
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class BlackCountryBeatsSearchPage extends StatefulWidget {
  const BlackCountryBeatsSearchPage({super.key});


  @override
  State<BlackCountryBeatsSearchPage> createState() =>
      _BlackCountryBeatsSearchPageState();
}


///class state definitions and logic control
class _BlackCountryBeatsSearchPageState
    extends State<BlackCountryBeatsSearchPage> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 18,
          left: 18,
          right: 18,
          bottom: 130,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SvgPicture.asset(
                  'assets/images/BCBLongLogo.svg',
                  width: 240,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 42),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xFF3A3A3D),
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: Colors.white24,
                                  width: 1,
                                ),
                              ),
                              child: TextField(
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                cursorColor: Colors.white,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                  hintText: 'Search...',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 52,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffffc21c),
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Icon(
                                Icons.tune,
                                size: 24,
                              ),
                            ),
                          )
                        ]
                    ),
                    const SizedBox(height: 20),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          'Results',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                    )
                  ]
              )
            ]
        )
    );
  }
}