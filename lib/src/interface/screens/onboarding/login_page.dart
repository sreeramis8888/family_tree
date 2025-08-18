import 'dart:async';
import 'dart:developer';

import 'package:familytree/src/data/utils/size.dart';
// import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:familytree/src/data/api_routes/user_api/admin/admin_activities_api.dart';
import 'package:familytree/src/data/api_routes/user_api/login/user_login_api.dart';
import 'package:familytree/src/data/api_routes/user_api/user_data/edit_user.dart';
import 'package:familytree/src/data/api_routes/user_api/user_data/user_data.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/data/globals.dart';
import 'package:familytree/src/data/notifiers/user_notifier.dart';
import 'package:familytree/src/data/services/navgitor_service.dart';
import 'package:familytree/src/data/services/snackbar_service.dart';
import 'package:familytree/src/data/utils/secure_storage.dart';
import 'package:familytree/src/interface/components/Buttons/primary_button.dart';

import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:familytree/src/interface/screens/main_page.dart';
import 'package:familytree/src/interface/screens/main_pages/profile/editUser.dart';
import 'package:familytree/src/interface/screens/onboarding/eula_agreement_screen.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:familytree/src/data/notifiers/loading_notifier.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:familytree/src/interface/screens/onboarding/registration_page.dart';
import 'package:familytree/src/interface/screens/onboarding/approval_waiting_page.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:telephony/telephony.dart';

TextEditingController _mobileController = TextEditingController();
// TextEditingController _otpController = TextEditingController();

final countryCodeProvider = StateProvider<String?>((ref) => '91');

class PhoneNumberScreen extends ConsumerWidget {
  const PhoneNumberScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);
    final countryCode = ref.watch(countryCodeProvider);
    final bottomInset = ScreenSize.getBottomInset(context);
    final screenHeight = ScreenSize.getScreenHeight(context);
    final screenWidth = ScreenSize.getScreenWidth(context);

    return Scaffold(
      backgroundColor: kWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.5,
                  child: Image.asset(
                    'assets/pngs/login_family.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Image.asset(
                      'assets/pngs/familytree_logo.png',
                      width: screenWidth * 0.32,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login',
                      style: kHeadTitleB.copyWith(color: kPrimaryColor),
                    ),
                    const SizedBox(height: 16),
                    const Text('Please enter your mobile number',
                        style: kBodyTitleL),
                    const SizedBox(height: 20),
                    IntlPhoneField(
                      validator: (phone) {
                        // if (phone!.number.length > 9) {
                        //   if (phone.number.length > 10) {
                        //     return 'Phone number cannot exceed 10 digits';
                        //   }
                        // }
                        if (phone!.number.length < 10) {
                          return 'Phone number must be exactly 10 digits';
                        } else if (phone.number.length > 10) {
                          return 'Phone number cannot exceed 10 digits';
                        }
                        return null;
                      },
                      style: const TextStyle(
                        letterSpacing: 8,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                      controller: _mobileController,
                      disableLengthCheck: true,
                      showCountryFlag: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: kWhite,
                        hintText: 'Enter your phone number',
                        hintStyle: const TextStyle(
                          letterSpacing: 2,
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: kGreyLight),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: kGreyLight),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: kGreyLight),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 10.0,
                        ),
                      ),
                      onCountryChanged: (value) {
                        ref.read(countryCodeProvider.notifier).state =
                            value.dialCode;
                      },
                      initialCountryCode: 'IN',
                      onChanged: (PhoneNumber phone) {
                        print(phone.completeNumber);
                      },
                      flagsButtonPadding:
                          const EdgeInsets.only(left: 10, right: 10.0),
                      showDropdownIcon: true,
                      dropdownIconPosition: IconPosition.trailing,
                      dropdownTextStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('A 6 digit verification code will be sent',
                        style: kSmallTitleR),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 5, right: 5, top: 10),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: customButton(
                          label: 'GENERATE OTP',
                          onPressed: isLoading
                              ? null
                              : () => _handleOtpGeneration(context, ref),
                          fontSize: 16,
                          isLoading: isLoading,
                        ),
                      ),
                    ),
                    SizedBox(height: bottomInset),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleOtpGeneration(BuildContext context, WidgetRef ref) async {
    SnackbarService snackbarService = SnackbarService();
    final countryCode = ref.watch(countryCodeProvider);
    FocusScope.of(context).unfocus();
    ref.read(loadingProvider.notifier).startLoading();

    try {
      if (countryCode == '971') {
        if (_mobileController.text.length != 9) {
          snackbarService.showSnackBar('Please Enter valid mobile number');
        } else {
          final data = await submitPhoneNumber(
              countryCode == '971'
                  ? 9710.toString()
                  : countryCode ?? 91.toString(),
              context,
              _mobileController.text);
          final verificationId = data['verificationId'];
          final resendToken = data['resendToken'];
          if (verificationId != null && verificationId.isNotEmpty) {
            log('Otp Sent successfully');
            id = '';
            token = '';
            LoggedIn = false;
            await SecureStorage.deleteAll();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => OTPScreen(
                phone: _mobileController.text,
                verificationId: verificationId,
                resendToken: resendToken ?? '',
              ),
            ));
          } else {
            snackbarService.showSnackBar('Failed');
          }
        }
      } else if (countryCode != '971') {
        if (_mobileController.text.length != 10) {
          snackbarService.showSnackBar('Please Enter valid mobile number');
        } else {
          final data = await submitPhoneNumber(
              countryCode == '971'
                  ? 9710.toString()
                  : countryCode ?? 971.toString(),
              context,
              _mobileController.text);
          final verificationId = data['verificationId'];
          final resendToken = data['resendToken'];
          if (verificationId != null && verificationId.isNotEmpty) {
            log('Otp Sent successfully');

            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => OTPScreen(
                phone: _mobileController.text,
                verificationId: verificationId,
                resendToken: resendToken ?? '',
              ),
            ));
          } else {
            snackbarService.showSnackBar('Failed');
          }
        }
      }
    } catch (e) {
      log(e.toString());
      snackbarService.showSnackBar('Failed');
    } finally {
      ref.read(loadingProvider.notifier).stopLoading();
    }
  }
}

