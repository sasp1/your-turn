import 'package:flutter/material.dart';
import 'package:your_turn/services/rest.dart';
import 'package:your_turn/services/sharedPrefsHelper.dart';
import 'package:your_turn/widgets/userList.dart';

import '../models/user.dart';

class ChooseNameScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChooseNameState();
}

class ChooseNameState extends State<ChooseNameScreen> {
  SharedPrefsHelper _sharedPrefsHelper = SharedPrefsHelper();
  RestService _restService = RestService();
  int _active = -1;
  Future<List<User>> members;

  Future<List<User>> _getMembers() async {
    return _restService.getMembers();
  }

  void onNameChosen(int active) {
    setState(() {
      _active = active;
    });
  }

  @override
  void initState() {
    super.initState();
    members = _getMembers();
  }

  void completeUserSetup() async {
    var users = await members;

    await _sharedPrefsHelper.setUserId(users[_active].id);

    await _sharedPrefsHelper.setUsers(users);


    Navigator.of(context).pushReplacementNamed("home");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(builder: (BuildContext context) {
        return FloatingActionButton(
          onPressed: () {
            if (_active == -1) {
              final snackBar = SnackBar(
                content: Text('Please select your name'),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            } else {
              completeUserSetup();
            }
            // Respond to button press
          },
          child: Icon(Icons.check),
        );
      }),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Select your name :)"),
      ),
      body: Center(
        child: FutureBuilder<List<User>>(
          future: members,
          initialData: [],
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
            List<Widget> children;
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return UserList(snapshot.data, false, _active, onNameChosen);

            } else if (snapshot.hasError) {
              children = <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ];
            } else {
              children = <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                )
              ];
              // print(snapshot.data);

            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            );
          },
        ),
      ),
    );
  }
}

class MembersList extends StatelessWidget {
  final List<User> members;
  final Function(int active) onNameChosen;
  final int active;

  const MembersList(this.members, this.onNameChosen, this.active, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: members
            .asMap()
            .map((i, e) => MapEntry(
                i,
                Container(
                  height: 50,
                  color: active == i ? Colors.blue[100] : Colors.white,
                  child: ListTile(
                    title: Center(
                      child: Text(e.name),
                    ),
                    onTap: () {
                      onNameChosen(i);
                    },
                  ),
                )))
            .values
            .toList());
  }
}
