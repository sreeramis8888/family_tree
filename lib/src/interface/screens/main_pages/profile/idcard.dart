import 'package:familytree/src/interface/components/Buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/data/models/user_model.dart';
import 'package:familytree/src/interface/components/animations/glowing_profile.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

final isFullScreenProvider = StateProvider<bool>((ref) => false);

class IDCardScreen extends ConsumerWidget {
  final UserModel user;

  const IDCardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScreenshotController screenshotController = ScreenshotController();
    final isFullScreen = ref.watch(isFullScreenProvider);

    // Handle system UI overlays for fullscreen
    Future<void> enterFullScreen() async {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      ref.read(isFullScreenProvider.notifier).state = true;
    }

    Future<void> exitFullScreen() async {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      ref.read(isFullScreenProvider.notifier).state = false;
    }

    return Scaffold(
      appBar: isFullScreen
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              centerTitle: true,
              title: const Text('Profile', style: kSmallTitleR),
            ),
      body: Stack(
        children: [
          Screenshot(
            controller: screenshotController,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    // Profile picture
                    Center(
                      child: GlowingAnimatedAvatar(
                        imageUrl: user.image,
                        defaultAvatarAsset:
                            'assets/svg/icons/dummy_person_large.svg',
                        size: 100,
                        glowColor: Colors.white,
                        borderColor: Colors.white,
                        borderWidth: 3.0,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // QR code in white rounded rectangle
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: QrImageView(
                        data:
                            'https://admin.familytreeconnect.com/user/${user.id}',
                        version: QrVersions.auto,
                        size: 200,
                        foregroundColor: kBlack,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Name
                    Text(
                      user.fullName ?? '',
                      style: kLargeTitleB.copyWith(color: kBlack),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // Contact info
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (user.phone != null && user.phone != '') ...[
                            Row(
                              children: [
                                const Icon(Icons.phone,
                                    color: Colors.red, size: 22),
                                const SizedBox(width: 10),
                                Text(user.phone ?? '',
                                    style: TextStyle(fontSize: 15)),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (user.email != null && user.email != '') ...[
                            Row(
                              children: [
                                const Icon(Icons.email,
                                    color: Colors.red, size: 22),
                                const SizedBox(width: 10),
                                Text(user.email ?? '',
                                    style: TextStyle(fontSize: 15)),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (user.address != null && user.address != '') ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.red, size: 22),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(user.address ?? '',
                                      style: TextStyle(fontSize: 15)),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (!isFullScreen)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: customButton(
                              label: 'Share',
                              onPressed: () {},
                            )),
                            const SizedBox(width: 16),
                            Expanded(
                                child: customButton(
                                    label: 'Download QR',
                                    onPressed: () {},
                                    sideColor: kPrimaryLightColor,
                                    buttonColor: kWhite,
                                    labelColor: kPrimaryColor)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Floating fullscreen button (not in app bar)
          if (!isFullScreen)
            Positioned(
              top: 24,
              right: 24,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white,
                elevation: 2,
                onPressed: enterFullScreen,
                child: const Icon(Icons.open_in_full, color: Colors.red),
              ),
            ),
          // Floating close button in fullscreen
          if (isFullScreen)
            Positioned(
              top: 24,
              right: 24,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white,
                elevation: 2,
                onPressed: exitFullScreen,
                child: const Icon(Icons.close_fullscreen_outlined,
                    color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