class OTPScreen extends ConsumerStatefulWidget {
  final String verificationId;
  final String resendToken;
  final String phone;
  const OTPScreen({
    required this.phone,
    required this.resendToken,
    super.key,
    required this.verificationId,
  });

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  Timer? _timer;

  int _start = 59;

  bool _isButtonDisabled = true;
  bool _isVerifyButtonDisabled = true;
  final TextEditingController _otpController = TextEditingController();
  final Telephony telephony = Telephony.instance;
  String textReceived = '';

  @override
  void initState() {
    super.initState();
    _otpController.addListener(() {
      setState(() {
        _isVerifyButtonDisabled = _otpController.text.length != 6;
      });
    });
    //Listen for otp
    listenForOtp();
    startTimer();
  }

  // Future<void> listenForOtp() async {
  //   await SmsAutoFill().listenForCode();
  //   SmsAutoFill().code.listen((code) {
  //   if (code != null && code.isNotEmpty) {
  //     _otpController.text = code; // This will auto-fill PinCodeTextField
  //   }
  // });

  // }

// Future<void> listenForOtp() async {
//   String? appSignature = await SmsAutoFill().getAppSignature;
//   log("App Signature: $appSignature");

//   // Start listening for incoming OTPs
//   await SmsAutoFill().listenForCode();

//   // Listen for OTP value from SmsAutoFill
//   SmsAutoFill().code.listen((code) {
//     if (code != null && code.isNotEmpty) {
//       log("Received OTP: $code");
//       setState(() {
//         _otpController.text = code.trim(); // Auto-fill the field
//         _isVerifyButtonDisabled = _otpController.text.length != 6;
//       });
//     }
//   });
// }

  // Future<void> listenForOtp() async {
  //   String? appSignature = await SmsAutoFill().getAppSignature;
  //   print("App Signature: $appSignature");

