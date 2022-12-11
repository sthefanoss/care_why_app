import 'dart:developer';

import 'package:dio/dio.dart';

class HttpClient {
  static final _dio = Dio(BaseOptions(headers: {
    "content-type": "application/json",
  }, listFormat: ListFormat.multiCompatible));

  static Interceptors get interceptors => _dio.interceptors;

  static void setToken(String? token) {
    if (token != null) {
      _dio.options.headers['token'] = token;
    } else {
      _dio.options.headers.remove('token');
    }
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {

    return _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> delete<T>(
      String path, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

class ErrorObserverInterceptor extends Interceptor {
  @override
  void onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) {
    log(err.response.toString(), name: err.requestOptions.path);
    handler.next(err);
  }
}
