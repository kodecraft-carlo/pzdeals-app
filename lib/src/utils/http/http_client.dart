import 'package:dio/dio.dart';

class ApiClient {
  static final ApiClient _singleton = ApiClient._internal();

  Dio _dio;

  factory ApiClient() {
    return _singleton;
  }

  ApiClient._internal() : _dio = Dio() {
    BaseOptions baseOptions = BaseOptions(
      baseUrl: 'http://3.81.66.127:8055/',
      connectTimeout: const Duration(minutes: 3),
      receiveTimeout: const Duration(minutes: 3),
    );
    _dio = Dio(baseOptions);
    // _dio.interceptors.add(DirectusTokenInterceptor());
    _dio.options.headers['Authorization'] =
        'Bearer T31Er9KbfbINcnS4vTuI-Yrnv0EhYFk9';
  }

  Dio get dio => _dio;
}
