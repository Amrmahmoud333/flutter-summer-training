import 'package:dio/dio.dart';

class DioHelper {
  static late Dio _dio;
  static inti() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://dummyjson.com',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({required String endpoint}) async {
    return await _dio.get(endpoint);
  }

  static Future<Response> postData({
    required String endpoint,
    required Map<String, dynamic> data,
  }) async {
    return await _dio.post(endpoint, data: data);
  }

  static Future<Response> deleteData({
    required String endpoint,
    required Map<String, dynamic> data,
  }) async {
    return await _dio.delete(endpoint, data: data);
  }
}
