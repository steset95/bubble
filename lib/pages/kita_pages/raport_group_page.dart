import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../components/my_child_select_switch.dart';
import '../../old/my_child_select_switch_all_old.dart';
import '../../components/my_image_upload_button.dart';
import '../../components/my_image_upload_button_multiple.dart';
import '../../components/notification_controller.dart';
import '../../database/firestore_child.dart';




class RaportGroupPage extends StatefulWidget {
  final String group;
  final String name;


  RaportGroupPage({
    super.key,
    required this.group,
    required this.name,


  });

  @override
  State<RaportGroupPage> createState() => _RaportGroupPageState();
}

class _RaportGroupPageState extends State<RaportGroupPage> {

  // Text Controller für Abfrage des Inhalts im Textfeld "Raport hinzufügen"
  final _raportTextController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  final FirestoreDatabaseChild firestoreDatabaseChild = FirestoreDatabaseChild();

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


  // Raport hinzufügen bzw. Allgemeiner Firebase Connect
  void addRaport(String raportTitle, String raportText) {
    String currentDate = DateTime.now().toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    DateTime now = DateTime.now();
    String uhrzeit = DateFormat('kk:mm').format(now);
    // in Firestore speichern und "Raports" unter "Kinder" erstellen
    FirebaseFirestore.instance
        .collection("Kinder")
        .where('group', isEqualTo: widget.group)
        .where("kita", isEqualTo: currentUser?.email)
        .where("absenz", isEqualTo: "nein")
        .where("switch", isEqualTo: true)
        .get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.collection(formattedDate)
            .add({
          "RaportTitle" : raportTitle,
          "RaportText" : raportText,
          'TimeStamp': Timestamp.now(),
          "Uhrzeit": uhrzeit,
        });
      });
    });
    }








