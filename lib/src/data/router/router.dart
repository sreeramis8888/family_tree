import 'package:familytree/src/data/models/chat_conversation_model.dart';
import 'package:familytree/src/interface/screens/approvals/approvals_page.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/financial_program/program_join_onboarding_page.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/financial_program/program_join_request.dart';
import 'package:familytree/src/interface/screens/main_pages/profile/profile_preview_withUserModel.dart';
import 'package:flutter/material.dart';
import 'package:familytree/src/data/models/chat_model.dart';
import 'package:familytree/src/data/models/events_model.dart';
import 'package:familytree/src/data/models/user_model.dart';
import 'package:familytree/src/interface/screens/main_page.dart';
import 'package:familytree/src/interface/screens/main_pages/admin/allocate_member.dart';
import 'package:familytree/src/interface/screens/main_pages/admin/member_creation.dart';
import 'package:familytree/src/interface/screens/main_pages/chat/chat_screen.dart';
import 'package:familytree/src/interface/screens/main_pages/event/event_member_list.dart';
import 'package:familytree/src/interface/screens/main_pages/event/view_more_event.dart';
import 'package:familytree/src/interface/screens/onboarding/login_page.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/about_us.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/add_product.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/analytics/analytics.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/levels/send_analytic_req.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/change_number.dart';

import 'package:familytree/src/interface/screens/main_pages/menuPages/levels/states.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/my_posts.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/my_enquiries.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/event/my_events.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/my_products.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/privacy_policy.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/request_nfc.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/terms.dart';
import 'package:familytree/src/interface/screens/main_pages/news_bookmark/news_page.dart';
import 'package:familytree/src/interface/screens/main_pages/notification_page.dart';
import 'package:familytree/src/interface/screens/main_pages/profile/editUser.dart';
import 'package:familytree/src/interface/screens/main_pages/profile/idcard.dart';
import 'package:familytree/src/interface/screens/main_pages/menuPages/my_subscription.dart';
import 'package:familytree/src/interface/screens/main_pages/profile/profile_preview_withUserId.dart';
import 'package:familytree/src/interface/screens/splash_screen.dart';

Route<dynamic> generateRoute(RouteSettings? settings) {
  switch (settings?.name) {
    case 'Splash':
      return MaterialPageRoute(builder: (context) => SplashScreen());
    case 'PhoneNumber':
      return MaterialPageRoute(builder: (context) => PhoneNumberScreen());
    case 'MainPage':
      return MaterialPageRoute(builder: (context) => const MainPage());
    // case 'ProfileCompletion':
    //   return MaterialPageRoute(
    //       builder: (context) => const ProfileCompletionScreen());
    case 'Approvals':
      return MaterialPageRoute(builder: (context) => const ApprovalsPage());
    case 'Card':
      UserModel user = settings?.arguments as UserModel;
      return MaterialPageRoute(
          builder: (context) => IDCardScreen(
                user: user,
              ));
    case 'ProfilePreview':
      UserModel user = settings?.arguments as UserModel;
      return MaterialPageRoute(
          builder: (context) => ProfilePreviewWithUserModel(
                user: user,
              ));
    case 'ProfilePreviewUsingID':
      String userId = settings?.arguments as String;
      return MaterialPageRoute(
          builder: (context) => ProfilePreviewUsingId(
                userId: userId,
              ));
    case 'ViewMoreEvent':
      Event event = settings?.arguments as Event;
      return MaterialPageRoute(
          builder: (context) => ViewMoreEventPage(
                event: event,
              ));
    case 'MemberAllocation':
      UserModel newUser = settings?.arguments as UserModel;
      return MaterialPageRoute(
          builder: (context) => AllocateMember(
                newUser: newUser,
              ));
    case 'EventMemberList':
      Event event = settings?.arguments as Event;
      return MaterialPageRoute(
          builder: (context) => EventMemberList(
                event: event,
              ));
    case 'EditUser':
      return MaterialPageRoute(builder: (context) => EditUser());
    case 'FinancialAssistancePage':
      return MaterialPageRoute(builder: (context) => FinancialAssistancePage());
    // case 'IndividualPage':
    //   final args = settings?.arguments as Map<String, dynamic>?;
    //   ChatConversation conversation = args?['conversation'];
    //   String currentUserId = args?['currentUserId'];
    //   String conversationImage = args?['conversationImage'];
    //   String conversationTitle = args?['conversationTitle'];

    //   return MaterialPageRoute(
    //       builder: (context) => IndividualPage(conversation: conversation,conversationImage: conversationImage,conversationTitle: conversationTitle,
    //     currentUserId: currentUserId,
    //           ));
    case 'ChangeNumber':
      return MaterialPageRoute(builder: (context) => ChangeNumberPage());
    case 'FinancialProgramOnboarding':
      return MaterialPageRoute(
          builder: (context) => ProgramJoinOnboardingPage());
    case 'NotificationPage':
      return MaterialPageRoute(builder: (context) => NotificationPage());
    case 'AboutPage':
      return MaterialPageRoute(builder: (context) => AboutPage());

    case 'MemberCreation':
      return MaterialPageRoute(builder: (context) => MemberCreationPage());
    case 'MyEvents':
      return MaterialPageRoute(builder: (context) => MyEventsPage());
    case 'MyProducts':
      return MaterialPageRoute(builder: (context) => MyProductPage());
    case 'EnterProductsPage':
      return MaterialPageRoute(builder: (context) => EnterProductsPage());
    case 'MyPosts':
      return MaterialPageRoute(builder: (context) => MyPosts());
    case 'AnalyticsPage':
      return MaterialPageRoute(builder: (context) => AnalyticsPage());
    case 'SendAnalyticRequest':
      return MaterialPageRoute(builder: (context) => SendAnalyticRequestPage());

    case 'RequestNFC':
      return MaterialPageRoute(builder: (context) => RequestNFCPage());

    case 'States':
      return MaterialPageRoute(builder: (context) => StatesPage());

    case 'MySubscriptionPage':
      return MaterialPageRoute(builder: (context) => MySubscriptionPage());

    case 'Terms':
      return MaterialPageRoute(builder: (context) => TermsAndConditionsPage());

    case 'PrivacyPolicy':
      return MaterialPageRoute(builder: (context) => PrivacyPolicyPage());

    // case 'ProfileAnalytics':
    //   UserModel user = settings?.arguments as UserModel;
    //   return MaterialPageRoute(
    //       builder: (context) => ProfileAnalyticsPage(
    //             user: user,
    //           ));

    case 'MyEnquiries':
      return MaterialPageRoute(builder: (context) => const MyEnquiriesPage());
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text('No path for ${settings?.name}'),
          ),
        ),
      );
  }
}
