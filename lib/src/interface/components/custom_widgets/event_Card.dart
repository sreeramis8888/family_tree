<<<<<<< HEAD
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/services/navgitor_service.dart';
import 'package:familytree/src/interface/components/Buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:familytree/src/data/models/events_model.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

Widget eventWidget({
  required BuildContext context,
  required Event event,
}) {
  String formattedDate = 'TBA';
  String timeRange = '';

  if (event.eventStartDate != null) {
    try {
      DateTime date = event.eventStartDate!.toLocal();
      formattedDate = DateFormat('MMM dd').format(date);
      // timeRange =
      //     '${DateFormat('hh:mm a').format(date)} - ${DateFormat('hh:mm a').format(date.add(const Duration(hours: 2)))}';
    } catch (_) {
      formattedDate = 'Invalid Date';
    }
  }
  bool isRegistered = false;
  if (event.rsvp != null) isRegistered = event.rsvp!.contains(id);
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromARGB(255, 237, 234, 234)),
      borderRadius: BorderRadius.circular(12),
      color: kWhite,
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Background Image
        CachedNetworkImage(
          imageUrl: event.image ?? '',
          width: double.infinity,
          height: 140,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: double.infinity,
            height: 140,
            color: Colors.grey[300],
          ),
          errorWidget: (context, url, error) => Container(
            width: double.infinity,
            height: 140,
            color: Colors.grey[300],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Text(
            '${event.eventName}',
            style: kSubHeadingB,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Text(
            '${event.description}',
            style: kSmallerTitleR,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      formattedDate,
                      style: const TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    timeRange,
                    style: const TextStyle(color: kWhite),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: customButton(
                    buttonColor: isRegistered ? kGreen : kPrimaryColor,
                    sideColor: isRegistered ? kGreen : kPrimaryColor,
                    label: isRegistered ? 'REGRISTERED' : 'Register Now',
                    onPressed: () {
                      NavigationService navigationService = NavigationService();
                      navigationService.pushNamed('ViewMoreEvent',
                          arguments: event);
                    },
                  )),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child:
                        const Icon(Icons.bookmark_border, color: Colors.black),
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
=======
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/services/navgitor_service.dart';
import 'package:familytree/src/interface/components/Buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:familytree/src/data/models/events_model.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

Widget eventWidget({
  required BuildContext context,
  required Event event,
}) {
  String formattedDate = 'TBA';
  String timeRange = '';

  if (event.eventStartDate != null) {
    try {
      DateTime date = event.eventStartDate!.toLocal();
      formattedDate = DateFormat('MMM dd').format(date);
      // timeRange =
      //     '${DateFormat('hh:mm a').format(date)} - ${DateFormat('hh:mm a').format(date.add(const Duration(hours: 2)))}';
    } catch (_) {
      formattedDate = 'Invalid Date';
    }
  }
  bool isRegistered = false;
  if (event.rsvp != null) isRegistered = event.rsvp!.contains(id);
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromARGB(255, 237, 234, 234)),
      borderRadius: BorderRadius.circular(12),
      color: kWhite,
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Background Image
        CachedNetworkImage(
          imageUrl: event.image ?? '',
          width: double.infinity,
          height: 140,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: double.infinity,
            height: 140,
            color: Colors.grey[300],
          ),
          errorWidget: (context, url, error) => Container(
            width: double.infinity,
            height: 140,
            color: Colors.grey[300],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Text(
            '${event.eventName}',
            style: kSubHeadingB,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Text(
            '${event.description}',
            style: kSmallerTitleR,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      formattedDate,
                      style: const TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    timeRange,
                    style: const TextStyle(color: kWhite),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: customButton(
                    buttonColor: isRegistered ? kGreen : kPrimaryColor,
                    sideColor: isRegistered ? kGreen : kPrimaryColor,
                    label: isRegistered ? 'REGRISTERED' : 'Register Now',
                    onPressed: () {
                      NavigationService navigationService = NavigationService();
                      navigationService.pushNamed('ViewMoreEvent',
                          arguments: event);
                    },
                  )),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child:
                        const Icon(Icons.bookmark_border, color: Colors.black),
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
>>>>>>> ccf1ac7535973b49113bf24d09d50ffbe2d9cba9
