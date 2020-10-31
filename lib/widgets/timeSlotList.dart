import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:your_turn/models/timeSlot.dart';
import 'package:your_turn/models/user.dart';

class TimeSlotList extends StatelessWidget {
  final List<TimeSlot> timeSlots;
  final List<User> users;
  final bool active;
  final int highlighted;
  final Function(int itemChosen) onItemChosen;

  const TimeSlotList(this.timeSlots, this.users, this.active, this.highlighted,
      this.onItemChosen,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
        children: timeSlots
            .asMap()
            .map((i, e) => MapEntry(
                i,
                Container(
                  height: 50,
                  color: highlighted == i && active
                      ? Colors.red[100]
                      : highlighted == i
                          ? Colors.blue[100]
                          : Colors.white,
                  child: ListTile(
                    title: Center(
                      child: Text(
                          users.firstWhere((user) => user.id == e.userId).name),
                    ),
                    onTap: () {
                      onItemChosen(i);
                    },
                  ),
                )))
            .values
            .toList());
  }
}
