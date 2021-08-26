import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_turn/models/timeSlot.dart';
import 'package:your_turn/services/rest.dart';
import 'package:your_turn/services/sharedPrefsHelper.dart';
import 'package:your_turn/viewmodels/user_model.dart';
import 'package:your_turn/widgets/mainAppBar.dart';
import 'package:your_turn/widgets/progressIndicator.dart';
import 'package:your_turn/widgets/timeSlotList.dart';
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
      home: Provider(
        create: (_)  => UserModel(),
        child: userId != null
            ? MyHomePage("Hola amigos", userId)
            : ChooseNameScreen(),
      ),
      routes: {
        "chooseName": (_) => ChooseNameScreen(),
        "home": (_) => MyHomePage("Hola amigos", userId)
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String userId;
  final String title;

  MyHomePage(this.title, this.userId);

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
  String _chosenName;
  int active = 0;
  int chosenNameIdx = -1;
  bool turnActive = false;
  bool _reset = false;
  SharedPrefsHelper _sharedPrefsHelper = SharedPrefsHelper();
  RestService _rest = RestService();
  List<User> _users;
  List<TimeSlot> _timeSlots;
  double startFrom;
  Duration tsDuration;

  @override
  void initState() {
    super.initState();
    _rest = RestService();
    userId = widget.userId;
    loadTimeSlots();
  }

  void loadTimeSlots() async {
    var loadedUsers = await _sharedPrefsHelper.getUsers();
    var userId = await _sharedPrefsHelper.getUserId();
    var timeSlots = await _rest.getTimeSlots();

    timeSlots.sort((a, b) => a.timeStart.compareTo(b.timeStart));

    setState(() {
      _timeSlots = timeSlots;
      _users = loadedUsers;
      chosenNameIdx = _timeSlots.indexWhere((ts) => ts.userId == userId);
      _chosenName =
          loadedUsers.firstWhere((element) => element.id == userId).name;
    });

    updateActiveTimeSlot();
  }

  void updateTurn() {
    setState(() {
      active = (active + 1) % _timeSlots.length;
      turnActive = false;
    });
  }

  void onNameUpdated(index) {
    setState(() {
      chosenNameIdx =
          _timeSlots.indexWhere((ts) => ts.userId == _users[index].id);
      _chosenName = _users[index].name;
    });
  }

  void updateActiveTimeSlot() {
    var now = DateTime.now();
    int secsToday = now.hour * 60 * 60 + now.minute * 60 + now.second;

    var timeSlotIdx = _timeSlots.indexWhere(
        (ts) => secsToday >= ts.timeStart && secsToday < ts.timeEnd);

    if (timeSlotIdx > 0) {
      var ts = _timeSlots[timeSlotIdx];
      int durationSecs = ts.timeEnd - ts.timeStart;

      setState(() {
        startFrom = (secsToday - ts.timeStart).toDouble() / durationSecs;
        tsDuration = Duration(seconds: ts.timeEnd - ts.timeStart);
        active = timeSlotIdx;
      });
    } else {
      timeSlotIdx =
          _timeSlots.indexWhere((element) => secsToday < element.timeEnd);

      if (timeSlotIdx > 0) {
        var ts = _timeSlots[timeSlotIdx];
        startFrom = 0.0;
        tsDuration = Duration(seconds: ts.timeEnd - secsToday);
        active = timeSlotIdx;
      } else {
        setState(() {
          tsDuration = null;
          active = -1;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(_chosenName == null ? widget.title : _chosenName,
          _users, onNameUpdated),
      body: Center(
        child: TimeSlotList(_timeSlots, _users, turnActive, active, (_) {}),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
            height: chosenNameIdx != active && tsDuration != null ? 4 : 55,
            // chosenNameIdx == active ? 55 : 4,
            child: tsDuration == null
                ? Container(
                    child: Center(
                      child: Text("No active time slot"),
                    ),
                  )
                : chosenNameIdx == active
                    ? Column(children: [
                        Container(
                          child: CustomProgressIndicator(updateTurn, turnActive,
                              _reset, startFrom, tsDuration),
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
                                  active = (active + 1) % _timeSlots.length;
                                } else {
                                  _reset = false;
                                }
                              });
                            },
                          ),
                        ),
                      ])
                    : Container(
                        child: CustomProgressIndicator(updateTurn, turnActive,
                            _reset, startFrom, tsDuration),
                      )),
      ),
    );
  }
}
