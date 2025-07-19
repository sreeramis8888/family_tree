import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:familytree/src/interface/components/ModalSheets/user_details_modal_sheet.dart';

class FamilyTreeWebView extends StatefulWidget {
  const FamilyTreeWebView({Key? key}) : super(key: key);

  @override
  State<FamilyTreeWebView> createState() => _FamilyTreeWebViewState();
}

class _FamilyTreeWebViewState extends State<FamilyTreeWebView> {
  late InAppWebViewController _webViewController;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhite,
        forceMaterialTransparency: true,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                size: 15,
              ),
              const SizedBox(width: 8),
              const Icon(Icons.account_tree, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Text("Family Tree", style: kHeadTitleB),
            ],
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri('https://kalathingalneelatt.com/app/families'),
            ),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true,
                useShouldOverrideUrlLoading: true,
              ),
            ),
            onWebViewCreated: (controller) {
              _webViewController = controller;
              controller.addJavaScriptHandler(
                handlerName: 'navigateToUser',
                callback: (args) async {
                  final userId = args.isNotEmpty ? args[0] : null;
                  // Show dummy modal sheet
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: kWhite,
                    builder: (context) =>
                        UserDetailsModalSheet(userId: userId ?? ""),
                  );
                  // You can also navigate using Navigator if needed
                  return null;
                },
              );
            },
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true;
              });
            },
            onLoadStop: (controller, url) async {
              setState(() {
                _isLoading = false;
              });
            },
            onConsoleMessage: (controller, consoleMessage) {
              // Optionally handle console messages
              debugPrint('Console: \\${consoleMessage.message}');
            },
          ),
          if (_isLoading) const Center(child: LoadingAnimation()),
        ],
      ),
    );
  }
}
