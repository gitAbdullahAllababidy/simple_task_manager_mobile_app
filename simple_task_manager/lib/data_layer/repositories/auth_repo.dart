import 'package:dartz/dartz.dart';
import 'package:simple_task_manager/data_layer/abstractions/repo_mixin.dart';
import 'package:simple_task_manager/data_layer/apis/apis.dart';
import 'package:simple_task_manager/data_layer/models/res/auth/auth_response_model.dart';
import 'package:simple_task_manager/global/types.dart';

class AuthRepo with RepoMixin {
  ///
  ///LoginUser
  Future<AppResponseType<AuthResponseModel>> loginUser(
      Tuple2<String, String> loginCreds) async {
    final userCreds = {
      "username": loginCreds.value1,
      "password": loginCreds.value2,
      "expiresInMins" : 60
    };
    return await networkService
        .postRequest<Map<String, dynamic>>(Apis.login,
            data: userCreds, cancelToken: cancelToken)
        .then((value) => value.fold(
            (l) => Left(l), (r) => Right(AuthResponseModel.fromMap(r ?? {}))));
  }

  ///RegisterUser
  Future<AppResponseType<AuthResponseModel>> registerUser(
      Tuple2<String, String> loginCreds) async {
    final userCreds = {
      "email": loginCreds.value1,
      "password": loginCreds.value2
    };
    return await networkService
        .postRequest<Map<String, dynamic>>(Apis.register,
            data: userCreds, cancelToken: cancelToken)
        .then((value) => value.fold(
            (l) => Left(l), (r) => Right(AuthResponseModel.fromMap(r ?? {}))));
  }
}
