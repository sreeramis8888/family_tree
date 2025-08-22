import 'package:flutter/material.dart';
import 'package:familytree/src/data/models/msg_model.dart';

class OwnMessageCard extends StatelessWidget {
  const OwnMessageCard(
      {Key? key,
      required this.message,
      required this.time,
      required this.status,
      this.product,
      this.requirement})
      : super(key: key);

  final String message;
  final String time;
  final ChatProduct? product;
  final String status;
  final ChatBusiness? requirement;

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
                if (product?.image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      product!.image!,
                      height: 160, // Adjusted height to fit better
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (requirement?.image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      requirement!.image!,
                      height: 160, // Adjusted height to fit better
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (product != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product?.name ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(
                              0xFF004797), // Using the provided color for emphasis
                        ),
                      ),
                      SizedBox(height: 4), // Add spacing between name and price
                      Text(
                        'PRICE INR ${product?.price?.toStringAsFixed(2) ?? ''}', // Format price to two decimals
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color:
                              Colors.black87, // Subtle color for the price text
                        ),
                      ),
                    ],
                  ),
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
