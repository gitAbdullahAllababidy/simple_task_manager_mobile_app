import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_task_manager/application_layer/core/core.router.dart';
import 'package:simple_task_manager/application_layer/utils/user_authectication_util.dart';
import 'package:simple_task_manager/global/global_locators.dart';
import 'package:simple_task_manager/presentation_layer/colors/app_colors.dart';
import 'package:simple_task_manager/presentation_layer/theme/app_theme.dart';
import 'package:simple_task_manager/presentation_layer/utils/loading_utils.dart';
import 'package:stacked/stacked.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EntryViewModel>.nonReactive(
      onViewModelReady: (viewModel) => viewModel.runStartupLogic(),
      viewModelBuilder: () => EntryViewModel(),
      builder: (context, viewModel, child) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "TASK-MANAGER",
                style: appThem()
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: AppColors.brandPrimary),
              ),
              const Gap(8),
              appLoaderWidget()
            ],
          ),
        ),
      ),
    );
  }
}

final class EntryViewModel extends BaseViewModel {
  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    await Future.delayed(Durations.extralong4);
    var isLoggedInUser = await UserAuthenticationUtil.isUserLoggedIn();
    if (isLoggedInUser) {
      // This is where you can make decisions on where your app should navigate when
      // you have custom startup logic
      await storingTasksUtil.initialize();
      return navigationService.replaceWithHome();
    }
    return navigationService.replaceWithLoginView();
  }
}
