import 'package:flutter/material.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/models/events_model.dart';
import 'package:familytree/src/interface/screens/main_pages/event/member_list/attended.dart';
import 'package:familytree/src/interface/screens/main_pages/event/member_list/registered.dart';

class EventMemberList extends StatelessWidget {
  final Event event;
  const EventMemberList({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2, // Number of tabs

        child: Scaffold(
            backgroundColor: kWhite,
            body: SafeArea(
              child: Column(
                children: [
                  PreferredSize(
                    preferredSize: Size.fromHeight(20),
                    child: Container(
                      margin: EdgeInsets.only(top: 0),
                      child: const SizedBox(
                        height: 40,
                        child: TabBar(
                          enableFeedback: true,
                          isScrollable: false,
                          indicatorColor: kPrimaryColor,
                          indicatorWeight: 3.0,
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: kPrimaryColor,
                          unselectedLabelColor: Colors.grey,
                          labelStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          tabs: [
                            Tab(
                              text: "Attended",
                            ),
                            Tab(
                              text: "Registered",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Wrap TabBar with a Container to adjust margin

                  Expanded(
                    child: TabBarView(
                      children: [
                        AttendedPage(
                          event: event,
                        ),
                        RegisteredPage(
                          event: event,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