  //   await SmsAutoFill().listenForCode();

  //   SmsAutoFill().code.listen((code) {
  //     if (code != null && code.isNotEmpty) {
  //       print("Received OTP: $code");
  //       setState(() {
  //         _otpController.text = code.trim();
  //         _isVerifyButtonDisabled = code.trim().length != 6;
  //       });
  //     } else {
  //       print('nothing recived');
  //     }
  //   });
  // }

  void listenForOtp() {
    telephony.listenIncomingSms(onNewMessage: (SmsMessage message) {
      setState(() {
        textReceived = message.body!;
        print(textReceived);
      });
    },
    listenInBackground: false
    );
  }

  void startTimer() {
    _isButtonDisabled = true;
    _start = 59;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isButtonDisabled = false;
        });
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void resendCode() {
    startTimer();

    resendOTP(widget.phone, widget.verificationId, widget.resendToken);
  }

  @override
  void dispose() {
    _timer?.cancel();
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    final bottomInset = ScreenSize.getBottomInset(context);
    final screenHeight = ScreenSize.getScreenHeight(context);
    final screenWidth = ScreenSize.getScreenWidth(context);
    return Scaffold(
      backgroundColor: kWhite,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.6,
                  child: Image.asset(
                    'assets/pngs/login_family.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Image.asset(
                      'assets/pngs/familytree_logo.png',
                      width: screenWidth * 0.32,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login',
                    style: kHeadTitleB.copyWith(
                        color: kPrimaryColor, fontSize: 28),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Enter the OTP to verify',
                      style: kSmallerTitleEL.copyWith(fontSize: 20)),
                  const SizedBox(height: 5),
                  PinCodeTextField(
                    appContext: context,
                    length: 6, // Number of OTP digits
                    // controller :_otpController,
                    // onChanged:(value) {
                    //   setState(() {
                    //     _isVerifyButtonDisabled = value.length != 6;
                    //   });
                    // },
                    obscureText: false,
                    keyboardType: TextInputType.number, // Number-only keyboard
                    animationType: AnimationType.fade,
                    textStyle: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 5.0,
                    ),
                    pinTheme: PinTheme(
                      borderWidth: .5,
                      inactiveBorderWidth: .5,
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 55,
                      fieldWidth: 50,
                      selectedColor: kPrimaryColor,
                      activeColor: const Color.fromARGB(255, 232, 226, 226),
                      inactiveColor: kGreyLight,
                      activeFillColor: kWhite,
                      selectedFillColor: kWhite,
                      inactiveFillColor: kWhite,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    controller: _otpController,
                    onChanged: (value) {
                      _isVerifyButtonDisabled = value.length != 6;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          _isButtonDisabled
                              ? 'Resend OTP in $_start seconds'
                              : 'Enter your OTP',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: _isButtonDisabled ? kGrey : kBlack),
                        ),
                      ),
                      GestureDetector(
                        onTap: _isButtonDisabled ? null : resendCode,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            _isButtonDisabled ? '' : 'Resend Code',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: _isButtonDisabled ? kGrey : kRed),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      height: 47,
                      width: double.infinity,
                      child: customButton(
                        label: 'Verify',
                        //verify button is only clickable whent the 6 digits are entered
                        onPressed: (isLoading || _isVerifyButtonDisabled)
                            ? (null)
                            : () => _handleOtpVerification(context, ref),
                        fontSize: 16,
                        //button is color is grey until it is enabled
                        buttonColor: (isLoading || _isVerifyButtonDisabled)
                            ? kGrey
                            : kPrimaryColor,
                        sideColor: (isLoading || _isVerifyButtonDisabled)
                            ? kGrey
                            : kPrimaryColor,
                        isLoading: isLoading,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleOtpVerification(
      BuildContext context, WidgetRef ref) async {
    ref.read(loadingProvider.notifier).startLoading();
    final countryCode = ref.watch(countryCodeProvider);
    try {
      print(_otpController.text);

      Map<String, dynamic> responseMap = await verifyOTP(
          phone: '+$countryCode${_mobileController.text}',
          verificationId: widget.verificationId,
          fcmToken: fcmToken,
          smsCode: _otpController.text,
          context: context);
      await SecureStorage.write(
          'refreshToken', responseMap['refreshToken'] ?? '');
      final message = responseMap['message'] ?? '';
      final isRegistered = responseMap['isRegistered'];
      final user = responseMap['user'];

      if (isRegistered == false &&
          user == null &&
          message.toString().toLowerCase().contains('phone verified')) {
        // New user, show registration form
        await SecureStorage.savePhoneNumber(
            '+${countryCode}${_mobileController.text}');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => RegistrationPage(phone: _mobileController.text),
        ));
      } else if (message.toString().toLowerCase().contains('pending')) {
        // Request pending, show waiting page
        await SecureStorage.savePhoneNumber(
            '+${countryCode}${_mobileController.text}');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ApprovalWaitingPage(),
        ));
      } else if (isRegistered == true &&
          user != null &&
          responseMap['accessToken'] != null) {
        // Login successful
        String savedToken = responseMap['accessToken'];
        String savedId = user['person']['_id'];
        if (savedToken.isNotEmpty && savedId.isNotEmpty) {
          await SecureStorage.write('token', savedToken);
          await SecureStorage.write('id', savedId);
          token = savedToken;
          id = savedId;
          log('savedToken: $savedToken');
          log('savedId: $savedId');

          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const EulaAgreementScreen()));
        }
      } else {
        // CustomSnackbar.showSnackbar(context, 'Wrong OTP');
      }
    } catch (e) {
      log(e.toString());
      // CustomSnackbar.showSnackbar(context, 'Wrong OTP');
    } finally {
      ref.read(loadingProvider.notifier).stopLoading();
    }
  }
}

