import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:your_turn/dialogs/chooseNameDialog.dart';
import 'package:your_turn/models/user.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final Function(int chosenNameIdx) onNameChosen;
  final List<User> users;

  @override
  final Size preferredSize;

  MainAppBar(this.title, this.users, this.onNameChosen, {Key key})
      : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      centerTitle: true,
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Text(title),
      actions: [
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => ChooseNameDialog(
                    onNameChosen,
                    users.map((e) => e.name).toList(),
                  ),
                );
              },
              child: Icon(
                Icons.settings,
                size: 26.0,
              ),
            )),
      ],
    );
  }

}
