import 'package:dio/dio.dart';
import 'package:simple_task_manager/application_layer/core/core.locator.dart';
import 'package:simple_task_manager/application_layer/services/network_service.dart';

mixin RepoMixin {
  String? _userId;

  String? get userId => _userId;

  set userId(String? value) {
    _userId = value;
  }

  NetworkService networkService = locator<NetworkService>();
  CancelToken cancelToken = CancelToken();
}
