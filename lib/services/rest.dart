import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:your_turn/models/timeSlot.dart';
import '../models/user.dart';

class RestService {
  final String baseUrl = "http://10.3.24.105:8082/api-dev/";
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  void login(String jwt) {
    print("hey");
  }

  Future<String> signUp(String name) async {
    String url = baseUrl + "users";
    String body = jsonEncode({"name": name});

    var response = await http.post(url, headers: headers, body: body);

    return "hey";
  }

  Future<List<User>> getMembers() async {
    String url = baseUrl + "users";
    var response = await http.get(url);
    return User.decodeUsers(response.body);
  }

  Future<List<TimeSlot>> getTimeSlots() async {
    String url = baseUrl + "timeSlots";
    var response = await http.get(url);

    return TimeSlot.decodeTimeSlots(response.body);
  }
}
