import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/api_routes/levels_api/levels_api.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/levels/chapters.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/levels/create_notification_page.dart';

import '../../../../../data/services/navgitor_service.dart';
import 'package:familytree/src/data/services/user_access_service.dart';
import 'package:familytree/src/interface/components/Dialogs/permission_denied_dialog.dart';

class DistrictsPage extends ConsumerStatefulWidget {
  final String zoneId;
  final String zoneName;
  const DistrictsPage(
      {super.key, required this.zoneId, required this.zoneName});

  @override
  ConsumerState<DistrictsPage> createState() => _DistrictsPageState();
}

class _DistrictsPageState extends ConsumerState<DistrictsPage> {
  bool _canSendNotification = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final hasPermission = await UserAccessService.canSendNotification();
    setState(() {
      _canSendNotification = hasPermission;
    });
  }

  void _showNotificationDialog() {
  //   if (!_canSendNotification) {
  //     PermissionDeniedDialog.show(
  //       context,
  //       message:
  //           'You do not have permission to send notifications. Please contact your administrator for access.',
  //     );
  //     return;
  //   }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateNotificationPage(
          level: 'zone',
          levelId: widget.zoneId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    NavigationService navigationService = NavigationService();
    return Consumer(
      builder: (context, ref, child) {
        final asyncDistrict =
            ref.watch(fetchLevelDataProvider(widget.zoneId, 'zone'));
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text("Districts"),
            centerTitle: false,
            backgroundColor: kWhite,
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: asyncDistrict.when(
            data: (districts) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 20),
                    child: Row(
                      children: [
                        Text(
                          '${widget.zoneName} /',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: districts.length,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: kWhite,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: .1,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: kWhite,
                                child: Icon(Icons.map_outlined,
                                    color: kPrimaryColor),
                              ),
                              title: Text(
                                districts[index].name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  size: 16, color: Colors.grey),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChaptersPage(
                                              districtName:
                                                  districts[index].name,
                                              districtId: districts[index].id,
                                            )));
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            loading: () => Center(child: LoadingAnimation()),
            error: (error, stackTrace) {
              // Handle error state
              return Center(
                child: Text('Error Loading States'),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showNotificationDialog,
            backgroundColor: Colors.orange,
            child: Icon(Icons.notifications, color: kWhite),
          ),
          backgroundColor: Color(0xFFF8F8F8), // Light background color
        );
      },
    );
  }
}
