
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socialmediaapp/components/my_profile_data.dart';
import 'package:socialmediaapp/components/my_profile_data_read_only.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helper/notification_controller.dart';


class ProvisionPageKita extends StatefulWidget {
  ProvisionPageKita({super.key});



  @override
  State<ProvisionPageKita> createState() => _ProvisionPageKitaState();
}

class _ProvisionPageKitaState extends State<ProvisionPageKita> {


  final currentUser = FirebaseAuth.instance.currentUser;

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
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text("Provízia",
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
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text("Ako vďaku za denné používanie aplikácie dostanete od Bubble podiel 30% z príjmov, ktoré sme získali z predplatného rodičov. Prosím, zadajte IBAN požadovaného účtu a získajte príslušnú províziu na konci každého štvrťroka",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                  GestureDetector(
                    onTap: () async {
                    await launchUrl(
                    Uri.parse('https://laurasat.myhostpoint.ch/datenschutz/')); // Add URL which you want here
                    // Navigator.of(context).pushNamed(SignUpScreen.routeName);
                    },
                    child: Column(
                      children: [
                        Text("Platobné doklady",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Icon(Icons.receipt_long,
                          color: Theme.of(context).colorScheme.primary,
                          size: 25,
                        ),
                      ],
                    ),
                  ),

                  ],
                );
              // Fehlermeldung wenn nichts vorhanden ist
            } else {
              return const Text("No Data");
            }
          },
        ),
      ),
    );
  }
}



