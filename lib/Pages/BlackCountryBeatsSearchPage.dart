//BCB Search Page
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_project_cmp3023/Helpers/FiltersPopUpModel.dart';
import 'package:flutter_project_cmp3023/Pages/BlackCountryBeatsUserProfilePage.dart';
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebasePublicProfileFilter Helper.dart';



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

  String? _selectedGenre;
  int? _selectedArtistType;
  int _selectedRating = 0;
  double _selectedPrice = 500;
  int _selectedMembers = 10;
  bool _hasPriceFilter = false;
  bool _hasMembersFilter = false;


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 80,
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
              const SizedBox(height: 18),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
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
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () async {
                                final filters = await showDialog<Map<String, dynamic>>(
                                  context: context,
                                  builder: (context) => FilterPopup(
                                    initialGenre: _selectedGenre,
                                    initialArtistType: _selectedArtistType,
                                    initialRating: _selectedRating,
                                    initialPrice: _selectedPrice,
                                    initialMembers: _selectedMembers,
                                    initialHasPriceFilter: _hasPriceFilter,
                                    initialHasMembersFilter: _hasMembersFilter,
                                  ),
                                );

                                if (filters != null) {
                                  setState(() {
                                    _selectedGenre = filters['genre'] as String?;
                                    _selectedArtistType = (filters['profileType'] as num?)?.toInt();
                                    _selectedRating = (filters['rating'] as num?)?.toInt() ?? 0;
                                    _selectedPrice = (filters['price'] as num?)?.toDouble() ?? 0;
                                    _selectedMembers = (filters['members'] as num?)?.toInt() ?? 0;
                                    _hasPriceFilter = filters['hasPriceFilter'] as bool? ?? false;
                                    _hasMembersFilter = filters['hasMembersFilter'] as bool? ?? false;
                                  });
                                }
                              },
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

                    const SizedBox(height: 14),
                    //TEXT AND QUERY SEARCH
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: PublicProfileSearchService().searchPublicProfiles(
                        query: _searchQuery,
                        genre: _selectedGenre,
                        profileType: _selectedArtistType,
                        minimumRating: _selectedRating == 0 ? null : _selectedRating,
                        maxPrice: _hasPriceFilter ? _selectedPrice : null,
                        maxMembers: _hasMembersFilter ? _selectedMembers.round() : null,
                      ),
                      builder: (context, snapshot) {
                        final hasTextSearch = _searchQuery.trim().length >= 3;
                        final hasFilters = _selectedGenre != null ||
                            _selectedArtistType != null ||
                            _selectedRating > 0 ||
                            _hasPriceFilter ||
                            _hasMembersFilter;

                        if (!hasTextSearch && !hasFilters) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                'TIP: To Search for a Profile please enter 3 or more characters in the Search Bar above, or use the Filters button adjacent',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                'Error, please contact the Support Desk',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        }

                        final results = snapshot.data ?? [];

                        if (results.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                'No Results Found, please amend your search to try again',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                'Results',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: results.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 28,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1,
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
                                    padding: const EdgeInsets.only(bottom: 10),
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
                                            borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              topLeft: Radius.circular(20),
                                            ),
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
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                          ],
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