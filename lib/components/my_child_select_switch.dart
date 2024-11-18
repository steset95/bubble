import 'dart:async';
import 'package:flutter/material.dart';
import '../database/firestore_child.dart';

class ChildSelectSwitch extends StatefulWidget {

  final String sectionName;
  final String childcode;
  var color;
  bool active;






  ChildSelectSwitch({
    super.key,

    required this.sectionName,
    required this.color,
    required this.childcode,
    required this.active,
  });

  @override
  State<ChildSelectSwitch> createState() => _ChildSelectSwitchState();
}

class _ChildSelectSwitchState extends State<ChildSelectSwitch> {
  bool isSwitchedfalse  = false;

  bool isSwitchedtrue  = true;

  bool isSwitched  = false;

  Future <void> updateSwitch (String childcode, bool isSwitched) async {
    final FirestoreDatabaseChild firestoreDatabaseChild = FirestoreDatabaseChild();
    if (isSwitched == true) {
      firestoreDatabaseChild.updateSwitch(
        childcode, true);

    }
    else  {
      firestoreDatabaseChild.updateSwitch(
          childcode, false);


    }
  }

  @override
  Widget build(BuildContext context) {
    return  StatefulBuilder
        (builder: (context, setState)
    {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.sectionName,
                style: TextStyle(
                  color: widget.color,
              ),
              ),



              Column(
                children: [
                  if (widget.active == true)
                    Switch (
                      value: isSwitchedtrue,
                      onChanged: (value) async {
                        await updateSwitch(widget.childcode, value);

                        isSwitched = value;
                        setState(()  {});
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                  if (widget.active == false)
                    Switch(
                      value: isSwitchedfalse,
                      onChanged: (value) async {
                        await updateSwitch(widget.childcode, value);

                        isSwitched = value;
                        setState(()  {});
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),

                ],
              )
            ],
          ),
          /*
          Text(widget.text,
            style: TextStyle(color: Colors.black,
              fontSize: 12,
            ),
          ),
          */
        ],
      );
    }
    );
  }
}


