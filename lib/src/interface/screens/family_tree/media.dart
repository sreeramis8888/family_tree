import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PhotoGalleryPage extends StatefulWidget {
  const PhotoGalleryPage({super.key});

  @override
  State<PhotoGalleryPage> createState() => _PhotoGalleryPageState();
}

class _PhotoGalleryPageState extends State<PhotoGalleryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> photoPaths = [
    'assets/pngs/media.1.jpg',
    'assets/pngs/media.2.jpg',
    'assets/pngs/media.3.jpg',
    'assets/pngs/media.4.jpg',
  ];

  final List<Map<String, String>> videos = [
    {'thumbnail': 'assets/pngs/vedio.1.jpg', 'title': 'Video title'},
    {'thumbnail': 'assets/pngs/vedio.2.jpg', 'title': 'Video title'},
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
       appBar:AppBar(
         backgroundColor: Colors.white,
         forceMaterialTransparency: true,
  centerTitle: true,
  title: Text(
    "Media",
    style: GoogleFonts.roboto(
      fontSize: 16,
      color: Color(0xff272727),
      fontWeight: FontWeight.w500,
    ),
  ),
  leading: Padding(
    padding: const EdgeInsets.only(left: 8, top: 6),
    child: IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: const Icon(
        Icons.arrow_back_ios,
        size: 12,
        color: Colors.black,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  ),
  elevation: 1,
  bottom: TabBar(
  controller: _tabController,
  labelColor: Colors.red,
  unselectedLabelColor: Colors.black54,
  indicator: UnderlineTabIndicator(
    borderSide: const BorderSide(width: 4, color: Colors.red,), // thickness & color
    insets: EdgeInsets.symmetric(horizontal: screenWidth/3 ), // controls the width
  ),
  tabs: const [
    Tab(text: "Photos"),
    Tab(text: "Videos"),
  ],
),

),

      body: TabBarView(
        controller: _tabController,
        children: [
          // Photos Grid
          Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              itemCount: photoPaths.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Image.asset(photoPaths[index], fit: BoxFit.cover),
                );
              },
            ),
          ),

          // Video list
          ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.asset(
                          videos[index]['thumbnail']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 180,
                        ),
                      ),
                       SvgPicture.asset(
                        'assets/svg/icons/logos_youtube-icon.svg'
,
                        width: 46,
                        height: 32,
                      
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    videos[index]['title']!,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ],
      ),
    floatingActionButton: RawMaterialButton(
        onPressed: () {
          // Add media logic here
        },
        fillColor: Color(0xffE30613),
        shape: const CircleBorder(),
        elevation: 6,
        constraints: const BoxConstraints.tightFor(width: 62, height: 62),
        child: const Icon(Icons.add, color: Colors.white),
      ),


    );
  }
}
