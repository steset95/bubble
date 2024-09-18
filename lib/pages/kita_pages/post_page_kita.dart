import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bubble/components/my_list_tile_feed_kita.dart';
import 'package:bubble/database/firestore_feed.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

import '../../helper/notification_controller.dart';
import '../../helper/helper_functions.dart';


class PostPageKita extends StatefulWidget {
  final bool externPost;
  final String umgebung;

  PostPageKita({
    super.key,
    required this.externPost,
    required this.umgebung,
  });


  @override
  State<PostPageKita> createState() => _PostPageKitaState();
}

class _PostPageKitaState extends State<PostPageKita> {


  // Zugriff auf Firestore Datenbank
  final FirestoreDatabaseFeed database = FirestoreDatabaseFeed();


  // Text Controller
  final TextEditingController newPostControllerTitel = TextEditingController();
  final TextEditingController newPostControllerInhalt = TextEditingController();




  // Methode: Nachricht Posten Extern
  void postMessageExt(){
    // Nur Posten wenn etwas im Textfeld ist
    if (newPostControllerInhalt.text.isNotEmpty){
      String title = newPostControllerTitel.text;
      String content = newPostControllerInhalt.text;
      database.addPostExt(title, content);
    }
    // Eingabefeld nach Eingabe leeren
    newPostControllerInhalt.clear();
    newPostControllerTitel.clear();
  }


  // Methode: Nachricht Posten Intern
  void postMessageInt(){
    // Nur Posten wenn etwas im Textfeld ist
    if (newPostControllerInhalt.text.isNotEmpty){
      String title = newPostControllerTitel.text;
      String content = newPostControllerInhalt.text;
      database.addPostInt(title, content);
    }
    // Eingabefeld nach Eingabe leeren
    newPostControllerInhalt.clear();
    newPostControllerTitel.clear();
  }




  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final umgebung = widget.umgebung;
    return Scaffold(
    appBar: AppBar(
      scrolledUnderElevation: 0.0,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      title:
      Text(umgebung,
        style: TextStyle(fontSize: 20,),
      ),
    ),

      body:
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              TextField(
                contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
                  // If supported, show the system context menu.
                  if (SystemContextMenu.isSupported(context)) {
                    return SystemContextMenu.editableText(
                      editableTextState: editableTextState,
                    );
                  }
                  // Otherwise, show the flutter-rendered context menu for the current
                  // platform.
                  return AdaptiveTextSelectionToolbar.editableText(
                    editableTextState: editableTextState,
                  );
                },
                maxLength: 50,
                //autofocus: true,
                controller: newPostControllerTitel,
                textAlign: TextAlign.left,
                decoration: InputDecoration(hintText: "Nadpis...",
                ),


              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  HugeIcon(icon: HugeIcons.strokeRoundedRocket, color: Colors.deepPurpleAccent, size: 15),
                  HugeIcon(icon: HugeIcons.strokeRoundedToyTrain, color: Colors.orange, size: 15),
                  HugeIcon(icon: HugeIcons.strokeRoundedLollipop, color: Colors.red, size: 15),
                  HugeIcon(icon: HugeIcons.strokeRoundedFootball, color: Colors.teal, size: 15),
                  HugeIcon(icon: HugeIcons.strokeRoundedAirplane01, color: Colors.lightBlueAccent, size: 15),
                  HugeIcon(icon: HugeIcons.strokeRoundedMusicNote03, color: Colors.black, size: 15),
                  HugeIcon(icon: HugeIcons.strokeRoundedHotdog, color: Colors.redAccent, size: 15),
                  HugeIcon(icon: HugeIcons.strokeRoundedTree02, color: Colors.green, size: 15),

                ],
              ),
              const SizedBox(height: 5),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black),
                  ),
                  //height: mediaQuery.size.width * 0.9,
                  padding: EdgeInsets.all(10),
                  child:  TextField(
                    contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
                      // If supported, show the system context menu.
                      if (SystemContextMenu.isSupported(context)) {
                        return SystemContextMenu.editableText(
                          editableTextState: editableTextState,
                        );
                      }
                      // Otherwise, show the flutter-rendered context menu for the current
                      // platform.
                      return AdaptiveTextSelectionToolbar.editableText(
                        editableTextState: editableTextState,
                      );
                    },
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 20,
                    maxLength: 5000,
                    controller: newPostControllerInhalt,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Text...",
                      counterText: "",

                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      // Textfeld Zatvoriť
                      Navigator.pop(context);
                      //Textfeld leeren
                      newPostControllerTitel.clear();
                      newPostControllerInhalt.clear();
                    },
                    child: Text("Zrušiť"),
                  ),
                  TextButton(
                    onPressed: () {
                      if (newPostControllerInhalt.text.isNotEmpty  && newPostControllerTitel.text.isNotEmpty) {
                        if (widget.externPost) {
                          // Raport hinzufügen
                          postMessageExt();
                        }
                        else{
                          postMessageInt();
                          // Textfeld Zatvoriť
                        }
                        Navigator.pop(context);
                        //Textfeld leeren
                        newPostControllerTitel.clear();
                        newPostControllerInhalt.clear();
                      }
                      else {
                        return displayMessageToUser("Prosím zadajte názov a obsah", context);
                      }
                    },
                    child: Text("Uložiť"),
                  ),
                ],
              ),

              // save Button

            ],
          ),
        ),
    );
  }
}