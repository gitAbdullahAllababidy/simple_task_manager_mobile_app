import 'dart:convert';

class AuthResponseModel {
	final int? id;
	final String? token;

	const AuthResponseModel({this.id, this.token});

	@override
	String toString() => 'AuthResponseModel(id: $id, token: $token)';

	factory AuthResponseModel.fromMap(Map<String, dynamic> data) {
		return AuthResponseModel(
			id: data['id'] as int?,
			token: data['token'] as String?,
		);
	}



	Map<String, dynamic> toMap() => {
				'id': id,
				'token': token,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AuthResponseModel].
	factory AuthResponseModel.fromJson(String data) {
		return AuthResponseModel.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [AuthResponseModel] to a JSON string.
	String toJson() => json.encode(toMap());
}
