import 'package:dio/dio.dart';

class StrapiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:1337/api', // ← 自分のローカルIPに変更！
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<Map<String, dynamic>> generateApp({
    required String keyword,
    required String color,
    required String style,
  }) async {
    try {
      print('📡 Strapiへ送信中...');
      final response = await _dio.post(
        '/generate',
        data: {'keyword': keyword, 'color': color, 'style': style},
      );
      print('✅ Strapiレスポンス: ${response.statusCode}');
      return response.data;
    } catch (e) {
      print('❌ Strapiエラー: $e');
      rethrow;
    }
  }
}
