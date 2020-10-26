import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChooseNameDialog extends StatefulWidget {
  final List<String> members;
  final Function(int) onNameChosen;

  ChooseNameDialog(this.onNameChosen, this.members);

  @override
  State<StatefulWidget> createState() => _ChooseNameState();
}

class _ChooseNameState extends State<ChooseNameDialog> {
  int chosenName = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FToast fToast = FToast();
    fToast.init(context);

    // TODO: implement build
    return new AlertDialog(
      title: Text("Select your name"),
      content: Container(
        height: 550.0, // Change as per your requirement
        width: 300.0, // Change as per your requirement
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.members.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              onTap: () {
                setState(() {
                  chosenName = index;
                });
              },
              title: Text(widget.members[index]),
              selectedTileColor: Colors.blue[100],
              selected: index == chosenName,
            );
          },
        ),
      ),
      actions: [
        TextButton(
          child: Text('Confirm'),
          onPressed: () {
            if (chosenName > -1) {
              widget.onNameChosen(chosenName);
              Navigator.of(context).pop();
            } else {
              fToast.showToast(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.blue[100],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 12.0,
                      ),
                      Text("Please select your name"),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
