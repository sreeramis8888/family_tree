import 'package:familytree/src/data/api_routes/events_api/events_api.dart';
import 'package:familytree/src/data/models/events_model.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:familytree/src/interface/screens/approvals/approvals_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventDetailsSheet extends StatelessWidget {
  final String status;
  final String eventId;

  const EventDetailsSheet(
      {super.key, required this.status, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Consumer(
          builder: (context, ref, _) {
            final asyncEvent = ref.watch(fetchEventWithPersonProvider(eventId));
            return asyncEvent.when(
              loading: () => const Center(child: LoadingAnimation()),
              error: (error, stackTrace) => Center(child: Text('Error: $error')),
              data: (data) {
                final Event = data.event;
                final fullName = data.fullName;
                final phoneNo = data.phone;
                final isPending = Event.status;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
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
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        if (status != 'pending')
                          _buildDetailRow(
                            'Event Status',
                            status,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: status == 'Approved' ? Colors.green : Colors.red,
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
                        const SizedBox(height: 12),
                        _buildDetailRow('Member name', fullName),
                        const SizedBox(height: 12),
                        _buildDetailRow('Mobile Number', phoneNo),
                        const SizedBox(height: 12),
                        _buildDetailRow('Event Title', Event.eventName.toString(), isLarge: true),
                        const SizedBox(height: 12),
                        _buildDetailRow('Content', Event.description.toString(), isLarge: true),
                        const SizedBox(height: 12),
                        _buildDetailRow('Event Date', DateFormat('dd MMM yyyy – hh:mm a').format(DateTime.parse(Event.eventStartDate.toString()))),
                        const SizedBox(height: 12),
                        _buildDetailRow('Location', Event.venue.toString()),
                        const SizedBox(height: 12),
                        _buildDetailRow('Organizer Name', Event.organiserName.toString()),
                        const SizedBox(height: 12),
                        _buildDetailRow('Media', Event.image.toString(),
                          child: GestureDetector(
                            onTap: () {},
                            child: Image.network(
                              Event.image.toString(),
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (status == 'Pending')
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 237, 235, 235),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await updateEventStatus(
                                      status: "rejected", eventId: eventId,
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const ApprovalsPage(
                                          initialChipIndex: 1, // Notification Approvals
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
                                    backgroundColor: Color(0xFF228B22),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await updateEventStatus(
                                      status: "approved", eventId: eventId,
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const ApprovalsPage(
                                          initialChipIndex: 1, // Notification Approvals
                                          initialTabIndex: 0, // Pending Tab
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Approve',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
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
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
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
                height: 1.0,
                letterSpacing: 0,
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
                      letterSpacing: 0,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: isLarge ? null : 1,
                    overflow:
                        isLarge ? TextOverflow.visible : TextOverflow.ellipsis,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
