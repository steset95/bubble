import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import '../../components/my_child_select_switch.dart';
import '../../old/my_child_select_switch_all_old.dart';
import '../../components/my_image_upload_button.dart';
import '../../components/my_image_upload_button_multiple.dart';
import '../../helper/notification_controller.dart';
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


  // Raport hinzufügen bzw. Allgemeiner Firebase Connect
  void addRaport(String raportTitle, String raportText) {
    String currentDate = DateTime.now().toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    DateTime now = DateTime.now();
    String uhrzeit = DateFormat('kk:mm').format(now);
    // in Firestore Uložiť und "Raports" unter "Kinder" erstellen
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

                        bool istAngemeldet = anmeldungText == "Neprítomná / ý";

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

            child: Text("Zrušiť"),
          ),

          // save Button
          TextButton(
            onPressed: () {
              // Raport hinzufügen
              addRaport(fieldText, _raportTextController.text);
              // Textfeld Zatvoriť
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
              firestoreDatabaseChild.updateSwitchAllOn(widget.group);
            },
            child: Text("Uložiť"),
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
        title: Text("Prihlásenie",
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

                        bool istAngemeldet = anmeldungText == "Neprítomná / ý";

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
              // Textfeld Zatvoriť
              Navigator.pop(context);
              firestoreDatabaseChild.updateSwitchAllOn(widget.group);
            },
            child: Text("Zrušiť"),
          ),

          // save Button
          TextButton(
            onPressed: () {
              anmeldungChild('anmeldung', 'Prítomná / ý (od: $formattedDate)');
              addRaport('Angemeldet', '');
              // Textfeld Zatvoriť
              _raportTextController.clear();
              Navigator.pop(context);
              firestoreDatabaseChild.updateSwitchAllOn(widget.group);
              //Textfeld leeren

            },
            child: Text("Prihlásiť"),
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
        title: Text("Strava pridať",
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
          decoration: InputDecoration(hintText: "Strava...",
              counterText: "",
          ),
        ),
         actions: [
          // cancel Button
          TextButton(
            onPressed: () {
              // Textfeld Zatvoriť
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
          },
            child: Text("Zrušiť"),
          ),

          // save Button
          TextButton(
            onPressed:  () {
    Navigator.pop(context);
    showRaportSelect('Essen: ');

            },
              //Textfeld leeren
              child: Text("Pokračovať"),
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
        title: Text("Spánok",
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
          decoration: InputDecoration(hintText: "Spánok...",
            counterText: "",
          ),
        ),
        actions: [
          // cancel Button
          TextButton(
            onPressed: () {
              // Textfeld Zatvoriť
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Zrušiť"),
          ),

          // save Button
          TextButton(
            onPressed:  ()  {
              Navigator.pop(context);
              showRaportSelect('Schlaf: ');
              //Textfeld leeren
            },
            child: Text("Pokračovať"),
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
        title: Text("Aktivity pridať",
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
          decoration: InputDecoration(hintText: "Aktivity...",
            counterText: "",
          ),
        ),
        actions: [
          // cancel Button
          TextButton(
            onPressed: () {
              // Textfeld Zatvoriť
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Zrušiť"),
          ),

          // save Button
          TextButton(
            onPressed:  ()  {
              Navigator.pop(context);
              showRaportSelect('Aktivität: ');
              //Textfeld leeren
            },
            child: Text("Pokračovať"),
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
        title: Text("Rôzne pridať",
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
          decoration: InputDecoration(hintText: "Rôzne...",
            counterText: "",
          ),
        ),
        actions: [
          // cancel Button
          TextButton(
            onPressed: () {
              // Textfeld Zatvoriť
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Zrušiť"),
          ),

          // save Button
          TextButton(
            onPressed:  ()  {
              Navigator.pop(context);
              showRaportSelect('Diverses: ');
              //Textfeld leeren
            },
            child: Text("Pokračovať"),
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
        title: Text("Odhlásenie",
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

                            bool istAngemeldet = anmeldungText == "Neprítomná / ý";

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
              // Textfeld Zatvoriť
              Navigator.pop(context);
              firestoreDatabaseChild.updateSwitchAllOn(widget.group);
            },
            child: Text("Zrušiť"),
          ),

          // save Button
          TextButton(
            onPressed: () {
              anmeldungChild('anmeldung', "Neprítomná / ý");
              anmeldungChild('abholzeit', "");
              addRaport('Abgemeldet', '');

              // Textfeld Zatvoriť
              Navigator.pop(context);
              _raportTextController.clear();
              firestoreDatabaseChild.updateSwitchAllOn(widget.group);
            },
            child: Text("Odhlásiť"),
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text('Oznam  $titel',
          style: TextStyle(fontSize: 18),
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
                            color: Colors.amber.shade600,
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
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedSun01,
                                color: Theme.of(context).colorScheme.inversePrimary,
                                size: 30,
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Prihlásenie",
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
                            color: Colors.deepOrange.shade600,
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
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedPizza01,
                                color: Theme.of(context).colorScheme.inversePrimary,
                                size: 30,
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Strava",
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
                            color: Colors.cyan.shade600,
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
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedSleeping,
                                color: Theme.of(context).colorScheme.inversePrimary,
                                size: 30,
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Spánok",
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
                            color: Colors.purple.shade600,
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
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedBasketball01,
                                color: Theme.of(context).colorScheme.inversePrimary,
                                size: 30,
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Aktivity",
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
                            color: Colors.lightBlue.shade600,
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
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedNote,
                                color: Theme.of(context).colorScheme.inversePrimary,
                                size: 30,
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Rôzne",
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
                            color: Colors.pink.shade600,
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
                                size: 30,
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Vyzdvihnutie",
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
    );
  }
}
