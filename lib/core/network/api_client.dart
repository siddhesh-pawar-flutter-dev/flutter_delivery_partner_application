import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

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
    try {
      return await dio.get(path, queryParameters: queryParameters);
    } on DioException catch (error) {
      throw _mapError(error);
    }
  }

  Future<Response<dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dio.post(
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
      return const UnauthorizedException('Session expired. Please login again.');
    }

    final message =
        error.response?.data is Map<String, dynamic>
            ? (error.response?.data['message'] as String?) ??
                'Something went wrong.'
            : 'Something went wrong.';

    return ServerException(message);
  }
}
