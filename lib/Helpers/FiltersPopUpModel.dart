import 'package:flutter/material.dart';

class FilterPopup extends StatefulWidget {
  final String? initialGenre;
  final int? initialArtistType;
  final int initialRating;
  final double initialPrice;
  final int initialMembers;
  final bool initialHasPriceFilter;
  final bool initialHasMembersFilter;

  const FilterPopup({
    super.key,
    this.initialGenre,
    this.initialArtistType,
    required this.initialRating,
    required this.initialPrice,
    required this.initialMembers,
    required this.initialHasPriceFilter,
    required this.initialHasMembersFilter,
  });

  @override
  State<FilterPopup> createState() => _FilterPopupState();
}

class _FilterPopupState extends State<FilterPopup> {
  String? selectedGenre;
  int? selectedArtistType;
  int selectedRating = 0;
  double selectedPrice = 0;
  double selectedMembers = 1;
  bool hasPriceFilter = false;
  bool hasMembersFilter = false;

  @override
  void initState() {
    super.initState();
    selectedGenre = widget.initialGenre;
    selectedArtistType = widget.initialArtistType;
    selectedRating = widget.initialRating;
    selectedPrice = widget.initialPrice;
    selectedMembers = widget.initialMembers.toDouble();
    hasPriceFilter = widget.initialHasPriceFilter;
    hasMembersFilter = widget.initialHasMembersFilter;
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF27272A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Filters',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Search Type',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Material(
                    color: const Color(0xFF27272A),
                    elevation: 6,
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        setState(() {
                          selectedArtistType = 2;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: selectedArtistType == 2
                                ? const Color(0xffffc21c)
                                : Colors.white24,
                            width: 1.5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 72,
                                child: Image.asset(
                                  'assets/images/rock.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 6,
                                ),
                                child: Text(
                                  'Solo',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Material(
                    color: const Color(0xFF27272A),
                    elevation: 6,
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        setState(() {
                          selectedArtistType = 1;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: selectedArtistType == 1
                                ? const Color(0xffffc21c)
                                : Colors.white24,
                            width: 1.5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 72,
                                child: Image.asset(
                                  'assets/images/pop.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 6,
                                ),
                                child: Text(
                                  'Band',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Material(
                    color: const Color(0xFF27272A),
                    elevation: 6,
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        setState(() {
                          selectedArtistType = 3;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: selectedArtistType == 3
                                ? const Color(0xffffc21c)
                                : Colors.white24,
                            width: 1.5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 72,
                                child: Image.asset(
                                  'assets/images/jazz.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 6,
                                ),
                                child: Text(
                                  'Venue',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 38,
              child: DropdownButtonFormField<String>(
                value: selectedGenre,
                dropdownColor: const Color(0xFF27272A),
                iconEnabledColor: Colors.white,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF3A3A3D),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xffffc21c),
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xffffc21c),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xffffc21c),
                      width: 2,
                    ),
                  ),
                ),
                hint: const Text(
                  'Select Genre',
                  style: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
                items: const [
                  DropdownMenuItem(
                    value: 'Rock',
                    child: Text('Rock'),
                  ),
                  DropdownMenuItem(
                    value: 'Pop',
                    child: Text('Pop'),
                  ),
                  DropdownMenuItem(
                    value: 'Jazz',
                    child: Text('Jazz'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedGenre = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
            children: [ Text(
              'Rating:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
        SizedBox(width: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final starNumber = index + 1;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedRating = selectedRating == starNumber ? 0 : starNumber;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 11),
                child: Icon(
                  Icons.star,
                  color: starNumber <= selectedRating
                      ? const Color(0xffffc21c)
                      : Colors.white24,
                  size: 24,
                ),
              ),
            );
          }),
        ),
            ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Max Price:',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(width: 180),
                Text('£${selectedPrice.round()}',
                  style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              ],
            ),
            Slider(
              value: selectedPrice,
              min: 0,
              max: 500,
              divisions: 50,
              activeColor: const Color(0xffffc21c),
              inactiveColor: Colors.white24,
              label: '£${selectedPrice.round()}',
              onChanged: (value) {
                setState(() {
                  selectedPrice = value;
                  hasPriceFilter = true;
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
            Text(
              'Members:',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
                SizedBox(width: 187),

                Text('${selectedMembers.round()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            Slider(
              value: selectedMembers,
              min: 1,
              max: 10,
              divisions: 9,
              activeColor: const Color(0xffffc21c),
              inactiveColor: Colors.white24,
              label: '${selectedMembers.round()}',
              onChanged: (value) {
                setState(() {
                  selectedMembers = value;
                  hasMembersFilter = true;
                });
              },
            ),

            const SizedBox(height: 12),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 190,
                height: 28,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffffc21c),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, {
                      'genre': selectedGenre,
                      'profileType': selectedArtistType,
                      'rating': selectedRating,
                      'price': selectedPrice,
                      'members': selectedMembers,
                      'hasPriceFilter': hasPriceFilter,
                      'hasMembersFilter': hasMembersFilter,
                    });
                  },
                  child: const Text('Apply',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Future<Map<String, dynamic>?> showFilterPopup(
    BuildContext context, {
      String? initialGenre,
      int? initialArtistType,
      required int initialRating,
      required double initialPrice,
      required int initialMembers,
      required bool initialHasPriceFilter,
      required bool initialHasMembersFilter,
    }) {
  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) => FilterPopup(
      initialGenre: initialGenre,
      initialArtistType: initialArtistType,
      initialRating: initialRating,
      initialPrice: initialPrice,
      initialMembers: initialMembers,
      initialHasPriceFilter: initialHasPriceFilter,
      initialHasMembersFilter: initialHasMembersFilter,
    ),
  );
}
