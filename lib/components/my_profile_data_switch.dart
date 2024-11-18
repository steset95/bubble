import 'dart:async';
import 'package:flutter/material.dart';
import '../database/firestore_child.dart';

class ProfileDataSwitch extends StatefulWidget {
  final String text;
  final String sectionName;
  final String field;
  final String childcode;




 const ProfileDataSwitch({
    super.key,
    required this.text,
    required this.sectionName,
    required this.field,
    required this.childcode,
  });






  @override
  State<ProfileDataSwitch> createState() => _ProfileDataSwitchState();
}

class _ProfileDataSwitchState extends State<ProfileDataSwitch> {

bool isSwitchedfalse  = false;
bool isSwitchedtrue  = true;
bool isSwitched  = false;




Future <void> updateEinwilligungen (String childcode, bool isSwitched, String field) async {
    final FirestoreDatabaseChild firestoreDatabaseChild = FirestoreDatabaseChild();
      if (isSwitched == true) {
        firestoreDatabaseChild.updateChildEinwilligungen(
          childcode, field, "erlaubt",);
      }
      else {
        firestoreDatabaseChild.updateChildEinwilligungen(
          childcode, field, "nicht erlaubt",);
      }
  }





  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    return  StatefulBuilder
        (builder: (context, setState)
    {
      return Container(
        width: mediaQuery.size.width * 1,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
      BoxShadow(
      color: Colors.black.withOpacity(0.5),
      spreadRadius: 1,
      blurRadius: 3,
      offset: Offset(2, 4),
      ),
      ],
      ),
        padding: const EdgeInsets.only(left: 15, right: 5),
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(widget.sectionName,
                    style: TextStyle(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .primary,),
                  ),
                ),
                Column(
                  children: [
                      if (widget.text == "erlaubt")
                    Switch (
                        value: isSwitchedtrue,
                        onChanged: (value) async {
                          await updateEinwilligungen(widget.childcode, value, widget.field);

                          isSwitched = value;
                          setState(()  {});
                        },
                        activeColor: Colors.green,
                    ),
                    if (widget.text == "nicht erlaubt")
                      Switch(
                          value: isSwitchedfalse,
                          onChanged: (value) async {
                            await updateEinwilligungen(widget.childcode, value, widget.field);

                            isSwitched = value;
                            setState(()  {});
                          },
                        activeColor: Colors.green,
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


