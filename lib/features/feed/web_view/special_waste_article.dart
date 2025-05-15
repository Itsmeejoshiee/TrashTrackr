import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SpecialWasteArticle extends StatefulWidget {
  const SpecialWasteArticle({super.key});

  @override
  State<SpecialWasteArticle> createState() => _SpecialWasteArticle();
}

class _SpecialWasteArticle extends State<SpecialWasteArticle> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(
            Uri.parse(
              'https://reecollabb.com/e-waste-recycling-and-regular-recycling/',
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: WebViewWidget(controller: controller),
    );
  }
}
