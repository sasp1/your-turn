import 'package:flutter/material.dart';
import 'package:your_turn/dialogs/chooseNameDialog.dart';
import 'package:your_turn/services/sharedPrefsHelper.dart';
import 'package:your_turn/widgets/mainAppBar.dart';
import 'package:your_turn/widgets/progressIndicator.dart';
import 'package:your_turn/widgets/userList.dart';
import 'screens/chooseNameScreen.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPrefsHelper sharedPrefs = SharedPrefsHelper();

  String userId = await sharedPrefs.getUserId();

  runApp(MyApp(userId));
}

class MyApp extends StatelessWidget {
  final String userId;

  MyApp(this.userId);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Turn',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:
      // userId == null
      //     ? MyHomePage(
      //         title: "Hola amigos",
      //       )
      //     :
      ChooseNameScreen(),
      routes: {
        "chooseName": (_) => ChooseNameScreen(),
        "home": (_) => MyHomePage(
              title: "Hola amigos",
            )
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String userId;
  final String title;

  MyHomePage({Key key, this.title, this.userId}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String userId;
  int active = 0;
  int chosenName = -1;
  bool turnActive = false;
  bool _reset = false;
  SharedPrefsHelper _sharedPrefsHelper;
  List<User> users;

  @override
  void initState() {
    super.initState();
    _sharedPrefsHelper = SharedPrefsHelper();
    userId = widget.userId;
    loadTimeSlots();
  }

  void loadTimeSlots() async {
    var loadedUsers = await _sharedPrefsHelper.getUsers();
    var userId = await _sharedPrefsHelper.getUserId();
    // var timeSlots = await _sharedPrefsHelper.getTimeSlots();


    setState(() {
      users = loadedUsers;
      chosenName = loadedUsers.indexWhere((user) => user.id == userId);
    });


  }

  void updateTurn() {
    setState(() {
      active = (active + 1) % users.length;
      turnActive = false;
    });
  }

  void onNameUpdated(chosenNameIdx){
    setState(() {
      chosenName = chosenNameIdx;
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomProgressIndicator indicator =
        new CustomProgressIndicator(updateTurn, turnActive, _reset);

    return Scaffold(
      appBar: MainAppBar(chosenName == -1 ? widget.title : users[chosenName].name, users, onNameUpdated),
      body: Center(
        child: UserList(users, turnActive, active, (_) {}),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Container(
            height: chosenName == active ? 55 : 4,
            child: Column(
                children: chosenName == active
                    ? [
                        Container(
                          child: indicator,
                        ),
                        Container(
                          height: 50,
                          child: FlatButton(
                            textColor: turnActive ? Colors.red : Colors.blue,
                            child: Text(turnActive
                                ? "End your turn"
                                : 'Start your turn'),
                            onPressed: () {
                              setState(() {
                                turnActive = !turnActive;
                                if (!turnActive) {
                                  _reset = true;
                                  active = (active + 1) % users.length;
                                } else {
                                  _reset = false;
                                }
                              });
                            },
                          ),
                        ),
                      ]
                    : [
                        Container(
                          child: indicator,
                        )
                      ]),
          )),
    );
  }
}
