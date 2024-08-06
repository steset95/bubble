import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/components/my_list_tile_feed_kita.dart';
import 'package:socialmediaapp/database/firestore_feed.dart';
import 'package:intl/intl.dart';

import '../../components/notification_controller.dart';
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


  /// Notification
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => NotificationController().notificationCheck());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  /// Notification


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
    return SafeArea(
      child: Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title:
        Text('Neuer Post $umgebung',
        ),
      ),

        body:
          Padding(
            padding: EdgeInsets.all(10),

            child: Column(

              children: [
                const SizedBox(height: 10,),
                Flexible(
                  flex: 1,
                  child: TextField(
                    maxLength: 30,
                    //autofocus: true,
                    controller: newPostControllerTitel,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(hintText: "Titel...",

                    ),


                  ),
                ),
                const SizedBox(height: 20,),
                Flexible(
                  flex: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black),
                      boxShadow: const [
                      ],
                    ),

                    padding: EdgeInsets.all(10),
                    child:  TextField(

                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 20,
                      maxLength: 300,
                      controller: newPostControllerInhalt,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Inhalt...",
                        counterText: "",

                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Textfeld schliessen
                          Navigator.pop(context);
                          //Textfeld leeren
                          newPostControllerTitel.clear();
                          newPostControllerInhalt.clear();
                        },
                        child: Text("Abbrechen"),
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
                              // Textfeld schliessen
                            }
                            Navigator.pop(context);
                            //Textfeld leeren
                            newPostControllerTitel.clear();
                            newPostControllerInhalt.clear();
                          }
                          else {
                            return displayMessageToUser("Bitte Titel und Inhalt eingeben", context);
                          }
                        },
                        child: Text("Speichern"),
                      ),
                    ],
                  ),
                ),

                // save Button

              ],
            ),
          ),
      ),
    );
  }
}