import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:familytree/src/data/services/auth_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_upgrade_version/flutter_upgrade_version.dart';

import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/models/app_version_model.dart';
import 'package:familytree/src/data/models/user_model.dart';
import 'package:familytree/src/data/notifiers/user_notifier.dart';
import 'package:familytree/src/data/services/deep_link_service.dart';
import 'package:familytree/src/data/services/launch_url.dart';
import 'package:familytree/src/data/utils/secure_storage.dart';
import 'package:familytree/src/data/services/getFcmToken.dart';
import 'package:familytree/src/data/services/navgitor_service.dart';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/interface/screens/onboarding/registration_page.dart';
import 'package:familytree/src/interface/screens/onboarding/approval_waiting_page.dart';
import 'package:familytree/src/data/api_routes/user_api/login/user_login_api.dart';

class SplashScreen extends ConsumerStatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with WidgetsBindingObserver {
  // bool isAppUpdateRequired = false;
  String isFirstLaunch = 'false';
  bool openedAppSettings = false;
  bool hasVersionCheckError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkFirstLaunch().then((_) {
      handlePermissions();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && openedAppSettings) {
      openedAppSettings = false;
      handlePermissions();
    }
  }


  Future<void> checkFirstLaunch() async {
    isFirstLaunch = await SecureStorage.read('has_launched_before') ?? 'false';
    if (isFirstLaunch == 'true') {
      await SecureStorage.write('has_launched_before', 'true');
    }
  }

  Future<void> handlePermissions() async {
    if (Platform.isIOS) {
      await handleIOSPermissions();
    } else {
      await handleAndroidPermissions();
    }
  }

