import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeWithoutMember extends StatefulWidget {
  const HomeWithoutMember({super.key});

  @override
  State<HomeWithoutMember> createState() => _HomeWithoutMemberState();
}

class _HomeWithoutMemberState extends State<HomeWithoutMember> {
  final Map<String, List<Map<String, String>>> pendingApprovals = {
    'Member': [
      {
        'title': 'Member – Muhammed',
        'subtitle': 'Aliyar Family',
        'date': '02/02/1999-',
      },
      {
        'title': 'Member – Ahmed',
        'subtitle': 'Aliyar Family',
        'date': '03/03/2000-',
      },
      {
        'title': 'Member – Zainab',
        'subtitle': 'Aliyar Family',
        'date': '04/04/2001-',
      },
      {
        'title': 'Member – Fatima',
        'subtitle': 'Aliyar Family',
        'date': '05/05/2002-',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
  centerTitle: true,
  title: Text(
    "Kalathingal Family",
    style: GoogleFonts.roboto(
      fontSize: 16,
      color: const Color(0xff272727),
      fontWeight: FontWeight.w500,
    ),
  ),
  leading: Padding(
    padding: const EdgeInsets.only(left: 8.0),
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
  actions: [
    SizedBox(width: 48), // Balances the leading icon space
  ],
),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Kalathingal Family",
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xffE83A33)
                ),
              ),
              const SizedBox(height: 24),
              // Loop through all pending approvals and display them
              for (String category in pendingApprovals.keys)
                for (Map<String, String> item in pendingApprovals[category]!)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(
                              'assets/pngs/approval-profile.jpg',
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Title & Subtitle
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'] ?? '',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    height: 1.31,
                                    color: const Color(0xff272727),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item['subtitle'] ?? '',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                    height: 1.31,
                                     color: const Color(0xff272727)
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              
                                Text(
                                  item['date'] ?? '',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 11,
                                    height: 1.31,
                                    color: const Color(0xff979797),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // More icon
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  // Handle view tap
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
      floatingActionButton: RawMaterialButton(
        onPressed: () {
          // Add media logic
        },
        fillColor: const Color(0xffE30613),
        shape: const CircleBorder(),
        elevation: 6,
        constraints: const BoxConstraints.tightFor(width: 62, height: 62),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
