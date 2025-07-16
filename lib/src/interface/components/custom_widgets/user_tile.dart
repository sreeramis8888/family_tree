import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/data/models/business_model.dart';
import 'package:familytree/src/data/models/user_model.dart';
import 'package:intl/intl.dart';
import 'package:familytree/src/interface/components/custom_widgets/blue_tick_names.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
Widget buildUserInfo(UserModel user, Business feed, context) {
  String formattedDateTime = DateFormat('h:mm a · MMM d, yyyy')
      .format(DateTime.parse(feed.createdAt.toString()).toLocal());

  return ConstrainedBox(
    constraints: BoxConstraints(
        maxWidth:
            MediaQuery.of(context).size.width - 32), // Ensure bounded width
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              ClipOval(
                child: Container(
                  width: 30,
                  height: 30,
                  color: kWhite,
                  child: Image.network(
                    user.image ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return SvgPicture.asset(
                          'assets/svg/icons/dummy_person_small.svg');
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
             
                     user.fullName ?? '',
                      style: kSmallTitleR,
               
               
                    ),
                    // if (user.company != null &&
                    //     user.company!.isNotEmpty &&
                    //     user.company![0].name != null)
                    //   Text(
                    //     user.company![0].name!,
                    //     style:
                    //         const TextStyle(color: Colors.grey, fontSize: 12),
                    //     overflow: TextOverflow.ellipsis,
                    //     maxLines: 1,
                    //   ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            formattedDateTime,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    ),
  );
}
