
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for platform specific params
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../services/remote_config/remote_config_service.dart';

class ChildcareWebView extends ConsumerStatefulWidget {
  const ChildcareWebView({super.key});

  @override
  ConsumerState<ChildcareWebView> createState() => _ChildcareWebViewState();
}

class _ChildcareWebViewState extends ConsumerState<ChildcareWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _logPageView();
    // Defer initialization to get ref access safely? 
    // Actually in initState we can read providers but better to do it in didChangeDependencies or just grab it.
    // However, for async/late init, let's do it in a simplified helper.
    // NOTE: We need the URL *before* we loadRequest.
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
     _initWebView();
  }

  Future<void> _logPageView() async {
    await FirebaseAnalytics.instance.logEvent(name: 'childcare_reg_page_viewed');
  }

  void _initWebView() {
    // 1. Get URL from Remote Config
    final remoteConfig = ref.read(remoteConfigProvider);
    final url = remoteConfig.getString(RemoteConfigKeys.childcareUrl);

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
          onWebResourceError: (WebResourceError error) {
             debugPrint('WebView Error: ${error.description}');
          }
        ),
      )
      ..loadRequest(Uri.parse(url));

    _controller = controller;
  }

  @override
  void dispose() {
    FirebaseAnalytics.instance.logEvent(name: 'returned_from_childcare_reg');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Note: If _controller is not initialized this will crash, but didChangeDependencies runs before build.
    // Ideally we use a FutureBuilder for async config, but config is sync after init.
    
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
