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
            top: 90,
            right: 40,
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
                         showReportReasonDialog(context, reported_user_id,"User");
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





void showReportReasonDialog(BuildContext context, String Id, String reportType) {
  final reasons = [
    "I just don't like it",
    "Bullying or unwanted contact",
    "Suicide, self-injury or eating disorders",
    "Violence, hate or exploitation",
    "Selling or promoting restricted items",
    "Nudity or sexual activity",
    "Scam, fraud or spam",
    "False information",
  ];

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
               title: Text(
          "Why are you reporting this ${reportType == 'Feeds' ? 'post' : 'User'}?"),

      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: reasons.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(reasons[index]),
              onTap: () async {
                Navigator.pop(context); // Close reason dialog

                // Capture safe context
                final safeContext =
                    Navigator.of(context, rootNavigator: true).context;

                final reportData = {
                  "content": Id,
                  "reportBy": id, // Use your user ID from globals.dart
                  "reportType":reportType ,
                  "reason": reasons[index],
                };

                final result =
                    await ReportApiService().postReport(data: reportData);

                // Use Future.microtask to ensure dialog stack is restored
                Future.microtask(() {
                  showReportFeedbackDialog(safeContext, result == 'success');
                });
              },
            );
          },
        ),
      ),
    ),
  );
}




void showReportFeedbackDialog(BuildContext context, bool isSuccess) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Column(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 48),
          const SizedBox(height: 12),
          const Text(
            "Thanks for your feedback",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: const Text(
        "When you see something you don't like on Community, you can report it if it doesn't follow our Community Standards, or you can remove the person who shared it from your experience.",
        style: TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () {
           
            Navigator.pop(context);
          },
          child: const Text("Block user",
              style: TextStyle(color: Colors.redAccent)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child:
              const Text("Close", style: TextStyle(color: Colors.blueAccent)),
        ),
      ],
    ),
  );
}
