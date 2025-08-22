import 'package:familytree/src/data/api_routes/request_api/request_api.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:familytree/src/interface/screens/approvals/approvals_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:familytree/src/data/models/request_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailsSheet extends StatelessWidget {
  final String status;
  final String requestId;
  final String familyName;

  const DetailsSheet({
    super.key,
    required this.familyName,
    required this.status,
    required this.requestId,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65, // ↓ reduced from 0.85
      minChildSize: 0.3, // ↓ reduced from 0.4
      maxChildSize: 0.9, // ↓ reduced from 0.95
      expand: false,
      builder: (context, scrollController) {
        return Consumer(
          builder: (context, ref, _) {
            final asyncRequest = ref.watch(
                fetchRequestWithPersonAndRelationshipsProvider(requestId));
            return asyncRequest.when(
              loading: () => const Center(child: LoadingAnimation()),
              error: (error, stackTrace) =>
                  Center(child: Text('Error: $error')),
              data: (data) {
                final request = data.request;
                final fullName = data.fullName;
                final phone = data.phone;

                final rows = <Widget>[
                  if (status != 'Pending')
                    _buildDetailRow(
                      'Membership Status',
                      status,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color:
                              status == 'Approved' ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  _buildDetailRow('Member Name', request.fullName),
                  const SizedBox(height: 12),
                  _buildDetailRow('Gender', request.gender ?? 'N/A'),
                  const SizedBox(height: 12),
                  _buildDetailRow('Mobile Number', request.phone ?? phone),
                  const SizedBox(height: 12),
                  _buildDetailRow('Family Name', familyName),
                  const SizedBox(height: 12),
                ];

                if (request.relationships.isNotEmpty) {
                  final firstRel = request.relationships.first;
                  rows.addAll([
                    _buildDetailRow('Link to Family Member 1',
                        firstRel.relatedPersonName ?? 'N/A'),
                    const SizedBox(height: 12),
                    _buildDetailRow('Relation', firstRel.type),
                  ]);
                }

                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 40,
                                  height: 4,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              const Text(
                                'Details',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...rows,
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                      if (status == 'Pending') ...[
                        const Divider(),
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
                                onPressed: () async {
                                  await updateRequestStatus(
                                    status: "rejected",
                                    requestId: requestId,
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const ApprovalsPage(
                                        initialChipIndex:
                                            0, // Notification Approvals
                                        initialTabIndex: 0, // Pending Tab
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Reject',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
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
                                onPressed: () async {
                                  await updateRequestStatus(
                                    status: "approved",
                                    requestId: requestId,
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const ApprovalsPage(
                                        initialChipIndex:
                                            0, // Notification Approvals
                                        initialTabIndex: 0, // Pending Tab
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Approve',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ]
                    ],
                  ),
                );
              },
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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  height: 1.3,
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
                        height: 1.5,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: isLarge ? null : 1,
                      overflow: isLarge
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
