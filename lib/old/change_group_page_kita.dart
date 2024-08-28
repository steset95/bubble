
/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pay/pay.dart';
import 'package:socialmediaapp/components/my_profile_data.dart';

class ChangeGroupPageKita extends StatefulWidget {
  ChangeGroupPageKita({super.key});



  @override
  State<ChangeGroupPageKita> createState() => _ChangeGroupPageKitaState();
}

class _ChangeGroupPageKitaState extends State<ChangeGroupPageKita> {


  final currentUser = FirebaseAuth.instance.currentUser;


  // Referenz zu "Users" Datenbank
  final usersCollection = FirebaseFirestore
      .instance
      .collection("Users"
  );

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;



// Bearbeitungsfeld
  Future<void> editField(String field, String titel) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "$titel",
          //"Edit $field",
        ),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Bearbeiten...",
          ),
          onChanged: (value){
            newValue = value;
          },
        ),
        actions: [
          // Cancel Button
          TextButton(
            child: const Text("Zrušiť",
            ),
            onPressed: () => Navigator.pop(context),
          ),
          //Save Button
          TextButton(
            child: const Text("Uložiť",
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
        ],
      ),
    );

    // prüfen ob etwas geschrieben
    if (newValue.trim().length > 0) {
      // In Firestore updaten
      await usersCollection.doc(currentUser!.email).update({field: newValue});
    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Colors.black,
              height: 1.0,
            ),
          ),
          title: Text("Gruppen umbenennen",
            style: TextStyle(color:Colors.black),
          ),
        ),

        // Abfrage der entsprechenden Daten - Sammlung = Users
        body: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(currentUser?.email)
                .snapshots(),
            builder: (context, snapshot)
            {
              // ladekreis
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              // Fehlermeldung
              else if (snapshot.hasError) {
                return Text("Error ${snapshot.error}");
              }
              // Daten abfragen funktioniert
              else if (snapshot.hasData) {
                // Entsprechende Daten extrahieren
                final userData = snapshot.data?.data() as Map<String, dynamic>;
          
                // Inhalt Daten
          
                return
                  Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      ProfileData(
                        text: userData["gruppe1"],
                        sectionName: userData["gruppe1"],
                        onPressed: () => editField("gruppe1", userData["gruppe1"]),
                      ),

                      ProfileData(
                        text: userData["gruppe2"],
                        sectionName: userData["gruppe2"],
                        onPressed: () => editField("gruppe2", userData["gruppe2"]),
                      ),
                      ProfileData(
                        text: userData["gruppe3"],
                        sectionName: userData["gruppe3"],
                        onPressed: () => editField("gruppe3", userData["gruppe3"]),
                      ),
                    ],
                  );
                // Fehlermeldung wenn nichts vorhanden ist
              } else {
                return const Text("Keine Daten vorhanden");
              }
            },
          ),
        ),
      ),
    );
  }
}
*/


