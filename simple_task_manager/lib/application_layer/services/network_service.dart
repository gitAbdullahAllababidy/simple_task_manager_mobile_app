import 'package:bot_toast/bot_toast.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:simple_task_manager/application_layer/core/core.dart';
import 'package:simple_task_manager/global/types.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

class NetworkService {
  final _dio = Dio();

  NetworkService() {
    _dio
      ..interceptors.addAll([
        TalkerDioLogger(
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printResponseHeaders: true,
            printResponseMessage: true,
          ),
        ),
      ])
      ..options = BaseOptions(
          baseUrl: App.devSettings.$2,
          connectTimeout: const Duration(seconds: 5));
  }

  Future<AppResponseType<T?>> getRequest<T>(
    String path, {
    Object? data,
    List<Interceptor>? interceptors,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool authorized = false,
  }) async {
    options = Options();
    try {
      if (interceptors is List<Interceptor>) {
        _dio.interceptors.addAll(interceptors);
      }

      if (authorized) {
        options = options.copyWith(headers: _getAuthHeader());
      }
      final res = await _dio.get<T>(path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress);
      final resData = res.data;

      return right(resData);
    } on Exception catch (e) {
      if (e is DioException) {
        return _dioExceptionHandler<T>(e);
      }

      return left(e);
    }
  }

  Future<AppResponseType<T?>> postRequest<T>(String path,
      {Object? data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      List<Interceptor>? interceptors,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      bool authorized = false}) async {
    options = Options();
    try {
      if (interceptors is List<Interceptor>) {
        _dio.interceptors.addAll(interceptors);
      }
      if (authorized) {
        options = options.copyWith(headers: _getAuthHeader());
      }
      final res = await _dio.post<T>(path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onReceiveProgress,
          onReceiveProgress: onReceiveProgress);
      final resData = res.data;

      return right(resData);
    } on Exception catch (e) {
      if (e is DioException) {
        return _dioExceptionHandler<T>(e);
      }

      return left(e);
    }
  }

  Future<AppResponseType<T?>> patchRequest<T>(String path,
      {Object? data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      List<Interceptor>? interceptors,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      bool authorized = false}) async {
    options = Options();
    try {
      if (interceptors is List<Interceptor>) {
        _dio.interceptors.addAll(interceptors);
      }
      if (authorized) {
        options = options.copyWith(headers: _getAuthHeader());
      }
      final res = await _dio.patch<T>(path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onReceiveProgress,
          onReceiveProgress: onReceiveProgress);
      final resData = res.data;

      return right(resData);
    } on Exception catch (e) {
      if (e is DioException) {
        return _dioExceptionHandler<T>(e);
      }

      return left(e);
    }
  }

  Future<AppResponseType<T?>> deleteRequest<T>(String path,
      {Object? data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      List<Interceptor>? interceptors,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      bool authorized = false}) async {
    options = Options();
    try {
      if (interceptors is List<Interceptor>) {
        _dio.interceptors.addAll(interceptors);
      }
      if (authorized) {
        options = options.copyWith(headers: _getAuthHeader());
      }
      final res = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      final resData = res.data;

      return right(resData);
    } on Exception catch (e) {
      if (e is DioException) {
        return _dioExceptionHandler<T>(e);
      }

      return left(e);
    }
  }

  ///Dio Exception handler
  Either<dynamic, T> _dioExceptionHandler<T>(
    DioException e,
  ) {
    return switch (e.type) {
      DioExceptionType.badResponse => _responseDataObjectError<T>(e),
      DioExceptionType.connectionError ||
      DioExceptionType.connectionTimeout =>
        left(BotToast.showText(text: "Connection issue, try again later!")),
      _ => left(e)
    };
  }

  AppResponseType<T> _responseDataObjectError<T>(DioException e) {
    final errorResponseDataObject = (e.response?.data ?? {});
    return left(errorResponseDataObject);
  }

  Map<String, Object> _getAuthHeader() {
    return {'authorization': 'Bearer '};
  }
}
