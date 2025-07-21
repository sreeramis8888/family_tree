import 'package:familytree/src/data/api_routes/news_api/news_api.dart';
import 'package:familytree/src/interface/screens/main_pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/models/news_model.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'news_page.dart';

class NewsListPage extends ConsumerWidget {
  const NewsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncNews = ref.watch(fetchNewsProvider);

    return Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kWhite,
          scrolledUnderElevation: 0,
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              children: [
                Icon(Icons.feed_outlined, color: kPrimaryColor, size: 22),
                SizedBox(width: 8),
                Text(
                  "News",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // actions: [
          //   Stack(
          //     children: [
          //       IconButton(
          //         icon: Icon(Icons.bookmark, color: kPrimaryColor, size: 22),
          //         onPressed: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(builder: (context) => BookmarkPage()),
          //           );
          //         },
          //       ),
          //       Positioned(
          //         right: 5,
          //         top: 5,
          //         child: Container(
          //           padding: EdgeInsets.all(2),
          //           decoration: BoxDecoration(
          //             color: Colors.red,
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //           constraints: BoxConstraints(
          //             minWidth: 14,
          //             minHeight: 14,
          //           ),
          //           child: Text(
          //             '3', // Placeholder for bookmark count
          //             style: TextStyle(
          //               color: kWhite,
          //               fontSize: 10,
          //             ),
          //             textAlign: TextAlign.center,
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          //   SizedBox(width: 16),
          // ],
        ),
        body: asyncNews.when(
          data: (news) {
            if (news.isNotEmpty) {
              return Column(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 16.0, vertical: 8.0),
                  //   child: TextField(
                  //     decoration: InputDecoration(
                  //       hintText: 'Search News',
                  //       hintStyle: TextStyle(color: Colors.grey[600]),
                  //       prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  //       // suffixIcon: IconButton(
                  //       //   icon: Icon(
                  //       //     Icons.filter_alt_outlined,
                  //       //     color: Colors.red[400],
                  //       //     size: 22,
                  //       //   ),
                  //       //   onPressed: () {
                  //       //     // Filter action
                  //       //   },
                  //       // ),
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(25),
                  //         borderSide:
                  //             BorderSide(color: Colors.grey[300]!, width: 1),
                  //       ),
                  //       enabledBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(25),
                  //         borderSide:
                  //             BorderSide(color: Colors.grey[300]!, width: 1),
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(25),
                  //         borderSide:
                  //             BorderSide(color: Colors.red[400]!, width: 1.5),
                  //       ),
                  //       filled: true,
                  //       fillColor: kWhite,
                  //       contentPadding:
                  //           EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: news.length,
                      itemBuilder: (context, index) {
                        return NewsCard(news: news[index], allNews: news);
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text('No News'),
              );
            }
          },
          loading: () => const Center(child: LoadingAnimation()),
          error: (error, stackTrace) => const Text('No News'),
        ));
  }
}

class NewsCard extends ConsumerWidget {
  final News news;
  final List<News> allNews;

  const NewsCard({Key? key, required this.news, required this.allNews})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = timeAgo(news.updatedAt!);

    return GestureDetector(
      onTap: () {
        final initialIndex = allNews.indexOf(news);
        if (initialIndex != -1) {
          ref.read(currentNewsIndexProvider.notifier).state = initialIndex;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailView(news: allNews),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: kWhite,
            border: Border.all(color: kTertiary),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.network(
                news.media ?? '',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(9),
                      bottomLeft: Radius.circular(9),
                    ),
                  ),
                  child: Icon(Icons.broken_image, color: Colors.grey[600]),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: Icon(Icons.more_vert, color: Colors.grey),
                onPressed: () {
                  // More options action
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
