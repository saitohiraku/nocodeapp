import 'package:flutter/material.dart';
import 'api/strapi_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('AI App Maker Test')),
        body: const ApiTestPage(),
      ),
    );
  }
}

class ApiTestPage extends StatefulWidget {
  const ApiTestPage({super.key});

  @override
  State<ApiTestPage> createState() => _ApiTestPageState();
}

class _ApiTestPageState extends State<ApiTestPage> {
  String result = "テスト未実行";

  Future<void> _checkConnection() async {
    final api = StrapiApi();
    try {
      await api.testConnection();
      setState(() => result = "✅ Strapiに接続成功");
    } catch (e) {
      setState(() => result = "❌ 接続エラー: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(result, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _checkConnection,
            child: const Text("Strapi接続テスト"),
          ),
        ],
      ),
    );
  }
}
