import 'package:dartz/dartz.dart';
import 'package:simple_task_manager/application_layer/utils/user_authectication_util.dart';
import 'package:simple_task_manager/data_layer/abstractions/repo_mixin.dart';
import 'package:simple_task_manager/data_layer/apis/apis.dart';
import 'package:simple_task_manager/data_layer/models/res/tasks/todo_response_model.dart';
import 'package:simple_task_manager/data_layer/models/users/tasks_response_wrapper_model.dart';
import 'package:simple_task_manager/global/global_locators.dart';
import 'package:simple_task_manager/global/types.dart';

class TasksRepo with RepoMixin {
  ///
  ///Load all tasks
  Future<AppResponseType<TasksResponseWrapperModel>> loadAllTasks(
      {int skip = 0, int limit = 5}) async {
    if (userId is! String) {
      await UserAuthenticationUtil.getUserId()
          .then((value) => value.fold((l) => null, (r) => userId = r));
    }
    return await networkService
        .getRequest<Map<String, dynamic>>(Apis.todosByUser(userId!),
            queryParameters: {"skip": skip, "limit": limit},
            cancelToken: cancelToken)
        .then((value) => value.fold((l) async {
              return left(await storingTasksUtil.getAllTasks());
            }, (r) async {
              var model = TasksResponseWrapperModel.fromMap(r ?? {});
              await storingTasksUtil.pullAllTasks(model.todos ?? []);
              return Right(model);
            }));
  }

  ///create new task
  Future<AppResponseType<TasksResponseWrapperModel>> createNewTask(
      {required TodoResponseModel todo}) async {
 
    return await networkService
        .postRequest<Map<String, dynamic>>(Apis.todosBy("add"),
            data: todo.toMap(),
            cancelToken: cancelToken)
        .then((value) => value.fold((l) async {
              return left(l);
            }, (r) async {
              var model = TasksResponseWrapperModel.fromMap(r ?? {});
              return Right(model);
            }));
  }

  ///Update task
  Future<AppResponseType<TasksResponseWrapperModel>> updateTask(
      {required TodoResponseModel todo}) async {
    return await networkService
        .patchRequest<Map<String, dynamic>>(Apis.todosBy(todo.id.toString()),
            data: todo.toMap(), cancelToken: cancelToken)
        .then((value) => value.fold((l) async {
              return left(l);
            }, (r) async {
              var model = TasksResponseWrapperModel.fromMap(r ?? {});

              return Right(model);
            }));
  }

  ///Update task
  Future<AppResponseType<TasksResponseWrapperModel>> deleteTask({
    required int taskId,
  }) async {
    return await networkService
        .deleteRequest<Map<String, dynamic>>(Apis.todosBy(taskId.toString()),
            cancelToken: cancelToken)
        .then((value) => value.fold((l) async {
              return left(l);
            }, (r) async {
              var model = TasksResponseWrapperModel.fromMap(r ?? {});
              storingTasksUtil.deleteTask(taskId);
              return Right(model);
            }));
  }
}
