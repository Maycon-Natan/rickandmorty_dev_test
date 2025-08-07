import 'package:flutter/foundation.dart';
import 'package:teste_tecnico_fteam/src/core/client_http/client_http.dart';
import 'package:teste_tecnico_fteam/src/core/client_http/dio/dio_adapter.dart';
import 'package:teste_tecnico_fteam/src/core/client_http/rest_client_multipart.dart';
import 'package:dio/dio.dart';

class DioFactory {
  static Dio dio() {
    final baseOptions = BaseOptions(
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 90000),
      sendTimeout: const Duration(milliseconds: 30000),
      validateStatus: (status) {
        return status != null && status < 500;
      },
    );
    return Dio(baseOptions);
  }
}

class RestClientDioImpl implements IRestClient {
  final Dio _dio;

  RestClientDioImpl({required Dio dio}) : _dio = dio;

  @override
  Future<RestClientResponse> upload(RestClientMultipart multipart) async {
    final formData = FormData.fromMap({
      multipart.fileKey: MultipartFile.fromBytes(
        multipart.fileBytes ?? [],
        filename: multipart.fileName,
      ),
    });

    final baseOptions = BaseOptions(
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 90000),
      sendTimeout: const Duration(milliseconds: 30000),
      validateStatus: (status) {
        return status != null && status < 500;
      },
    );

    Dio dio = Dio(baseOptions);
    final response = await dio.put(multipart.path, data: formData);

    return DioAdapter.toClientResponse(response);
  }

  @override
  Future<RestClientResponse> delete(RestClientRequest request) async {
    try {
      final response = await _dio.delete(
        request.path,
        data: request.data,
        queryParameters: request.queryParameters,
        options: Options(headers: request.headers),
      );
      return DioAdapter.toClientResponse(response);
    } on DioException catch (e) {
      throw DioAdapter.toClientException(e);
    }
  }

  @override
  Future<RestClientResponse> get(RestClientRequest request) async {
    try {
      final response = await _dio.get(
        request.path,
        queryParameters: request.queryParameters,
        options: Options(headers: request.headers),
      );
      return DioAdapter.toClientResponse(response);
    } on DioException catch (e) {
      throw DioAdapter.toClientException(e);
    }
  }

  @override
  Future<RestClientResponse> patch(RestClientRequest request) async {
    try {
      final response = await _dio.patch(
        request.path,
        data: request.data,
        queryParameters: request.queryParameters,
        options: Options(headers: request.headers),
      );
      return DioAdapter.toClientResponse(response);
    } on DioException catch (e) {
      throw DioAdapter.toClientException(e);
    }
  }

  @override
  Future<RestClientResponse> post(RestClientRequest request) async {
    try {
      final response = await _dio.post(
        request.path,
        data: request.data,
        queryParameters: request.queryParameters,
        options: Options(headers: request.headers),
      );
      return DioAdapter.toClientResponse(response);
    } on DioException catch (e) {
      debugPrint(e.message);
      throw DioAdapter.toClientException(e);
    }
  }

  @override
  Future<RestClientResponse> put(RestClientRequest request) async {
    try {
      final response = await _dio.put(
        request.path,
        data: request.data,
        queryParameters: request.queryParameters,
        options: Options(headers: request.headers),
      );
      return DioAdapter.toClientResponse(response);
    } on DioException catch (e) {
      throw DioAdapter.toClientException(e);
    }
  }
}
