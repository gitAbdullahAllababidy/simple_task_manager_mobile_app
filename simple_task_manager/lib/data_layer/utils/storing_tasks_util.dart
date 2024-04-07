import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_task_manager/data_layer/models/res/tasks/todo_response_model.dart';

class StoringTasksUtil {
  late Isar isar;
  final _storedTasksIds = <Id>[];
  initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [TodoResponseModelSchema],
      directory: dir.path,
    );
  }

  Future dispose() async {
    await isar.close();
  }

  Future pullAllTasks(List<TodoResponseModel> tasks) async {
    try {
      if (tasks.isNotEmpty) {
        _storedTasksIds.addAll(
            await isar.writeTxn(() => isar.todoResponseModels.putAll(tasks)));
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<TodoResponseModel>> getAllTasks() async {
    var allTasks = <TodoResponseModel>[];
    try {
      allTasks = await isar.todoResponseModels.where().findAll();
      return allTasks;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return allTasks;
    }
  }

  Future<bool> deleteTask(Id taskId) async {
    try {
      return isar
          .writeTxn(() async => await isar.todoResponseModels.delete(taskId));
    } on Exception catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
