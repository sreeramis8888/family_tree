import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';
import 'package:familytree/src/interface/components/loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:familytree/src/interface/components/ModalSheets/user_details_modal_sheet.dart';

class FamilyTreeWebView extends StatefulWidget {
  final String? familyId;

  const FamilyTreeWebView({Key? key, this.familyId}) : super(key: key);

  @override
  State<FamilyTreeWebView> createState() => _FamilyTreeWebViewState();
}

class _FamilyTreeWebViewState extends State<FamilyTreeWebView> {
  InAppWebViewController? _webViewController;
  bool _isLoading = true;

  // Build the URL with optional family ID parameter
  String get _webViewUrl {
    String baseUrl = 'https://kalathingalneelatt.com/app/families';
    if (widget.familyId != null && widget.familyId!.isNotEmpty) {
      return '$baseUrl?familyId=${widget.familyId}';
    }
    return baseUrl;
  }

  Future<bool> _onWillPop() async {
    if (_webViewController != null) {
      bool canGoBack = await _webViewController!.canGoBack();
      if (canGoBack) {
        await _webViewController!.goBack();
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kWhite,
          forceMaterialTransparency: true,
          scrolledUnderElevation: 0,
          elevation: 0,
          title: GestureDetector(
            onTap: () async {
              if (_webViewController != null) {
                bool canGoBack = await _webViewController!.canGoBack();
                if (canGoBack) {
                  await _webViewController!.goBack();
                  return;
                }
              }
              Navigator.pop(context);
            },
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
          // // Optional: Add a search button in the app bar
          // actions: [
          //   if (widget.familyId != null)
          //     IconButton(
          //       icon: const Icon(Icons.center_focus_strong, color: Colors.blue),
          //       onPressed: () {
          //         // Re-focus on the initial family
          //         _webViewController?.evaluateJavascript(source: """
          //           if (window.zoomToFamily) {
          //             window.zoomToFamily('${widget.familyId}');
          //           }
          //         """);
          //       },
          //       tooltip: "Focus on Family",
          //     ),
          //   IconButton(
          //     icon: const Icon(Icons.search, color: Colors.blue),
          //     onPressed: () {
          //       _showSearchDialog();
          //     },
          //     tooltip: "Search Family",
          //   ),
          // ],
        ),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(_webViewUrl),
              ),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  transparentBackground: true,
                  javaScriptEnabled: true,
                  useShouldOverrideUrlLoading: true,
                ),
              ),
              onWebViewCreated: (controller) {
                _webViewController = controller;

                // Add JavaScript handler for navigation
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
                    return null;
                  },
                );

                // Add JavaScript handler for family search from Flutter
                controller.addJavaScriptHandler(
                  handlerName: 'searchFamily',
                  callback: (args) async {
                    final familyId = args.isNotEmpty ? args[0] : null;
                    if (familyId != null) {
                      // You can handle the search result here if needed
                      debugPrint('Family found: $familyId');
                      // Show a snackbar or toast to confirm search result
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Found family: $familyId'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
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

                // Inject JavaScript functions for Flutter to call
                await controller.evaluateJavascript(source: """
                  window.zoomToFamily = function(familyId) {
                    // This function will be available in the React component
                    if (window.reactFlowZoomToNode) {
                      window.reactFlowZoomToNode(familyId);
                    }
                  };
                  
                  window.searchFamilyFromFlutter = function(query) {
                    // This function allows Flutter to trigger search
                    if (window.reactFlowSearch) {
                      window.reactFlowSearch(query);
                    }
                  };
                """);
              },
              onConsoleMessage: (controller, consoleMessage) {
                // Handle console messages
                debugPrint('Console: ${consoleMessage.message}');
              },
              onLoadError: (controller, url, code, message) {
                debugPrint('WebView Load Error: $message');
                // Show error message to user
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error loading family tree: $message'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
            if (_isLoading) const Center(child: LoadingAnimation()),
          ],
        ),
        // Optional: Add floating action button for search (alternative to app bar button)
        // floatingActionButton: !_isLoading
        //     ? FloatingActionButton(
        //         onPressed: () {
        //           _showSearchDialog();
        //         },
        //         backgroundColor: Colors.blue,
        //         child: const Icon(Icons.search, color: Colors.white),
        //         tooltip: "Search Family",
        //       )
        //     : null,
      ),
    );
  }

  // Show search dialog
  void _showSearchDialog() {
    String searchQuery = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search Family'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  searchQuery = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter family name or ID',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                autofocus: true,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _performSearch(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'You can search by family name or family ID',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (searchQuery.isNotEmpty) {
                  _performSearch(searchQuery);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  // Perform search function
  void _performSearch(String query) {
    if (_webViewController != null) {
      _webViewController!.evaluateJavascript(source: """
        if (window.searchFamilyFromFlutter) {
          window.searchFamilyFromFlutter('$query');
        }
      """);
    }
  }

  // Method to zoom to a specific family (can be called from outside)
  void zoomToFamily(String familyId) {
    if (_webViewController != null) {
      _webViewController!.evaluateJavascript(source: """
        if (window.zoomToFamily) {
          window.zoomToFamily('$familyId');
        }
      """);
    }
  }

  // Method to refresh the family tree
  void refreshFamilyTree() {
    if (_webViewController != null) {
      _webViewController!.reload();
    }
  }

  @override
  void dispose() {
    _webViewController = null;
    super.dispose();
  }
}
