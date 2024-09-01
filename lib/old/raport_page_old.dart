
/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/components/my_raport_button.dart';
import '../components/my_delete_button.dart';
import 'package:intl/intl.dart';


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

  // Verweis auf FirestoreDatabaseChild von firestore_child.dart
  //final FirestoreDatabaseChild firestoreDatabaseChild = FirestoreDatabaseChild();

  final currentUser = FirebaseAuth.instance.currentUser;

  // Raport hinzufügen
  void addRaport(String raportText, String raportTitle) {
    String currentDate = DateTime.now().toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    // in Firestore Uložiť und "Raports" unter "Kinder" erstellen
    FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .collection("Kinder")
        .doc(widget.docID)
        .collection(formattedDate)
        .add({
      "RaportTitle" : raportTitle,
      "RaportText" : raportText,
    });
   }

  // Dialog für Hinzufügen anzeiegn
  void showRaportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Raport hinzufügen"),
        content: TextField (
          controller: _raportTextController,
          decoration: InputDecoration(hintText: "Raport posten..."),
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
                addRaport(_raportTextController.text, 'Essen');
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

  void deleteRaport() {
    // Bestätigungsdialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eintrag löschen"),
        content: const Text("Sicher dass Sie den Eintrag löschen wollen?"),
        actions: [
          //Cancel Button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Zrušiť"),
          ),
          //Löschen bestätigen
          TextButton(
            onPressed: () async {
              final raportDocs = await FirebaseFirestore.instance
                  .collection("Users")
                  .doc(currentUser?.email)
                  .collection("Kinder")
                  .doc(widget.docID)
                  .collection("Raports")
              .get();


              for (var doc in raportDocs.docs)
              {
                FirebaseFirestore.instance
                    .collection("Users")
                    .doc(currentUser?.email)
                    .collection("Kinder")
                    .doc(widget.docID)
                    .collection("Raports")
                    .doc(doc.id)
                    .delete();
                Navigator.pop(context);
              };

            },
              child: const Text("Löschen")
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            elevation: 0,
            title: Text("Raport"),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                        child: Column(
                        children: [
                          RaportButton(
                            onTap: showRaportDialog,
                          ),
                          Text("Essen hinzufügen")
                        ],
                      )
                    
                    
                    ),
                  ),
                  Expanded(
                  child: Container(
                    height: 150,
                    width: 150,
                    child: StreamBuilder<QuerySnapshot>(
                        stream:  FirebaseFirestore.instance
                            .collection("Users")
                            .doc(currentUser?.email)
                            .collection("Kinder")
                            .doc(widget.docID)
                            .collection("Raports")
                            .snapshots(),
                        builder: (context, snapshot) {
                          List<Row> raportWidgets =  [];
                        if(snapshot.hasData)
                          {
                            final raports = snapshot.data?.docs.reversed.toList();
                            for(var raport in raports!)
                              {
                                final raportWidget = Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Text(raport['RaportText']),
                                    ),
                                  ],
                                );
                                raportWidgets.add(raportWidget);
                              }
                          }
                          return
                              ListView(
                                children: raportWidgets,
                              );
                        }
                    ),
                  ),
                  ),
                  DeleteButton(onTap: deleteRaport),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: Container(
                        width: 150,
                        child: Column(
                          children: [
                            RaportButton(
                              onTap: showRaportDialog,
                            ),
                            Text("Schlaf")
                          ],
                        )

                    ),
                  ),
                  Expanded(child:
                  Container(
                    child: Text(""),
                  ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                        width: 150,
                        child: Column(
                          children: [
                            RaportButton(
                              onTap: showRaportDialog,
                            ),
                            Text("Toilette")
                          ],
                        )

                    ),
                  ),
                  Expanded(
                        child:
                  Container(
                    child: Text(""),
                  ),
                  ),
                ],
              )
            ],
          )
      ),
    );
  }
}
*/