import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_validator/form_validator.dart';
import 'package:gap/gap.dart';
import 'package:simple_task_manager/application_layer/core/core.router.dart';
import 'package:simple_task_manager/application_layer/utils/rgeister_instance_util.dart';
import 'package:simple_task_manager/global/global_locators.dart';
import 'package:simple_task_manager/presentation_layer/colors/app_colors.dart';
import 'package:simple_task_manager/presentation_layer/theme/app_theme.dart';
import 'package:simple_task_manager/presentation_layer/utils/screen_utils.dart';
import 'package:simple_task_manager/presentation_layer/views/register/delegates/register_delegate.dart';
import 'package:simple_task_manager/presentation_layer/widgets/app_text_form_field_widget.dart';
import 'package:stacked/stacked.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterViewModel>.nonReactive(
      viewModelBuilder: () => RegisterViewModel(),
      builder: (context, viewModel, child) => Scaffold(
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Form(
              key: viewModel.registerDelegate.registerFormKey,
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
                    "Create your account",
                    style: appThem()
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppColors.textPrimary),
                  ),
                  const Gap(40),
                  AppTextFormFieldWidget(
                    textEditingController:
                        viewModel.registerDelegate.emailCOntroller,
                    label: "Email",
                    icon: Icons.mail_rounded,
                    validator: ValidationBuilder().required().email().build(),
                  ),
                  const Gap(25),
                  AppTextFormFieldWidget(
                    textEditingController:
                        viewModel.registerDelegate.passwordController,
                    label: "Password",
                    icon: Icons.password_rounded,
                    validator:
                        ValidationBuilder().required().minLength(6).build(),
                  ),
                  const Gap(40),
                  CustomButtonWidget(
                    text: "Register",
                    onTap: () {
                      viewModel.registerDelegate.loginUser();
                    },
                  ),
                  const Gap(30),
                  SvgPicture.asset("assets/svg/or_register_with.svg"),
                  const Gap(30),
                  SvgPicture.asset("assets/svg/register_with.svg"),
                  const Gap(30),
                  InkWell(
                      onTap: () {
                        navigationService.replaceWith(Routes.loginView);
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

class CustomButtonWidget extends StatelessWidget {
  final void Function()? onTap;
  final String? text;
  final Color? fillColor;
  final Color? borderColor;
  final Color? textColor;

  const CustomButtonWidget({
    super.key,
    this.onTap,
    this.text,
    this.fillColor,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            color: AppColors.brandPrimary),
        child: Text(
          text ?? "Button",
          style:
              appThem().textTheme.bodyLarge?.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}

class CustomAuthTextFiledWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String id;
  final String? Function(String?)? validator;
  final String? hint;
  final Widget? icon;
  const CustomAuthTextFiledWidget({
    required this.id,
    super.key,
    this.controller,
    this.validator,
    this.hint,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grayLight),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      width: screenHeightFraction(
        context,
        max: 400,
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: const BoxDecoration(
              color: AppColors.brandPrimary,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
            ),
            child: icon ?? SvgPicture.asset("assets/svg/Message.svg"),
          ),
          const Gap(8),
          Flexible(
            flex: 3,
            child: FormBuilderTextField(
              controller: controller,
              validator: validator,
              decoration: InputDecoration.collapsed(
                  hintText: hint,
                  hintStyle: appThem()
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.textSecondary)),
              name: id,
            ),
          ),
        ],
      ),
    );
  }
}

final class RegisterViewModel extends BaseViewModel {
  late final registerDelegate = lazyGetInstance(
      "registerDelegateInstance", () => RegisterDelegate(viewModel: this));
}
