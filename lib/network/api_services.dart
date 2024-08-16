import 'package:dio/dio.dart';

import 'pretty_print.dart';

class DioService {
  final Dio dio;

  DioService(String token)
      : dio = Dio(
          BaseOptions(
            headers: {'Authorization': 'Bearer $token'},
            validateStatus: (_) => true,
          ),
        ) {
      dio.interceptors.add(PrettyDioLogger(
        request: true,
        requestBody: true,
        requestHeader: true,
      ));
  }

  Future<Response> get(String endpoint) async {
    try {
      final response = await dio.get(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String endpoint,
      {required Map<String, dynamic> data}) async {
    try {
      final response = await dio.post(endpoint, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.delete(endpoint, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
