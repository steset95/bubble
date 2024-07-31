/*import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../database/firestore_child.dart';

class ChildSelectSwitchAll extends StatefulWidget {

  final String group;






  ChildSelectSwitchAll({
    super.key,

    required this.group,

  });






  @override
  State<ChildSelectSwitchAll> createState() => _ChildSelectSwitchAllState();
}

class _ChildSelectSwitchAllState extends State<ChildSelectSwitchAll> {


  bool isSwitchedfalse  = false;
  bool isSwitchedtrue  = true;
  bool isSwitched  = true;



  Future <void> updateSwitch (String group) async {
    final FirestoreDatabaseChild firestoreDatabaseChild = FirestoreDatabaseChild();
    if (isSwitched == true) {
      firestoreDatabaseChild.updateSwitchAllOn(group
        );

    }
    else  {
      firestoreDatabaseChild.updateSwitchAllOff(group
          );


    }
  }







  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    return  StatefulBuilder
        (builder: (context, setState)
    {
      return new Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Alle auswählen",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                ),
                ),



                Column(
                  children: [
                    if (isSwitched == true)
                      Switch (
                        value: isSwitchedtrue,
                        onChanged: (value) async {
                          await updateSwitch(widget.group);

                          isSwitched = value;
                          setState(()  {});
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                    if (isSwitched == false)
                      Switch(
                        value: isSwitchedfalse,
                        onChanged: (value) async {
                          await updateSwitch(widget.group);

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
        ),
      );
    }
    );
  }



  }


*/