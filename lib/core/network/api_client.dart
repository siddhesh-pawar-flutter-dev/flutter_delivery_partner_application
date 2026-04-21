import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:hive_flutter/hive_flutter.dart';

import '../error/exceptions.dart';
import '../utils/app_constants.dart';
import '../utils/app_pages.dart';
import '../utils/storage_service.dart';

class ApiClient {
  ApiClient(this.storageService)
    : dio = Dio(
        BaseOptions(
          baseUrl: AppConstants.baseUrl,
          connectTimeout: const Duration(seconds: 25),
          receiveTimeout: const Duration(seconds: 25),
          sendTimeout: const Duration(seconds: 25),
          headers: {'Accept': 'application/json'},
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = storageService.token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await storageService.clearSession();
            if (Get.currentRoute != AppPages.login) {
              Get.offAllNamed(AppPages.login);
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  final Dio dio;
  final StorageService storageService;

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final String cacheKey = _generateCacheKey(path, queryParameters);
    final Box box = Hive.box('api_cache');

    final cachedEntry = box.get(cacheKey);
    final bool hasCache = cachedEntry != null;

    bool isCacheValid = false;
    if (hasCache) {
      final DateTime cacheTime = DateTime.parse(
        cachedEntry['timestamp'] as String,
      );
      if (DateTime.now().difference(cacheTime).inMinutes < 20) {
        isCacheValid = true;
      }
    }

    // Return cached data if valid
    if (isCacheValid) {
      return Response(
        requestOptions: RequestOptions(
          path: path,
          queryParameters: queryParameters,
        ),
        data: jsonDecode(cachedEntry['data'] as String),
        statusCode: 200,
      );
    }

    try {
      final response = await dio.get(path, queryParameters: queryParameters);

      // Store new data with current timestamp
      box.put(cacheKey, {
        'timestamp': DateTime.now().toIso8601String(),
        'data': jsonEncode(response.data),
      });

      return response;
    } on DioException catch (error) {
      // Fallback to expired cache if API fails
      if (hasCache) {
        return Response(
          requestOptions: RequestOptions(
            path: path,
            queryParameters: queryParameters,
          ),
          data: jsonDecode(cachedEntry['data'] as String),
          statusCode: 200,
        );
      }
      throw _mapError(error);
    }
  }

  String _generateCacheKey(String path, Map<String, dynamic>? queryParameters) {
    if (queryParameters == null || queryParameters.isEmpty) return path;
    final sortedKeys = queryParameters.keys.toList()..sort();
    final queryStr = sortedKeys
        .map((k) => '$k=${queryParameters[k]}')
        .join('&');
    return '$path?$queryStr';
  }

  Future<Response<dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dio.post(path, data: data, queryParameters: queryParameters);
    } on DioException catch (error) {
      throw _mapError(error);
    }
  }

  Future<Response<dynamic>> patch(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (error) {
      throw _mapError(error);
    }
  }

  AppException _mapError(DioException error) {
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const NoInternetException(
        'Unable to connect. Please check your internet connection.',
      );
    }

    if (error.response?.statusCode == 401) {
      return const UnauthorizedException(
        'Session expired. Please login again.',
      );
    }

    final message = error.response?.data is Map<String, dynamic>
        ? (error.response?.data['message'] as String?) ??
              'Something went wrong.'
        : 'Something went wrong.';

    return ServerException(message);
  }
}
