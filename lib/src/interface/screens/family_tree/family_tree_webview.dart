import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
        title: const Text('Family Tree'),
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
                    builder: (context) => Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: Text(
                        'Dummy Modal for userId: '
                        '${userId ?? "Unknown"}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
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
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
} 