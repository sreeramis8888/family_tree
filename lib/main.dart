import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/firebase_options.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/data/services/navgitor_service.dart';
import 'package:familytree/src/data/services/notification_service.dart';
import 'package:familytree/src/data/services/snackbar_service.dart';
import 'package:familytree/src/data/router/router.dart' as router;
import 'package:familytree/src/data/utils/secure_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await loadSecureData();
  await dotenv.load(fileName: ".env");

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationService = ref.watch(notificationServiceProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationService.initialize();
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      scaffoldMessengerKey: SnackbarService.scaffoldMessengerKey,
      onGenerateRoute: router.generateRoute,
      initialRoute: 'Splash',
      title: 'familytree',
      theme: ThemeData(
        fontFamily: kFamilyName,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}
