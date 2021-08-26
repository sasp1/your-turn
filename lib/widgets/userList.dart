import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:your_turn/models/user.dart';
import 'package:provider/provider.dart';
import 'package:your_turn/viewmodels/user_model.dart';

class UserList extends StatelessWidget {
  final List<User> users;
  final bool active;
  final int highlighted;
  final Function(int itemChosen) onItemChosen;

  const UserList(this.users, this.active, this.highlighted, this.onItemChosen,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return ListView(
        children: users
            .asMap()
            .map((i, e) => MapEntry(
                i,
                Container(
                  height: 50,
                  color:
                      highlighted == context.watch<UserModel>().selectedUser &&
                              active
                          ? Colors.red[100]
                          : highlighted == i
                              ? Colors.blue[100]
                              : Colors.white,
                  child: ListTile(
                    title: Center(
                      child: Text(e.name),
                    ),
                    onTap: () => context.read<UserModel>().selectUser(i),
                  ),
                )))
            .values
            .toList());
  }
}
