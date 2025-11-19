// import 'package:flutter/material.dart';
// import 'api/strapi_api.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('AI App Maker Test')),
//         body: const ApiTestPage(),
//       ),
//     );
//   }
// }

// class ApiTestPage extends StatefulWidget {
//   const ApiTestPage({super.key});

//   @override
//   State<ApiTestPage> createState() => _ApiTestPageState();
// }

// class _ApiTestPageState extends State<ApiTestPage> {
//   String result = "テスト未実行";

//   Future<void> _checkConnection() async {
//     final api = StrapiApi();
//     try {
//       await api.testConnection();
//       setState(() => result = "✅ Strapiに接続成功");
//     } catch (e) {
//       setState(() => result = "❌ 接続エラー: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(result, style: const TextStyle(fontSize: 18)),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _checkConnection,
//             child: const Text("Strapi接続テスト"),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'api/strapi_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AIアプリメーカー',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GeneratePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GeneratePage extends StatefulWidget {
  const GeneratePage({super.key});

  @override
  State<GeneratePage> createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  final TextEditingController _keywordController = TextEditingController();
  bool _isLoading = false;
  String _result = '';
  final StrapiService _strapiService = StrapiService();

  Future<void> _onGenerate() async {
    setState(() => _isLoading = true);
    try {
      print('📡 Strapiに接続中...');
      final result = await _strapiService.generateApp(
        keyword: _keywordController.text,
        color: 'blue',
        style: 'simple',
      );

      setState(() {
        _result = result['message'] ?? '✅ 生成成功: アプリ生成成功';
      });
    } catch (e) {
      setState(() {
        _result = '❌ エラー: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AIアプリメーカー')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _keywordController,
              decoration: const InputDecoration(
                labelText: 'アプリのキーワードを入力 (例: 電卓)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _onGenerate,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('アプリを生成'),
            ),
            const SizedBox(height: 24),
            Text(
              _result,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