// class ProfileCompletionScreen extends ConsumerWidget {
//   const ProfileCompletionScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final asyncUser = ref.watch(userProvider);
//     return asyncUser.when(
//       data: (user) {
//         final bool nameMissing = user.name == null || user.name!.trim().isEmpty;
//         return Scaffold(
//           backgroundColor: kWhite,
//           body: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SvgPicture.asset('assets/svg/images/letsgetstarted.svg'),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text("Let's Get Started,\nComplete your profile",
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.unna(
//                       color: kGreyDark,
//                       fontSize: 25,
//                       fontWeight: FontWeight.bold,
//                     )),
//                 const SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
//                   child: SizedBox(
//                       height: 50,
//                       width: double.infinity,
//                       child: customButton(
//                           label: 'Next',
//                           onPressed: () {
//                             // Navigator.of(context).pushReplacement(
//                             //     MaterialPageRoute(
//                             //         settings: const RouteSettings(
//                             //             name: 'ProfileCompletion'),
//                             //         builder: (context) => const EditUser()));
//                           },
//                           fontSize: 16)),
//                 ),
//                 if (!nameMissing)
//                   TextButton(
//                     onPressed: () async {
//                       // Check if user has agreed to EULA
//                       final eulaAgreed =
//                           await SecureStorage.read('eula_agreed');
//                       if (eulaAgreed != 'true') {
//                         // Show EULA agreement screen if not agreed
//                         Navigator.of(context).pushReplacement(
//                           MaterialPageRoute(
//                               builder: (context) =>
//                                   const EulaAgreementScreen()),
//                         );
//                         return;
//                       }
//                       NavigationService navigationService = NavigationService();
//                       navigationService.pushNamedReplacement('MainPage');
//                     },
//                     child: Text(
//                       'Skip',
//                       style: kSmallTitleB.copyWith(color: kPrimaryColor),
//                     ),
//                   )
//               ],
//             ),
//           ),
//         );
//       },
//       loading: () => const Center(child: LoadingAnimation()),
//       error: (error, stackTrace) =>
//           const Center(child: Text('Error loading user')),
//     );
//   }
// }
