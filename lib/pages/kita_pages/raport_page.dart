import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import '../../components/my_image_upload_button.dart';
import '../../helper/notification_controller.dart';




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



  // Raport hinzufügen bzw. Allgemeiner Firebase Connect
  void addRaport(String raportTitle, String raportText) {
    String currentDate = DateTime.now().toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    DateTime now = DateTime.now();
    String uhrzeit = DateFormat('kk:mm').format(now);
    // in Firestore Uložiť und "Raports" unter "Kinder" erstellen
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
        title: Text("Pridať dieťa?",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
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
            onPressed: () {
              // Raport hinzufügen
              anmeldungChild('anmeldung', 'Prítomná / ý (od: $formattedDate)');
              addRaport('Angemeldet', '');
              // Textfeld Zatvoriť
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Uložiť"),
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
              onPressed: () {
                // Raport hinzufügen
                addRaport('Essen: ', _raportTextController.text);
                // Textfeld Zatvoriť
                Navigator.pop(context);
              //Textfeld leeren
                _raportTextController.clear();
              },
              child: Text("Uložiť"),
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
            onPressed: () {
              // Raport hinzufügen
              addRaport('Schlaf: ', _raportTextController.text);
              // Textfeld Zatvoriť
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Uložiť"),
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
            onPressed: () {
              // Raport hinzufügen
              addRaport('Aktivität: ', _raportTextController.text);
              // Textfeld Zatvoriť
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Uložiť"),
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
            onPressed: () {
              // Raport hinzufügen
              addRaport('Diverses: ', _raportTextController.text);
              // Textfeld Zatvoriť
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Uložiť"),
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
        title: Text("Odhlásiť dieťa?",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
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
            onPressed: () {
              // Raport hinzufügen
              anmeldungChild('anmeldung', "Neprítomná / ý");
              anmeldungChild('abholzeit', "");
              addRaport('Abgemeldet', '');

              // Textfeld Zatvoriť
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Uložiť"),
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text("Oznam",
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

              ImageUpload(docID: widget.docID),
            ],
                  ),
                ),
            ],
          ),
        ),
    );
  }
}
