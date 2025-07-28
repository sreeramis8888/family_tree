import 'package:familytree/src/data/api_routes/requirements_api/requirements_api.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:familytree/src/data/models/feeds_model.dart';
import 'package:familytree/src/data/globals.dart';

class PostDetailsSheet extends StatelessWidget {
  final String postId;
  final String status;

  const PostDetailsSheet({
    super.key,
    required this.status,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return FutureBuilder<FeedWithPerson>(
          future: fetchFeedWithPerson(postId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingAnimation());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final data = snapshot.data!;
            final feed = data.feed;
            final fullName = data.fullName;
            final phoneNo = data.phone;

            final isPending = feed.status.toLowerCase() == 'unpublished';

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 40, left: 16, right: 16, bottom: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const Text(
                      'Post Details',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 18),
                    if (!isPending)
                      _buildDetailRow(
                        'Post Status',
                        feed.status,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _statusColor(feed.status),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _statusLabel(feed.status),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 18),
                    _buildDetailRow('Member name', fullName),
                    _buildDetailRow('Phone no', phoneNo),
                    const SizedBox(height: 18),
                    _buildDetailRow('Type', feed.type),
                    const SizedBox(height: 18),
                    _buildDetailRow(
                      'Content',
                      feed.content ?? 'No Content',
                      isLarge: true,
                    ),
                    const SizedBox(height: 18),
                    if (feed.media != null && feed.media!.isNotEmpty)
                      _buildDetailRow(
                        'Media',
                        feed.media!,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                backgroundColor: Colors.transparent,
                                child: InteractiveViewer(
                                  child: Image.network(feed.media!),
                                ),
                              ),
                            );
                          },
                          child: Image.network(
                            feed.media!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    if (isPending)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 237, 235, 235),
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              onPressed: () =>
                                  _updateStatus(context, 'rejected'),
                              child: const Text('Reject'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF228B22),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              onPressed: () => _updateStatus(context, 'accept'),
                              child: const Text('Approve'),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(
    String title,
    String value, {
    Widget? child,
    bool isLarge = false,
  }) {
    return Container(
      width: double.infinity,
      height: isLarge ? 134 : 60,
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.topRight,
              child: child ??
                  Text(
                    value,
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: isLarge ? 5 : 1,
                    overflow: TextOverflow.ellipsis,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateStatus(BuildContext context, String action) async {
    try {
      await updateFeedStatus(feedId: postId, action: action);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post $action successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to $action post: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'published':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'unpublished':
        return 'Pending';
      default:
        return 'Unknown';
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'published':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'unpublished':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }
}
