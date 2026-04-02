//BCB Homepage
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseAuth Helper.dart';
import 'package:flutter_project_cmp3023/Firebase Helpers/FirebaseNews Helper.dart';





class BlackCountryBeatsHomePage extends StatefulWidget {
  const BlackCountryBeatsHomePage({super.key});


  @override
  State<BlackCountryBeatsHomePage> createState() =>
      _BlackCountryBeatsHomePageState();
}


///class state definitions and logic control
class _BlackCountryBeatsHomePageState
    extends State<BlackCountryBeatsHomePage> {
  String? firstName;
  final ScrollController _scrollController = ScrollController();

  Future<void> _loadFirstName() async {
    final name = await AuthService().getCurrentUserFirstName();

    setState(() {
      firstName = name;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFirstName();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: 45,
                          ),
                          const SizedBox(width: 6),
                          firstName == null
                              ? const Text(
                            'Welcome',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                              : RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'Welcome, ',
                                  style: TextStyle(color: Colors.white, fontSize: 25,
                                      fontWeight: FontWeight.w400),
                                ),
                                TextSpan(
                                  text: firstName,
                                  style: const TextStyle(
                                      color: Color(0xffffc21c),
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 70),
                          const Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: 40,
                          ),
                        ]
                    ),
                    const SizedBox(height: 28),
                    Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 10),
                          Text(
                            'Latest News',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ]
                    ),

                    const SizedBox(height: 10),

                    FutureBuilder<List<NewsItem>>(
                      future: NewsService().getPublishedNews(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                              'Failed to load news',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        final newsList = snapshot.data ?? [];

                        if (newsList.isEmpty) {
                          return const Center(
                            child: Text(
                              'No news available',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        return SizedBox(
                          height: 180,
                          child: ListView.builder(
                            itemCount: newsList.length,
                            itemBuilder: (context, index) {
                              final news = newsList[index];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  padding: const EdgeInsets.only(right: 20, left: 8, top: 5, bottom: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff27272A),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFF3A3A3D),
                                      width: 1.5,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          news.newsImage,
                                          width: 90,
                                          height: 90,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 90,
                                              height: 90,
                                              color: Colors.grey,
                                              child: const Icon(
                                                Icons.broken_image,
                                                color: Colors.white,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              news.newsTitle,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Color(0xffffc21c),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              news.newsDescription,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 18),

                    Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 10),
                          Text(
                            'Quick Search',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ]
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 30,
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: false,
                        child: ListView(
                          controller: _scrollController,

                          scrollDirection: Axis.horizontal,
                          children: [
                            SizedBox( width: 105,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  //enabled colouring
                                  backgroundColor: const Color(0xFF3A3A3D),
                                  foregroundColor: Colors.black,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                      color: Colors.white24,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: const Text('Band',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 30),
                            SizedBox( width: 105,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  //enabled colouring
                                  backgroundColor: const Color(0xFF3A3A3D),
                                  foregroundColor: Colors.black,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                      color: Colors.white24,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: const Text('Rock',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 30),
                            SizedBox( width: 105,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  //enabled colouring
                                  backgroundColor: const Color(0xFF3A3A3D),
                                  foregroundColor: Colors.black,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                      color: Colors.white24,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: const Text('Pop',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 30),
                            SizedBox( width: 105,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  //enabled colouring
                                  backgroundColor: const Color(0xFF3A3A3D),
                                  foregroundColor: Colors.black,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                      color: Colors.white24,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: const Text('Solo',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 30),
                            SizedBox( width: 105,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  //enabled colouring
                                  backgroundColor: const Color(0xFF3A3A3D),
                                  foregroundColor: Colors.black,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                      color: Colors.white24,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: const Text('Acoustic',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 10),
                          Text(
                            'Latest Messages',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ]
                    ),
                    //TO DO: ADD LATEST MESSAGES SECTION USING SOCKET.IO
                    Placeholder(child: Text('TO DO: ADD LATEST MESSAGES SECTION USING SOCKET.IO', style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),))
                  ]
              )
            ]
        )
    );
  }
}