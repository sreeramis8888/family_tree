
import 'package:flutter/material.dart';

class GroupchatOwnMessageCard extends StatelessWidget {
  const GroupchatOwnMessageCard(
      {super.key,
      required this.message,
      required this.time,
      required this.status,
      // this.feed,
      required this.username});
  final String username;
  final String message;
  final String time;
  // final ChatFeed? feed;
  final String status;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFFE6FFE2),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username,style: TextStyle(color: Colors.red),),
                // if (feed?.media != null)
                //   ClipRRect(
                //     borderRadius: BorderRadius.circular(15),
                //     child: Image.network(
                //       feed!.media!,
                //       height: 160, // Adjusted height to fit better
                //       width: double.infinity,
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                // Spacing between message and time row
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.done_all,
                      size: 20,
                      color: status == 'seen' ? Colors.blue[300] : Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
