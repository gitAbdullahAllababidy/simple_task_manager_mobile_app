import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:simple_task_manager/application_layer/core/core.locator.dart';
import 'package:simple_task_manager/data_layer/repositories/tasks_repo.dart';
import 'package:simple_task_manager/presentation_layer/abstractions/view_model_abstraction.dart';
import 'package:simple_task_manager/presentation_layer/utils/loading_utils.dart';
import 'package:simple_task_manager/presentation_layer/views/home/home_view_model.dart';

class DeleteTaskDelegate extends ViewModelAbstraction<HomeViewModel> {
  DeleteTaskDelegate({required super.viewModel});

  ///Add new
  Future deleteTask(int taskId, {VoidCallback? whenDeletedCallback}) async {
    final taskRepo = locator<TasksRepo>();
    return appLoadingCallback(taskRepo.deleteTask(taskId: taskId),
            cancelToken: taskRepo.cancelToken)
        .then((value) {
      value.fold((l) => {showError(l)}, (r) {
        whenDeletedCallback?.call();
        _success(r);
      });
    });
  }

  void _success(r) {
    BotToast.showText(text: "Task has been removed successfully");
  }
}
