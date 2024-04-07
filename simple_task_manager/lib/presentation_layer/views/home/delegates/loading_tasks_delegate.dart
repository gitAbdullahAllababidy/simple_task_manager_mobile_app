import 'package:simple_task_manager/application_layer/core/core.locator.dart';
import 'package:simple_task_manager/data_layer/models/res/tasks/todo_response_model.dart';
import 'package:simple_task_manager/data_layer/models/users/tasks_response_wrapper_model.dart';
import 'package:simple_task_manager/data_layer/repositories/tasks_repo.dart';
import 'package:simple_task_manager/presentation_layer/abstractions/view_model_abstraction.dart';
import 'package:simple_task_manager/presentation_layer/utils/loading_utils.dart';
import 'package:simple_task_manager/presentation_layer/views/home/home_view_model.dart';

final class LoadingTasksDelegate extends ViewModelAbstraction<HomeViewModel> {
  LoadingTasksDelegate({required super.viewModel});
  loadingAllTasks() {
    final tasksRepo = locator<TasksRepo>();
    appLoadingCallback(tasksRepo.loadAllTasks(),
            cancelToken: tasksRepo.cancelToken)
        .then((value) {
      value.fold((l) => {}, (r) {
        success(r);
      });
    });
  }

  void success(TasksResponseWrapperModel r) {
    var loadedTasks = r.todos;
    tasks.addAll(loadedTasks ?? []);
    viewModel.rebuildUi();
  }

  List<TodoResponseModel> tasks = [];
}
