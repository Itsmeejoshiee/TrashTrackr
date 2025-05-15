import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecyclingCodeArticle extends StatefulWidget {
  const RecyclingCodeArticle({super.key});

  @override
  State<RecyclingCodeArticle> createState() => _RecyclingCodeArticleState();
}

class _RecyclingCodeArticleState extends State<RecyclingCodeArticle> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(
            Uri.parse(
              'https://fnbreport.ph/14028/how-to-read-plastic-recycling-codes/',
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
