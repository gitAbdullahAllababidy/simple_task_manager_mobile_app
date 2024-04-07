import 'package:simple_task_manager/data_layer/models/res/tasks/todo_response_model.dart';

class TasksResponseWrapperModel {
  int? total;

  List<TodoResponseModel>? todos;

  TasksResponseWrapperModel({
    this.total,
    this.todos,
  });

  factory TasksResponseWrapperModel.fromMap(Map<String, dynamic> data) {
    return TasksResponseWrapperModel(
      total: data['total'] as int?,
      todos: (data['todos'] as List<dynamic>?)
          ?.map((e) =>
              TodoResponseModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
