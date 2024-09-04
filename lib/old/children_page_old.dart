/* import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:bubble/databse/firestore_child.dart';
import 'package:bubble/pages/child_overview_page_kita.dart';
import 'package:bubble/pages/raport_page.dart';


class ChildrenPage extends StatefulWidget {

  const ChildrenPage({super.key});

  @override
  State<ChildrenPage> createState() => _ChildrenPageState();
}

class _ChildrenPageState extends State<ChildrenPage> {

  // Verweis auf FirestoreDatabaseChild

  final FirestoreDatabaseChild firestoreDatabaseChild = FirestoreDatabaseChild();

 // Text Controller für Abfrage des Inhalts im Textfeld

  final TextEditingController textController = TextEditingController();


 // Dialog Fenster
// String? = String, könnte aber auch 0 sein // docID
  void openChildBox({String? docID}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
      // Text Eingabe
      content: TextField(

        //Abfrage Inhalt Textfeld - oben definiert
        controller: textController,


      ),
      actions: [
        // Speicher Button
        ElevatedButton(
            onPressed: () {

              // Button wird für hinzufügen(unten) und anpassen (neben Kind) genutzt, daher wird zuerst geprüft ob
              // es um einen bestehenden oder neuen Datensatz geht
              if (docID == null) {
                // Child Datensatz hinzufügen
                // Verweis auf "firestoreDatabaseChild" Widget in "firestore_child.dart" File
                // auf die Funktion "addChild" welche dort angelegt ist
                // TextController wurde oben definiert und fragt den Text im Textfeld ab
                firestoreDatabaseChild.addChild(textController.text, "1");
              }

              // existierendes Kind anpassen

              else {
                firestoreDatabaseChild.updateChild(docID, textController.text);

              }

              // Textfeld leeren nach Eingabe
              textController.clear();

              //Box Zatvoriť
              Navigator.pop(context);
            },
            child: Text("Add"),
        )
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
          title: Text("Kinder"),
        ),

        floatingActionButton: FloatingActionButton(
        onPressed: openChildBox,
          child: const Icon(Icons.add),

        ),
        //Abfrage der Daten mittels Streambuilder
        body: StreamBuilder<QuerySnapshot>(
          // Abfrage des definierten Streams in firestoreDatabaseChild, Stream = getChildrenStream
          stream: firestoreDatabaseChild.getChildrenStream(),
          builder: (context, snapshot){
            // wenn Daten vorhanden _> gib alle Daten aus
            if (snapshot.hasData) {
              List childrenList = snapshot.data!.docs;
              //als Liste wiedergeben
              return ListView.builder(
                itemCount: childrenList.length,
                itemBuilder: (context, index) {
                  // individuelle Einträge abholen
                  DocumentSnapshot document = childrenList[index];
                  String docID = document.id;

                  // Eintrag von jedem Dokument abholen
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String childText = data['child'];

                  // als List Tile wiedergeben
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChildOverviewPage(docID: docID,)),
                      );
                    },
                    child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                      padding: const EdgeInsets.only(left: 15, bottom: 15),
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: ListTile(
                        title: Text(childText),
                        // Button für Ändern
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // ändern Button
                            IconButton(
                              onPressed: () => openChildBox(docID: docID),
                              icon: const Icon(Icons.settings),
                            ),
                            // Löschen button
                            IconButton(
                              onPressed: () => firestoreDatabaseChild.deleteChild(docID),
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        )
                    
                      ),
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
    );
  }
}

*/