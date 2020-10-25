import 'package:flutter/material.dart';
import 'package:your_turn/chooseNameDialog.dart';
import 'package:your_turn/sharedPrefsHelper.dart';
import 'package:your_turn/progressIndicator.dart';
import 'package:your_turn/splashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      home: MyHomePage(
        title: "Hola amigos",
      ),
      routes: {
        "home": (_) => MyHomePage(
              title: "Hola amigos",
            )
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> members = [
    "Seb",
    "Naja",
    "Simoneren",
    // "Hannah",
    // "Rasmus",
    // "Frederik",
    // "Høst",
    // "Amalie",
    // "Ida",
    // "Rune",
    // "Anton",
  ];
  int active = 0;
  int chosenName = -1;
  bool turnActive = false;
  bool _reset = false;
  SharedPrefsHelper _sharedPrefsHelper;

  @override
  void initState() {
    super.initState();
    _sharedPrefsHelper = SharedPrefsHelper();
  }

  void updateTurn() {
    setState(() {
      active = (active + 1) % members.length;
      turnActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    CustomProgressIndicator indicator =
        new CustomProgressIndicator(updateTurn, turnActive, _reset);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(chosenName == -1 ? widget.title : members[chosenName]),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => ChooseNameDialog((index) {
                      setState(() {
                        chosenName = index;
                      });
                    }, members),
                  );
                },
                child: Icon(
                  Icons.settings,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Center(
        child: ListView(
            children: members
                .asMap()
                .map((i, e) => MapEntry(
                    i,
                    Container(
                      height: 50,
                      color: active == i && turnActive
                          ? Colors.red[100]
                          : active == i
                              ? Colors.blue[100]
                              : Colors.white,
                      child: Center(
                        child: Text(e),
                      ),
                    )))
                .values
                .toList()),
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
                                  active = (active + 1) % members.length;
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
