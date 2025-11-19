import 'package:dio/dio.dart';

class StrapiApi {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.4.168:1337/api', // ← StrapiのAPI URL
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<void> testConnection() async {
    try {
      final response = await _dio.get('/apps');
      print('✅ Strapi接続成功: ${response.data}');
    } catch (e) {
      print('❌ 接続エラー: $e');
    }
  }
}
