import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for platform specific params
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class ChildcareWebView extends StatefulWidget {
  const ChildcareWebView({super.key});

  @override
  State<ChildcareWebView> createState() => _ChildcareWebViewState();
}

class _ChildcareWebViewState extends State<ChildcareWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _logPageView();
    _initWebView();
  }

  Future<void> _logPageView() async {
    await FirebaseAnalytics.instance.logEvent(name: 'childcare_reg_page_viewed');
  }

  void _initWebView() {
    // Platform-specific initialization parameters
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    // setJavaScriptMode is not supported on Web (it's always enabled/unrestricted by default on standard web browsers)
    if (!kIsWeb) {
      controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    }

    controller
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            if (mounted) setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.ezchildtrack.com/parentapplicationa/en/primary'));

    _controller = controller;
  }

  @override
  void dispose() {
    FirebaseAnalytics.instance.logEvent(name: 'returned_from_childcare_reg');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Childcare Registration'),
        // Use a close button instead of back arrow to signify "modal/external" feel
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
