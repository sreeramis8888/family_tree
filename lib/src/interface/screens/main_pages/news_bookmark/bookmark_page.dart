import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/data/models/news_model.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'news_page.dart';
import 'news_list_page.dart';

class BookmarkPage extends ConsumerWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedIds = ref.watch(bookmarkedNewsProvider);

    // Get mock news data from NewsListPage for UI demonstration consistency
    final mockNews = NewsListPage.getMockNews(); // Access mock news data

    final bookmarkedNews =
        mockNews.where((news) => bookmarkedIds.contains(news.id)).toList();

    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Bookmarks",
          style: TextStyle(fontSize: 17),
        ),
        backgroundColor: kWhite,
        scrolledUnderElevation: 0,
      ),
      body: bookmarkedNews.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No bookmarked news yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: bookmarkedNews.length,
              itemBuilder: (context, index) {
                final newsItem = bookmarkedNews[index];
                return GestureDetector(
                  onTap: () {
                    final initialIndex = mockNews.indexOf(newsItem);
                    if (initialIndex != -1) {
                      ref.read(currentNewsIndexProvider.notifier).state =
                          initialIndex;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailView(news: mockNews),
                        ),
                      );
                    }
                  },
                  child: BookmarkNewsCard(
                    news: newsItem,
                    onBookmarkRemoved: () {
                      ref
                          .read(bookmarkedNewsProvider.notifier)
                          .toggleBookmark(newsItem.id!);
                    },
                  ),
                );
              },
            ),
    );
  }
}

class BookmarkNewsCard extends StatelessWidget {
  final News news;
  final VoidCallback onBookmarkRemoved;

  const BookmarkNewsCard({
    Key? key,
    required this.news,
    required this.onBookmarkRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('MMM dd, yyyy, hh:mm a').format(news.updatedAt!.toLocal());

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    news.media ?? '',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return ShimmerLoadingEffect(
                        child: Container(
                          width: double.infinity,
                          color: Colors.grey[300],
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return ShimmerLoadingEffect(
                        child: Container(
                          width: double.infinity,
                          color: Colors.grey[300],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: Icon(
                    Icons.bookmark,
                    color: kPrimaryColor,
                    size: 28,
                  ),
                  onPressed: onBookmarkRemoved,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromARGB(255, 192, 252, 194),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 10,
                    ),
                    child: Text(
                      news.category ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  news.title ?? '',
                  style: kHeadTitleB,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Spacer(),
                    Text(
                      calculateReadingTimeAndWordCount(news.content ?? ''),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String calculateReadingTimeAndWordCount(String text) {
  List<String> words = text.trim().split(RegExp(r'\s+'));
  int wordCount = words.length;
  const int averageWPM = 250;
  double readingTimeMinutes = wordCount / averageWPM;
  int minutes = readingTimeMinutes.floor();
  int seconds = ((readingTimeMinutes - minutes) * 60).round();
  String formattedTime;
  if (minutes > 0) {
    formattedTime = '$minutes min ${seconds > 0 ? '$seconds sec' : ''}';
  } else {
    formattedTime = '$seconds sec';
  }
  return '$formattedTime read';
}

class ShimmerLoadingEffect extends StatelessWidget {
  final Widget child;

  const ShimmerLoadingEffect({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: child,
    );
  }
}