// Feld anmledung direkt unter "Kinder" anpassen -> Anmelden
  void anmeldungChild(String field, String value) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .where('group', isEqualTo: widget.group)
        .where("kita", isEqualTo: currentUser?.email)
        .where("absenz", isEqualTo: "nein")
        .where("switch", isEqualTo: true)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc){
        doc.reference
          .update({
        field: value,
    });
    });
        });
        }



  /// Dialog Kinder Auswahl
  //
  //
  void showRaportSelect(String fieldText) async {
    final mediaQuery = MediaQuery.of(context);
    Navigator.pop(context);
     showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(10.0))),
        title: Text("Kinder",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        content: SingleChildScrollView(
          child: Container(
            width: mediaQuery.size.width * 1,
            height: mediaQuery.size.height * 0.65,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Kinder")
                    .where("kita", isEqualTo: currentUser?.email)
                    .where("group", isEqualTo: widget.group)
                    .where("absenz", isEqualTo: "nein")
                    .snapshots(),
                builder: (context, snapshot){
                  // wenn Daten vorhanden _> gib alle Daten aus
                  if (snapshot.hasData) {
                    List childrenList = snapshot.data!.docs;
                    childrenList.sort((a, b) => a['child'].compareTo(b['child']));
                    //als Liste wiedergeben
                    return ListView.builder(
                      padding: EdgeInsets.only(bottom:15),
                      itemCount: childrenList.length,
                      itemBuilder: (context, index) {
                        // individuelle Einträge abholen
                        DocumentSnapshot document = childrenList[index];
                        String docID = document.id;

                        // Eintrag von jedem Dokument abholen
                        Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                        String childText = data['child'];
                        String anmeldungText = data['anmeldung'];
                        bool active = data['switch'];

                        bool istAngemeldet = anmeldungText == "Abgemeldet";

                        var color = istAngemeldet ? Colors.grey : Colors.black;

                        // als List Tile wiedergeben
                        return Container(
                          margin: EdgeInsets.only( right: 10, top: 10),

                          child:
                            ChildSelectSwitch(
                              sectionName: childText,
                              color: color,
                              childcode: docID,
                                active: active,
                            ),


                        );
                      },
                    );
                  }
                  else {
                    return const Text("");
                  }
                }
            ),
          ),

          ),

        actions: [
          // cancel Button
          TextButton(
            onPressed: () => {
     _raportTextController.clear(),
         Navigator.pop(context),
            firestoreDatabaseChild.updateSwitchAllOn(widget.group),
            },

            child: Text("Abbrechen"),
          ),

          // save Button
          TextButton(
            onPressed: () {
              // Raport hinzufügen
              addRaport(fieldText, _raportTextController.text);
              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
              firestoreDatabaseChild.updateSwitchAllOn(widget.group);
            },
            child: Text("Speichern"),
          ),
        ],
      ),
    );
  }

  /// Dialog Kinder Auswahl
  //
  //




  /// Dialog für Anmeldung Hinzufügen anzeiegn
  //
  //
  void showRaportDialogAnmeldung()  {
    Navigator.pop(context);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm').format(now);
    final mediaQuery = MediaQuery.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(10.0))),
        title: Text("Kinder",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        content: SingleChildScrollView(
          child: Container(
            width: mediaQuery.size.width * 1,
            height: mediaQuery.size.height * 0.65,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Kinder")
                    .where("kita", isEqualTo: currentUser?.email)
                    .where("group", isEqualTo: widget.group)
                    .where("absenz", isEqualTo: "nein")
                    .snapshots(),
                builder: (context, snapshot){
                  // wenn Daten vorhanden _> gib alle Daten aus
                  if (snapshot.hasData) {
                    List childrenList = snapshot.data!.docs;
                    childrenList.sort((a, b) => a['child'].compareTo(b['child']));
                    //als Liste wiedergeben
                    return ListView.builder(
                      padding: EdgeInsets.only(bottom:15),
                      itemCount: childrenList.length,
                      itemBuilder: (context, index) {
                        // individuelle Einträge abholen
                        DocumentSnapshot document = childrenList[index];
                        String docID = document.id;

                        // Eintrag von jedem Dokument abholen
                        Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                        String childText = data['child'];
                        String anmeldungText = data['anmeldung'];
                        bool active = data['switch'];

                        bool istAngemeldet = anmeldungText == "Abgemeldet";

                        var color = istAngemeldet ? Colors.grey : Colors.black;

                        // als List Tile wiedergeben
                        return Container(
                          margin: EdgeInsets.only( right: 10, top: 10),

                          child:
                          ChildSelectSwitch(
                            sectionName: childText,
                            color: color,
                            childcode: docID,
                            active: active,
                          ),


                        );
                      },
                    );
                  }
                  else {
                    return const Text("");
                  }
                }
            ),
          ),

        ),

        actions: [
          // cancel Button
          TextButton(
            onPressed: () {
              // Textfeld schliessen
              Navigator.pop(context);
              firestoreDatabaseChild.updateSwitchAllOn(widget.group);
            },
            child: Text("Abbrechen"),
          ),

          // save Button
          TextButton(
            onPressed: () {
              anmeldungChild('anmeldung', 'Anwesend (Seit: $formattedDate)');
              addRaport('Angemeldet', '');
              // Textfeld schliessen
              _raportTextController.clear();
              Navigator.pop(context);
              firestoreDatabaseChild.updateSwitchAllOn(widget.group);
              //Textfeld leeren

            },
            child: Text("Anmelden"),
          ),
        ],
      ),
    );
  }


  // Dialog für Anmeldung Hinzufügen anzeiegn
  //
  //



  /// Dialog für Essen Hinzufügen anzeiegn
  //
  //
  void showRaportDialogEssen()  {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(10.0))),
        title: Text("Essen hinzufügen",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        content: TextField (
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 20,
          maxLength: 150,
          controller: _raportTextController,
          autofocus: true,
          decoration: InputDecoration(hintText: "Essen...",
              counterText: "",
          ),
        ),
         actions: [
          // cancel Button
          TextButton(
            onPressed: () {
              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
          },
            child: Text("Abbrechen"),
          ),

          // save Button
          TextButton(
            onPressed:  () {
    Navigator.pop(context);
    showRaportSelect('Schlaf: ');

            },
              //Textfeld leeren
              child: Text("Weiter"),
          ),
        ],
      ),
    );
  }

  // Dialog für Essen Hinzufügen anzeiegn
  //
  //


  /// Dialog für Schlafen Hinzufügen anzeiegn
  //
  //



  void showRaportDialogSchlaf() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(10.0))),
        title: Text("Schlaf",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        //insetPadding: EdgeInsets.symmetric(horizontal: 100),
        content: TextField (
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 20,
          maxLength: 150,
          controller: _raportTextController,
          autofocus: true,
          decoration: InputDecoration(hintText: "Schlaf...",
            counterText: "",
          ),
        ),
        actions: [
          // cancel Button
          TextButton(
            onPressed: () {
              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Abbrechen"),
          ),

          // save Button
          TextButton(
            onPressed:  ()  {
              Navigator.pop(context);
              showRaportSelect('Schlaf: ');
              //Textfeld leeren
            },
            child: Text("Weiter"),
          ),
        ],
      ),
    );
  }

  // Dialog für Schlafen Hinzufügen anzeiegn
  //
  //




  /// Dialog für Aktivität Hinzufügen anzeiegn
  //
  //



  void showRaportDialogActivity() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(10.0))),
        title: Text("Aktivität hinzufügen",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        //insetPadding: EdgeInsets.symmetric(horizontal: 100),
        content: TextField (
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 20,
          maxLength: 150,
          controller: _raportTextController,
          autofocus: true,
          decoration: InputDecoration(hintText: "Aktivität...",
            counterText: "",
          ),
        ),
        actions: [
          // cancel Button
          TextButton(
            onPressed: () {
              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Abbrechen"),
          ),

          // save Button
          TextButton(
            onPressed:  ()  {
              Navigator.pop(context);
              showRaportSelect('Aktivität: ');
              //Textfeld leeren
            },
            child: Text("Weiter"),
          ),
        ],
      ),
    );
  }

  // Dialog für Aktivität Hinzufügen anzeiegn
  //
  //


  /// Dialog für Diverses Hinzufügen anzeiegn
  //
  //



  void showRaportDialogDiverses() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(10.0))),
        title: Text("Diverses hinzufügen",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        //insetPadding: EdgeInsets.symmetric(horizontal: 100),
        content: TextField (
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 20,
          maxLength: 150,
          controller: _raportTextController,
          autofocus: true,
          decoration: InputDecoration(hintText: "Diverses...",
            counterText: "",
          ),
        ),
        actions: [
          // cancel Button
          TextButton(
            onPressed: () {
              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Abbrechen"),
          ),

          // save Button
          TextButton(
            onPressed:  ()  {
              Navigator.pop(context);
              showRaportSelect('Diverses: ');
              //Textfeld leeren
            },
            child: Text("Weiter"),
          ),
        ],
      ),
    );
  }

  // Dialog für Diverses Hinzufügen anzeiegn
  //
  //





  /// Dialog für Abholung Hinzufügen anzeiegn
  //
  //

  void showRaportDialogAbmeldung()  {
    Navigator.pop(context);
    DateTime now = DateTime.now();
    final mediaQuery = MediaQuery.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(10.0))),
        title: Text("Kinder",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: mediaQuery.size.width * 1,
                height: mediaQuery.size.height * 0.65,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Kinder")
                        .where("kita", isEqualTo: currentUser?.email)
                        .where("group", isEqualTo: widget.group)
                        .where("absenz", isEqualTo: "nein")
                        .snapshots(),
                    builder: (context, snapshot){
                      // wenn Daten vorhanden _> gib alle Daten aus
                      if (snapshot.hasData) {
                        List childrenList = snapshot.data!.docs;
                        childrenList.sort((a, b) => a['child'].compareTo(b['child']));
                        //als Liste wiedergeben
                        return ListView.builder(
                          padding: EdgeInsets.only(bottom:15),
                          itemCount: childrenList.length,
                          itemBuilder: (context, index) {
                            // individuelle Einträge abholen
                            DocumentSnapshot document = childrenList[index];
                            String docID = document.id;

                            // Eintrag von jedem Dokument abholen
                            Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                            String childText = data['child'];
                            String anmeldungText = data['anmeldung'];
                            bool active = data['switch'];

                            bool istAngemeldet = anmeldungText == "Abgemeldet";

                            var color = istAngemeldet ? Colors.grey : Colors.black;

                            // als List Tile wiedergeben
                            return Container(
                              margin: EdgeInsets.only( right: 10, top: 10),

                              child:
                              ChildSelectSwitch(
                                sectionName: childText,
                                color: color,
                                childcode: docID,
                                active: active,
                              ),


                            );
                          },
                        );
                      }
                      else {
                        return const Text("");
                      }
                    }
                ),
              ),
            ],
          ),

        ),

        actions: [
          // cancel Button
          TextButton(
            onPressed: () {
              // Textfeld schliessen
              Navigator.pop(context);
              firestoreDatabaseChild.updateSwitchAllOn(widget.group);
            },
            child: Text("Abbrechen"),
          ),

          // save Button
          TextButton(
            onPressed: () {
              anmeldungChild('anmeldung', "Abgemeldet");
              anmeldungChild('abholzeit', "");
              addRaport('Abgemeldet', '');

              // Textfeld schliessen
              Navigator.pop(context);
              _raportTextController.clear();
              firestoreDatabaseChild.updateSwitchAllOn(widget.group);
            },
            child: Text("Abmelden"),
          ),
        ],
      ),
    );
  }

  // Dialog für Abholung Hinzufügen anzeiegn
  //
  //



  @override
  Widget build(BuildContext context) {
    final titel = widget.name;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text('Raport  $titel',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Flexible(
                  flex: 2,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: GestureDetector(
                          onTap: showRaportDialogAnmeldung,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(2, 4),
                                ),
                              ],
                            ),
                            child:  Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.door_back_door_outlined,
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Anmeldung",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.inversePrimary,),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        flex: 1,
                        child: GestureDetector(
                          onTap: showRaportDialogEssen,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(2, 4),
                                ),
                              ],
                            ),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.local_pizza_outlined,
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Essen",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.inversePrimary,),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
                  )),

              const SizedBox(height: 20),
              Flexible(
                  flex: 2,
                  child:
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child:
                        GestureDetector(
                          onTap: showRaportDialogSchlaf,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(2, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.bed_outlined,
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Schlaf",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.inversePrimary,),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        flex: 1,
                        child:
                        GestureDetector(
                          onTap: showRaportDialogActivity,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(2, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.sports_soccer,
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Aktivitäten",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.inversePrimary,),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )

                    ],)),

              const SizedBox(height: 20),
              Flexible(
                  flex: 2,
                  child:
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child:
                        GestureDetector(
                          onTap: showRaportDialogDiverses,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(2, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.note_add_outlined,
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Diverses",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.inversePrimary,),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        flex: 1,
                        child:
                        GestureDetector(
                          onTap: showRaportDialogAbmeldung,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(2, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.family_restroom_outlined,
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Abholung",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.inversePrimary,),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),

              const SizedBox(height: 20),

              if (kIsWeb == false)
                Flexible(
                  flex: 1,
                  child: Row(
                    children: [

                      ImageUploadMultiple(group: widget.group),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
