 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bubble/components/my_profile_data.dart';
 /*

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  // festlegen dass es um den aktuell eingeloggten User geht

  final User? currentUser = FirebaseAuth.instance.currentUser;

  // Future zum User Attribute abfragen, Dokument = Users (in register_page erstellt

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .get();
  }

// Bearbeitungsfeld

  Future<void> editField(String field) async {

  }


  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigoAccent,
          //backgroundColor: Theme.of(context).colorScheme.inversePrimary,

          title: Text("Profil"),
          actions: [
            IconButton(
              onPressed: logout,
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        // Abfrage der entsprechenden Daten
        body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: getUserDetails(),
          builder: (context, snapshot){
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
              Map<String, dynamic>? user = snapshot.data!.data();

              return Column(
                children: [

                  ProfileData(
                    text: "Benutzername",
                    sectionName: "Benutzername",
                    onPressed: () => editField('username'),
                  ),

                  ProfileData(
                    text: "alter",
                    sectionName: "alter",
                    onPressed: () => editField('alter'),
                  ),

                ],
              );
              // Fehlermeldung wenn nichts vorhanden ist
            } else {
              return Text("Keine Daten vorhanden");
            }
          },
        ),
      ),
    );
  }
}
*/