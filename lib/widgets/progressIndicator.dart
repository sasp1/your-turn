import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatefulWidget {
  final Function onTurnChanged;
  final bool active;
  final _CustomProgressIndicatorState state =
      new _CustomProgressIndicatorState();
  final bool reset;

  static of(BuildContext context, {bool root = false}) => root
      ? context.findRootAncestorStateOfType<_CustomProgressIndicatorState>()
      : context.findAncestorStateOfType<_CustomProgressIndicatorState>();

  // Here I am receiving the function in constructor as params
  CustomProgressIndicator(this.onTurnChanged, this.active, this.reset);

  @override
  _CustomProgressIndicatorState createState() => state;

}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  bool active = false;

  @override
  void didUpdateWidget(covariant CustomProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.reset) {
      controller.reset();
      controller.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 5000), vsync: this);

    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });

    // widget.onTurnChanged();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
        widget.onTurnChanged();
        controller.forward();
      }
    });

    controller.forward();
    // controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
      child: LinearProgressIndicator(
        value: animation.value,
        valueColor: widget.active
            ? new AlwaysStoppedAnimation<Color>(Colors.red)
            : new AlwaysStoppedAnimation<Color>(Colors.blue),
        backgroundColor: widget.active ? Colors.red[100] : Colors.blue[100],
      ),
    ));
  }
}
