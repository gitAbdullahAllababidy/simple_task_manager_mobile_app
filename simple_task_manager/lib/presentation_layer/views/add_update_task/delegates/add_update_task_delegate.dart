import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:simple_task_manager/application_layer/core/core.locator.dart';
import 'package:simple_task_manager/application_layer/utils/user_authectication_util.dart';
import 'package:simple_task_manager/data_layer/models/res/tasks/todo_response_model.dart';
import 'package:simple_task_manager/data_layer/models/users/tasks_response_wrapper_model.dart';
import 'package:simple_task_manager/data_layer/repositories/tasks_repo.dart';
import 'package:simple_task_manager/global/global_locators.dart';
import 'package:simple_task_manager/presentation_layer/abstractions/view_model_abstraction.dart';
import 'package:simple_task_manager/presentation_layer/utils/loading_utils.dart';
import 'package:simple_task_manager/presentation_layer/views/add_update_task/add_update_task_view.dart';

final class AddUpdateTaskDelegate
    extends ViewModelAbstraction<AddUpdateTaskViewModel> {
  ///finals

  final formKey = GlobalKey<FormState>();

  ///Late variables
  late final titleCOntroller = TextEditingController(text: "Simple task title");
  late final descriptionController = TextEditingController(
      text: viewModel.updatableTaskModel?.todo ?? "Simple task description");
  late bool _taskCompletionStatus =
      viewModel.updatableTaskModel?.completed ?? false;

  bool get taskCompletionStatus => _taskCompletionStatus;

  set taskCompletionStatus(value) {
    _taskCompletionStatus = value;
  }

  AddUpdateTaskDelegate({
    required super.viewModel,
  });

  ///Add new
  addNewTask() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }
    final userId = await UserAuthenticationUtil.getUserId()
        .then((value) => value.fold((l) => null, (r) => int.parse(r)));
    final taskRepo = locator<TasksRepo>();
    await appLoadingCallback(
            taskRepo.createNewTask(
                todo: TodoResponseModel(
                    todo: descriptionController.text,
                    completed: _taskCompletionStatus,
                    userId: userId)),
            cancelToken: taskRepo.cancelToken)
        .then((value) {
      value.fold((l) => {showError(l)}, (r) {
        _success(r);
      });
    });
  }

  ///Update
  updateTask() {
    if (formKey.currentState?.validate() != true) {
      return;
    }
    if (viewModel.updatableTaskModel == null) {
      return;
    }
    final taskRepo = locator<TasksRepo>();
    appLoadingCallback(taskRepo.updateTask(todo: viewModel.updatableTaskModel!),
            cancelToken: taskRepo.cancelToken)
        .then((value) {
      value.fold((l) => {showError(l)}, (r) {
        _success(r);
      });
    });
  }

  void _success(r) {
    BotToast.showText(
        text: viewModel.updatableTaskModel == null
            ? "Task has been added successfully"
            : "Task has been updated successfully");
    navigationService.back(result: r);
  }
}
