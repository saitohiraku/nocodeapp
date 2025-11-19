import 'package:flutter/material.dart';
import '../api/strapi_service.dart';

class GeneratePage extends StatefulWidget {
  const GeneratePage({Key? key}) : super(key: key);

  @override
  State<GeneratePage> createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  final _controller = TextEditingController();
  final _strapi = StrapiService();

  String selectedColor = '青';
  String selectedStyle = 'シンプル';
  bool isLoading = false;

  // プリセットボタン
  final templates = ['電卓', 'カレンダー', '時計'];

  // カラープリセット
  final colors = ['赤', '青', '緑'];

  Future<void> _generateApp(String keyword) async {
    setState(() => isLoading = true);
    try {
      final result = await _strapi.generateApp(
        keyword: keyword,
        color: selectedColor,
        style: selectedStyle,
      );
      print('✅ 生成成功: ${result['message']}');

      // 確認用にダイアログで結果表示
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('アプリ生成完了'),
          content: Text(result.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );
    } catch (e) {
      print('❌ 生成エラー: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AIアプリメーカー')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('キーワードを入力', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),

            // 入力フィールド
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '例：電卓、カレンダー...',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _generateApp(_controller.text);
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // テンプレートボタン群
            Wrap(
              spacing: 8,
              children: templates
                  .map((t) => ChoiceChip(
                        label: Text(t),
                        selected: false,
                        onSelected: (_) => _generateApp(t),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 24),

            // カラーテーマ選択
            const Text('カラーテーマ', style: TextStyle(fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: colors.map((c) {
                final isSelected = c == selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => selectedColor = c),
                  child: CircleAvatar(
                    backgroundColor: isSelected ? Colors.black : Colors.grey[300],
                    radius: 24,
                    child: CircleAvatar(
                      backgroundColor: c == '赤'
                          ? Colors.red
                          : c == '青'
                              ? Colors.blue
                              : Colors.green,
                      radius: 20,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // 柄（スタイル）選択
            const Text('デザインスタイル', style: TextStyle(fontSize: 16)),
            Wrap(
              spacing: 12,
              children: ['シンプル', 'ポップ']
                  .map((s) => ChoiceChip(
                        label: Text(s),
                        selected: s == selectedStyle,
                        onSelected: (_) => setState(() => selectedStyle = s),
                      ))
                  .toList(),
            ),

            const Spacer(),

            // ローディング or 生成ボタン
            Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('アプリを生成する'),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          _generateApp(_controller.text);
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
