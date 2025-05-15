import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KnowYourBinArticle extends StatefulWidget {
  const KnowYourBinArticle({super.key});

  @override
  State<KnowYourBinArticle> createState() => _KnowYourBinArticleState();
}

class _KnowYourBinArticleState extends State<KnowYourBinArticle> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(
            Uri.parse('https://www.wm.com/us/en/recycle-right/recycling-101'),
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
