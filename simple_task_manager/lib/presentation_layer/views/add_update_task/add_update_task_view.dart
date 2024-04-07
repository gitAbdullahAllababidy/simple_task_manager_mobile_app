import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_validator/form_validator.dart';
import 'package:gap/gap.dart';
import 'package:simple_task_manager/data_layer/models/res/tasks/todo_response_model.dart';
import 'package:simple_task_manager/global/global_locators.dart';
import 'package:simple_task_manager/presentation_layer/colors/app_colors.dart';
import 'package:simple_task_manager/presentation_layer/theme/app_theme.dart';
import 'package:simple_task_manager/presentation_layer/utils/screen_utils.dart';
import 'package:simple_task_manager/presentation_layer/views/add_update_task/delegates/add_update_task_delegate.dart';
import 'package:simple_task_manager/presentation_layer/views/register/register_view.dart';
import 'package:simple_task_manager/presentation_layer/widgets/app_text_form_field_widget.dart';
import 'package:stacked/stacked.dart';

class AddUpdateTaskView extends StatelessWidget {
  final TodoResponseModel? updatableTaskModel;
  const AddUpdateTaskView({super.key, this.updatableTaskModel});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddUpdateTaskViewModel>.reactive(
      viewModelBuilder: () => AddUpdateTaskViewModel(updatableTaskModel),
      builder: (context, viewModel, child) => Scaffold(
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Stack(children: [
            Container(
                height: screenHeight(context),
                width: screenWidth(context),
                color: AppColors.brandPrimary,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Column(
                      children: [
                        Gap(
                          screenHeight(context) / 8,
                        ),
                        Text(
                          _updateMode ? "Update task" : "Add Task",
                          style: appThem()
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: AppColors.white),
                        ),
                      ],
                    ),
                    Positioned(
                        top: screenHeight(context) / 16,
                        left: 20,
                        child: const WhiteBackButton())
                  ],
                )),
            Positioned(
              bottom: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                constraints:
                    BoxConstraints(maxHeight: screenHeight(context) / 1.3),
                decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                width: screenWidth(context),
                alignment: Alignment.center,
                child: Form(
                  key: viewModel.taskDelegate.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(40),
                      Text(
                        "Task title",
                        style: appThem()
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: AppColors.brandPrimary),
                      ),
                      AppTextFormFieldWidget(
                        label: "",
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        textEditingController:
                            viewModel.taskDelegate.titleCOntroller,
                        validator: ValidationBuilder()
                            .required()
                            .minLength(1)
                            .maxLength(100)
                            .build(),
                      ),
                      const Gap(25),
                      Text(
                        "Task description",
                        style: appThem()
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: AppColors.brandPrimary),
                      ),
                      AppTextFormFieldWidget(
                        label: "",
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        textEditingController:
                            viewModel.taskDelegate.descriptionController,
                        maxLines: 12,
                        validator: ValidationBuilder()
                            .required()
                            .minLength(1)
                            .maxLength(800)
                            .build(),
                      ),
                      const Gap(20),
                      Text(
                        "Task Completion Status",
                        style: appThem()
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: AppColors.brandPrimary),
                      ),
                      Switch.adaptive(
                        value: viewModel.taskDelegate.taskCompletionStatus,
                        onChanged: (bool newValue) {
                          viewModel.taskDelegate.taskCompletionStatus =
                              newValue;
                          viewModel.rebuildUi();
                        },
                      ),
                      const Gap(40),
                      CustomButtonWidget(
                        text: _updateMode ? "Update" : "Submit",
                        onTap: () {
                          _updateMode
                              ? viewModel.taskDelegate.updateTask()
                              : viewModel.taskDelegate.addNewTask();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  bool get _updateMode => updatableTaskModel != null;
}

class WhiteBackButton extends StatelessWidget {
  const WhiteBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigationService.back,
      child: SvgPicture.asset("assets/svg/white_back_button.svg"),
    );
  }
}

final class AddUpdateTaskViewModel extends BaseViewModel {
  final TodoResponseModel? updatableTaskModel;

  AddUpdateTaskViewModel(this.updatableTaskModel);
  late final taskDelegate = AddUpdateTaskDelegate(
    viewModel: this,
  );
}
