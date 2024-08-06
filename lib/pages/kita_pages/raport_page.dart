import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../components/my_image_upload_button.dart';
import '../../components/notification_controller.dart';




class RaportPage extends StatefulWidget {
  final String docID;


  RaportPage({
    super.key,
    required this.docID,


  });

  @override
  State<RaportPage> createState() => _RaportPageState();
}

class _RaportPageState extends State<RaportPage> {

  // Text Controller für Abfrage des Inhalts im Textfeld "Raport hinzufügen"
  final _raportTextController = TextEditingController();

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
        .doc(widget.docID)
        .collection(formattedDate)
        .add({
      "RaportTitle" : raportTitle,
      "RaportText" : raportText,
      'TimeStamp': Timestamp.now(),
      "Uhrzeit": uhrzeit,
    });
   }






// Feld anmledung direkt unter "Kinder" anpassen -> Anmelden
  void anmeldungChild(String field, String value) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(widget.docID)
        .update({
      field: value,
      'timestamp': Timestamp.now(),
    });
  }




  /// Dialog für Anmeldung Hinzufügen anzeiegn
  //
  //
  void showRaportDialogAnmeldung() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm').format(now);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(10.0))),
        title: Text("Kind Anmelden?",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
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
            onPressed: () {
              // Raport hinzufügen
              anmeldungChild('anmeldung', 'Anwesend (Seit: $formattedDate)');
              addRaport('Angemeldet', '');
              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Bestätigen"),
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
  void showRaportDialogEssen() {
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
              onPressed: () {
                // Raport hinzufügen
                addRaport('Essen: ', _raportTextController.text);
                // Textfeld schliessen
                Navigator.pop(context);
              //Textfeld leeren
                _raportTextController.clear();
              },
              child: Text("Speichern"),
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
            onPressed: () {
              // Raport hinzufügen
              addRaport('Schlaf: ', _raportTextController.text);
              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Speichern"),
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
            onPressed: () {
              // Raport hinzufügen
              addRaport('Aktivität: ', _raportTextController.text);
              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Speichern"),
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
            onPressed: () {
              // Raport hinzufügen
              addRaport('Diverses: ', _raportTextController.text);
              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Speichern"),
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
  void showRaportDialogAbmeldung() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm').format(now);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(10.0))),
        title: Text("Kind Abmelden?",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
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
            onPressed: () {
              // Raport hinzufügen
              anmeldungChild('anmeldung', "Abgemeldet");
              anmeldungChild('abholzeit', "");
              addRaport('Abgemeldet', '');

              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Speichern"),
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text("Raport",
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

                ImageUpload(docID: widget.docID),
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
