import 'dart:convert';

import 'package:your_turn/models/user.dart';

class TimeSlot {
  TimeSlot(this.userId, this.timeStart, this.timeEnd);

  final String userId;
  final int timeStart;
  final int timeEnd;

  TimeSlot.fromJson(Map<String, dynamic> json)
      : userId = json['user'],
        timeStart = json['timeStart'],
        timeEnd = json['timeEnd'];

  Map<String, dynamic> toJson() => {
        'user': userId,
        'timeStart': timeStart,
        'timeEnd': timeEnd,
      };

  static List<TimeSlot> decodeTimeSlots(String timeSlots) =>
      (json.decode(timeSlots) as List<dynamic>)
          .map<TimeSlot>((item) => TimeSlot.fromJson(item))
          .toList();

  static String encodeTimeSlots(List<TimeSlot> timeSlots) => json.encode(
        timeSlots
            .map<Map<String, dynamic>>((timeSlot) => timeSlot.toJson())
            .toList(),
      );
}
