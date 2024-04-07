import 'package:simple_task_manager/application_layer/core/core.dialogs.dart';
import 'package:simple_task_manager/application_layer/core/core.router.dart';
import 'package:simple_task_manager/application_layer/utils/user_authectication_util.dart';
import 'package:simple_task_manager/global/global_locators.dart';

final class LogoutServices {
  static logout() async => {
        await UserAuthenticationUtil.logoutUser(),
        await storingTasksUtil.dispose(),
        await navigationService.clearStackAndShow(Routes.splashView)
      };

  static void showDialog() {
    dialogService
        .showCustomDialog(
      barrierDismissible: true,
      variant: DialogType.infoAlert,
      title: "Attention",
      description:
          "You are about logging out and losing your data!, are you sure!",
    )
        .then((value) {
      if (value?.confirmed ?? false) {
        LogoutServices.logout();
      }
    });
  }
}