  Future<void> handleIOSPermissions() async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      final newSettings = await FirebaseMessaging.instance.requestPermission();
      if (newSettings.authorizationStatus == AuthorizationStatus.authorized) {
        await setupFCM();
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      await showiOSPermissionDialog();
    } else if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      await setupFCM();
    }

    proceedWithAppFlow();
  }

  Future<void> handleAndroidPermissions() async {
    final status = await Permission.notification.status;

    if (status.isGranted) {
      await setupFCM();
      proceedWithAppFlow();
    } else if (status.isPermanentlyDenied) {
      await showAndroidPermissionDialog();
    } else {
      final result = await Permission.notification.request();
      if (result.isGranted) {
        await setupFCM();
      }
      proceedWithAppFlow();
    }
  }

  Future<void> showiOSPermissionDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Enable Notifications'),
        content: Text(
            'You have previously denied notification permissions. Please enable them in Settings.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              proceedWithAppFlow();
            },
            child: Text('Skip'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              openedAppSettings = true;
              await openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> showAndroidPermissionDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Enable Notifications'),
        content:
            Text('Please enable notification permissions from app settings.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              proceedWithAppFlow();
            },
            child: Text('Skip'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> setupFCM() async {
    try {
      await getToken(context);
      print("FCM Token: $token");
    } catch (e) {
      print('Error getting FCM token: $e');
      fcmToken = '';
    }
  }

  void proceedWithAppFlow() {
    // checkAppVersion(context).then((_) {
      // if (!isAppUpdateRequired && !hasVersionCheckError) {
        initialize();
      // }
    // });
  }

  Future<void> checkAppVersion(context) async {
    try {
      log('Checking app version...');
      final response = await http.get(Uri.parse('$baseUrl/user/app-version'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final appVersionResponse = AppVersionResponse.fromJson(jsonResponse);
        await checkForUpdate(appVersionResponse, context);
      } else {
        log('Failed to fetch app version: ${response.statusCode}');
        setState(() {
          hasVersionCheckError = true;
          errorMessage = 'Server is down. Please try again later.';
        });
      }
    } catch (e) {
      log('Error checking app version: $e');
      setState(() {
        hasVersionCheckError = true;
        errorMessage =
            'An error occurred while checking for updates. Please try again.';
      });
    }
  }

  Future<void> checkForUpdate(AppVersionResponse response, context) async {
    PackageInfo packageInfo = await PackageManager.getPackageInfo();
    final currentVersion = int.parse(packageInfo.version.split('.').join());
    log('Current version: $currentVersion');
    log('New version: ${response.version}');

    if (currentVersion < response.version && response.force) {
      // isAppUpdateRequired = true;
      showUpdateDialog(response, context);
    }
  }

  void showUpdateDialog(AppVersionResponse response, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Update Required'),
        content: Text(response.updateMessage),
        actions: [
          TextButton(
            onPressed: () {
              launchURL(response.applink);
            },
            child: Text('Update Now'),
          ),
        ],
      ),
    );
  }

  Future<void> retryVersionCheck() async {
    setState(() {
      hasVersionCheckError = false;
      errorMessage = '';
    });
    proceedWithAppFlow();
  }

  Future<void> initialize() async {
    final _deepLinkService = ref.watch(deepLinkServiceProvider);
    NavigationService navigationService = NavigationService();
    await checktoken();
    Timer(Duration(seconds: 2), () async {
      // if (!isAppUpdateRequired) {
        print('Logged in : $LoggedIn');
        if (LoggedIn) {
          final container = ProviderContainer();
          final asyncUser = container.read(userProvider);
          UserModel? user;
          if (asyncUser is AsyncData<UserModel>) {
            user = asyncUser.value;
          } else {
            await container.read(userProvider.notifier).refreshUser();
            final refreshed = container.read(userProvider);
            if (refreshed is AsyncData<UserModel>) {
              user = refreshed.value;
            }
          }
          if (user != null &&
              user.status?.toLowerCase() == 'awaiting_payment') {
            navigationService.pushNamedReplacement('MySubscriptionPage');
            return;
          }

          final pendingDeepLink = _deepLinkService.pendingDeepLink;
          if (pendingDeepLink != null) {
            navigationService.pushNamedReplacement('MainPage').then((_) {
              _deepLinkService.handleDeepLink(pendingDeepLink);
              _deepLinkService.clearPendingDeepLink();
            });
          } else {
            navigationService.pushNamedReplacement('MainPage');
          }
        } else {
          // Check for pending registration
          String? phone = await SecureStorage.getPhoneNumber();
          if (phone != null && phone.isNotEmpty) {
            // Call verifyOtp API to check status
            try {
              Map<String, dynamic> responseMap = await verifyUserDB(
                phone: phone,
     
                fcmToken: fcmToken,
           
                context: context,
              );
              final message = responseMap['message'] ?? '';
              final isRegistered = responseMap['isRegistered'];
              final user = responseMap['user'];
              if (isRegistered == false && user == null && message.toString().toLowerCase().contains('phone verified')) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => RegistrationPage(phone: phone),
                ));
              } else if (message.toString().toLowerCase().contains('pending')) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const ApprovalWaitingPage(),
                ));
              } else if (isRegistered == true && user != null && responseMap['accessToken'] != null) {
                String savedToken = responseMap['accessToken'];
                String savedId = user['id'];
                if (savedToken.isNotEmpty && savedId.isNotEmpty) {
                  await SecureStorage.write('token', savedToken);
                  await SecureStorage.write('id', savedId);
                  token = savedToken;
                  id = savedId;
                  Navigator.of(context).pushReplacementNamed('MainPage');
                }
              } else {
                Navigator.of(context).pushReplacementNamed('PhoneNumber');
              }
            } catch (e) {
              Navigator.of(context).pushReplacementNamed('PhoneNumber');
            }
          } else {
            Navigator.of(context).pushReplacementNamed('PhoneNumber');
          }
        }
      // }
    });
  }

Future<void> checktoken() async {
    String? savedToken = await SecureStorage.read('token') ?? '';
    String? savedId = await SecureStorage.read('id') ?? '';

    log('token: $savedToken');
    log('userId: $savedId');

    if (savedToken.isNotEmpty && savedId.isNotEmpty) {
      setState(() {
        LoggedIn = true;
        token = savedToken;
        id = savedId;
      });
    } else {
      // 🔁 Try refreshing token
      final success = await AuthService.refreshAccessToken();
      if (success) {
        String? newToken = await SecureStorage.read('token');
        String? newId = await SecureStorage.read('id');
        setState(() {
          LoggedIn = true;
          token = newToken ?? '';
          id = newId ?? '';
        });
      } else {
        setState(() {
          LoggedIn = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              scale: 8,
              'assets/pngs/familytree_logo.png',
            ),
          ),
          if (hasVersionCheckError)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: retryVersionCheck,
                      child: Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
