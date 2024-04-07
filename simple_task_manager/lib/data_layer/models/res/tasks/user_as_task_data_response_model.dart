import 'dart:convert';

import 'package:isar/isar.dart';
part 'user_as_task_data_response_model.g.dart';

@collection
class UserAsTaskDataResponseModel {
  Id? id;
  String? email;
  String? firstName;
  String? lastName;
  String? avatar;

  UserAsTaskDataResponseModel({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.avatar,
  });

  factory UserAsTaskDataResponseModel.fromMap(Map<String, dynamic> data) {
    return UserAsTaskDataResponseModel(
      id: data['id'] as int?,
      email: data['email'] as String?,
      firstName: data['first_name'] as String?,
      lastName: data['last_name'] as String?,
      avatar: data['avatar'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'avatar': avatar,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserAsTaskDataResponseModel].
  factory UserAsTaskDataResponseModel.fromJson(String data) {
    return UserAsTaskDataResponseModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserAsTaskDataResponseModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
