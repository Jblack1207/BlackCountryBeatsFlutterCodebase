//BCB Homepage
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseUsersSearch Helper.dart';

import 'BlackCountryBeatsUserProfilePage.dart';


class BlackCountryBeatsSearchPage extends StatefulWidget {
  const BlackCountryBeatsSearchPage({super.key});


  @override
  State<BlackCountryBeatsSearchPage> createState() =>
      _BlackCountryBeatsSearchPageState();
}


///class state definitions and logic control
class _BlackCountryBeatsSearchPageState
    extends State<BlackCountryBeatsSearchPage> {

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
                                controller: _searchController,
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                  });
                                },
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
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: SearchService().searchProfiles(_searchQuery),
                      builder: (context, snapshot) {
                        if (_searchQuery.trim().length < 3) {
                          return const Text(
                            'To Search for a Profile please enter 3 or More Characters in the Search bar above, or use the Filters button adjacent',
                            style: TextStyle(color: Colors.white),
                          );
                        }


                        if (snapshot.connectionState == ConnectionState.waiting && _searchQuery.length > 2) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Text(
                            'Failed to load results',
                            style: TextStyle(color: Colors.white),
                          );
                        }

                        final results = snapshot.data ?? [];

                        if (results.isEmpty && _searchQuery.length > 2) {
                          return const Text(
                            'No results found',
                            style: TextStyle(color: Colors.white),
                          );
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: results.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.82,
                          ),
                          itemBuilder: (context, index) {
                            final profile = results[index];

                            return InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlackCountryBeatsUserProfilePage(
                                        userId: profile['id'],
                                      ),
                                    ),
                                  );
                                },
                             child: Container(
                              padding: const EdgeInsets.only(bottom: 10, right: 2, left: 2, top: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF27272A),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white24,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                                      child: (profile['profileImage'] ?? '').toString().isEmpty
                                          ? Container(
                                        width: double.infinity,
                                        color: const Color(0xFF3A3A3D),
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      )
                                          : Image.network(
                                        profile['profileImage'],
                                        width: double.infinity,
                                        fit: BoxFit.fill,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: const Color(0xFF3A3A3D),
                                          child: const Icon(
                                            Icons.broken_image,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    profile['profileName'] ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                             )
                            );
                          },
                        );
                      },
                    )

                  ]
              )
            ]
        )
    );
  }
}