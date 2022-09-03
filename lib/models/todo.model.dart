/// ClientModel.dart
import 'dart:convert';

Todo todoFromJson(String str) {
  final jsonData = json.decode(str);
  return Todo.fromMap(jsonData);
}

String todoToJson(Todo data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Todo {
  int id;
  String firstName;
  String lastName;
  bool blocked;

  Todo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.blocked,
  });

  factory Todo.fromMap(Map<String, dynamic> json) => new Todo(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    blocked: json["blocked"] == 1,
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "blocked": blocked,
  };
}