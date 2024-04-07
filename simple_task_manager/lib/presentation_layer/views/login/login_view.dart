import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_validator/form_validator.dart';
import 'package:gap/gap.dart';
import 'package:simple_task_manager/application_layer/core/core.router.dart';
import 'package:simple_task_manager/application_layer/utils/rgeister_instance_util.dart';
import 'package:simple_task_manager/global/global_locators.dart';
import 'package:simple_task_manager/presentation_layer/colors/app_colors.dart';
import 'package:simple_task_manager/presentation_layer/theme/app_theme.dart';
import 'package:simple_task_manager/presentation_layer/views/login/delegates/login_delegate.dart';
import 'package:simple_task_manager/presentation_layer/views/register/register_view.dart';
import 'package:simple_task_manager/presentation_layer/widgets/app_text_form_field_widget.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.nonReactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, viewModel, child) => Scaffold(
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Form(
              key: viewModel.loginDelegate.loginFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(40),
                  Text(
                    "TASK-MANAGER",
                    style: appThem()
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: AppColors.brandPrimary),
                  ),
                  const Gap(10),
                  Text(
                    "Management App",
                    style: appThem()
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                  const Gap(80),
                  Text(
                    "Login to your account",
                    style: appThem()
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppColors.textPrimary),
                  ),
                  const Gap(40),
                  AppTextFormFieldWidget(
                    textEditingController:
                        viewModel.loginDelegate.emailCOntroller,
                    label: "Email",
                    icon: Icons.mail_rounded,
                    validator: ValidationBuilder().required().build(),
                  ),
                  const Gap(25),
                  AppTextFormFieldWidget(
                    textEditingController:
                        viewModel.loginDelegate.passwordController,
                    label: "Password",
                    icon: Icons.password_rounded,
                    validator:
                        ValidationBuilder().required().minLength(6).build(),
                  ),
                  const Gap(40),
                  CustomButtonWidget(
                    text: "Login",
                    onTap: () {
                      viewModel.loginDelegate.loginUser();
                    },
                  ),
                  const Gap(30),
                  SvgPicture.asset("assets/svg/login_with.svg"),
                  const Gap(30),
                  SvgPicture.asset("assets/svg/register_with.svg"),
                  const Gap(30),
                  InkWell(
                      onTap: () {
                        navigationService.replaceWith(Routes.registerView);
                      },
                      child:
                          SvgPicture.asset("assets/svg/dont_have_account.svg")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class LoginViewModel extends BaseViewModel {
  late final loginDelegate = lazyGetInstance(
      "loginDelegateInstance", () => LoginDelegate(viewModel: this));
}
