
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socialmediaapp/components/my_profile_data.dart';
import 'package:socialmediaapp/components/my_profile_data_read_only.dart';

import '../../helper/notification_controller.dart';


class ProvisionPageKita extends StatefulWidget {
  ProvisionPageKita({super.key});



  @override
  State<ProvisionPageKita> createState() => _ProvisionPageKitaState();
}

class _ProvisionPageKitaState extends State<ProvisionPageKita> {


  final currentUser = FirebaseAuth.instance.currentUser;


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


  // Referenz zu "Users" Datenbank
  final usersCollection = FirebaseFirestore
      .instance
      .collection("Users"
  );


  Future<void> editField(String field, String titel, String text) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(10.0))),
            title: Text(
              "$titel",
              style: TextStyle(color: Colors.black,
                fontSize: 20,
              ),
              //"Edit $field",
            ),
            content: TextFormField(
              decoration: InputDecoration(
                counterText: "",
              ),
              maxLength: 100,
              initialValue: text,
              autofocus: true,
              onChanged: (value) {
                newValue = value;
              },
            ),
            actions: [
              // Cancel Button
              TextButton(
                child: const Text("Abbrechen",
                ),
                onPressed: () => Navigator.pop(context),
              ),
              //Save Button
              TextButton(
                child: const Text("Speichern",
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
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text("Provision",
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
                      text: userData["iban"],
                      sectionName: "IBAN",
                      onPressed: () => editField("iban", "IBAN", userData["iban"]),
                    ),



                    SizedBox(
                      height: 20,
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
    );
  }
}



