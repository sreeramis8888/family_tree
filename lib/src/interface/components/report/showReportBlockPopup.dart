import 'package:familytree/src/data/api_routes/report_api/report_api.dart';
import 'package:familytree/src/data/globals.dart';
import 'package:flutter/material.dart';



void showReportOrBlockDialog(BuildContext context, reported_user_id) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Report & Block',
    pageBuilder: (_, __, ___) {
      return Stack(
        children: [
          Positioned(
            top: 60,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 80,
                height: 65,
                padding: const EdgeInsets.all(8), // tighter padding
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        showReportDetailDialog(context,reported_user_id);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Text("Report", style: TextStyle(fontSize: 13)),
                          Icon(Icons.report, color: Colors.black, size: 17),
                          SizedBox(height: 2),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Block User"),
                            content: const Text(
                                "Are you sure you want to block this user?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("User blocked.")),
                                  );
                                },
                                child: const Text("Block"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Text("Block  ", style: TextStyle(fontSize: 13)),
                          Icon(Icons.block, color: Colors.black, size: 16),
                          SizedBox(height: 2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
void showReportDetailDialog(
    BuildContext context, String reportedUserId) {
  final TextEditingController detailController = TextEditingController();
  final reportService = ReportApiService();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Report Issue"),
      content: TextField(
        controller: detailController,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: "Describe the issue",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            final details = detailController.text.trim();

            if (details.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please enter some details")),
              );
              return;
            }

            Navigator.pop(context); // Close the dialog

            final reportData = {
              "content": reportedUserId, // Reported user ID
              "reportBy": id, // Your user ID
              "reportType": "User", // Type of report
              "reason": details, // Reason from input
            };

            final result = await reportService.postReport(data: reportData);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  result == 'success'
                      ? "Report submitted successfully"
                      : "Failed to submit report: $result",
                ),
              ),
            );
          },
          child: const Text("Submit"),
        ),
      ],
    ),
  );
}





void ShowReportPostDialog(BuildContext context, String postId){
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Report',
    pageBuilder: (_, __, ___) {
      return Stack(
        children: [
          Positioned(
            top: 60,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 80,
                height: 40,
                padding: const EdgeInsets.all(8), // tighter padding
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        showReportpostDialog(context, postId);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Text("Report ", style: TextStyle(fontSize: 13)),
                          Icon(Icons.report, color: Colors.black, size: 17),
                          SizedBox(height: 2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

void showReportpostDialog(BuildContext context, String postId) {
  final TextEditingController detailController = TextEditingController();
  final reportService = ReportApiService();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Report Post"),
      content: TextField(
        controller: detailController,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: "Describe the issue with the post",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            final details = detailController.text.trim();

            if (details.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please enter some details")),
              );
              return;
            }

            Navigator.pop(context); // Close the dialog

            final reportData = {
              "content": postId, // Post ID being reported
              "reportBy": id, // Current user ID (from globals.dart)
              "reportType": "Feeds", // Differentiate from User reports
              "reason": details,
            };

            final result = await reportService.postReport(data: reportData);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  result == 'success'
                      ? "Post reported successfully"
                      : "Failed to report post: $result",
                ),
              ),
            );
          },
          child: const Text("Submit"),
        ),
      ],
    ),
  );
}

