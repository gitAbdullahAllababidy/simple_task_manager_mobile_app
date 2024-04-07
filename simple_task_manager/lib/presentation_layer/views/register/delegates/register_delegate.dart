import 'package:bot_toast/bot_toast.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:simple_task_manager/application_layer/core/core.locator.dart';
import 'package:simple_task_manager/application_layer/core/core.router.dart';
import 'package:simple_task_manager/application_layer/utils/user_authectication_util.dart';
import 'package:simple_task_manager/data_layer/models/res/auth/auth_response_model.dart';
import 'package:simple_task_manager/data_layer/repositories/auth_repo.dart';
import 'package:simple_task_manager/global/global_locators.dart';
import 'package:simple_task_manager/presentation_layer/abstractions/view_model_abstraction.dart';
import 'package:simple_task_manager/presentation_layer/utils/loading_utils.dart';
import 'package:simple_task_manager/presentation_layer/views/register/register_view.dart';

final class RegisterDelegate extends ViewModelAbstraction<RegisterViewModel > {
  final emailCOntroller = TextEditingController();
  final passwordController = TextEditingController();
  final registerFormKey = GlobalKey<FormState>();

  RegisterDelegate({required super.viewModel});

  ///LoginUser
  loginUser() {
    if (registerFormKey.currentState?.validate() != true) {
      return;
    }
    final authRepo = locator<AuthRepo>();
    appLoadingCallback(
            authRepo.registerUser(
                Tuple2(emailCOntroller.text, passwordController.text)),
            cancelToken: authRepo.cancelToken)
        .then((value) {
      value.fold((l) => {showError(l)}, (r) {
        _success(r);
      });
    });
  }

  void _success(AuthResponseModel r) {
    BotToast.showText(text: "Success Register");
    final userInfo = r;
    if (userInfo.token != null) {
      UserAuthenticationUtil.saveUserInfo(userInfo);
      navigationService.clearStackAndShow(Routes.splashView);
    }
  }
}
