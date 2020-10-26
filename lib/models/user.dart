import 'dart:convert';

class User {
  User(this.name, this.id);

  final String name;
  final String id;

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['_id'];

  Map<String, dynamic> toJson() => {
        'name': name,
        '_id': id,
      };

  static List<User> decodeUsers(String users) => (json.decode(users) as List<dynamic>)
      .map<User>((item) => User.fromJson(item))
      .toList();

  static String encodeUsers(List<User> users) => json.encode(
        users.map<Map<String, dynamic>>((user) => user.toJson()).toList(),
      );


}
