import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ResultsPage extends StatelessWidget {
  final String htmlCode;

  const ResultsPage({Key? key, required this.htmlCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("生成アプリ実行")),
      body: InAppWebView(
        initialData: InAppWebViewInitialData(
          data: htmlCode,
        ),
      ),
    );
  }
}
