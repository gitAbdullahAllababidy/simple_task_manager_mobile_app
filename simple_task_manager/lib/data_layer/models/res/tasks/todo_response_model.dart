// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:isar/isar.dart';

part 'todo_response_model.g.dart';

@collection
class TodoResponseModel {
  Id? id;
  String? todo;
  bool? completed;
  int? userId;

  TodoResponseModel({
    this.id,
    this.todo,
    this.completed,
    this.userId,
  });

  factory TodoResponseModel.fromMap(Map<String, dynamic> data) {
    return TodoResponseModel(
      id: data['id'] as int?,
      todo: data['todo'] as String?,
      completed: data['completed'] as bool?,
      userId: data['userId'] as int?,
    );
  }

  Map<String, dynamic> toMap() => {
        'todo': todo,
        'completed': completed,
        'userId' : userId
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TodoResponseModel].
  factory TodoResponseModel.fromJson(String data) {
    return TodoResponseModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TodoResponseModel] to a JSON string.
  String toJson() => json.encode(toMap());

  /// Returns a new [TodoResponseModel] with updated fields.
  TodoResponseModel copyWith({
    Id? id,
    String? todo,
    bool? completed,
    int? userId,
  }) {
    return TodoResponseModel(
      id: id ?? this.id,
      todo: todo ?? this.todo,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
    );
  }
}
