
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pay/pay.dart';
import 'package:socialmediaapp/components/my_profile_data.dart';

import '../../components/my_profile_data_read_only.dart';
import '../../helper/notification_controller.dart';







class InfosKindPageKita extends StatefulWidget {
  final String docID;

  InfosKindPageKita({
    super.key,
    required this.docID
  });



  @override
  State<InfosKindPageKita> createState() => _InfosKindPageKitaState();
}

class _InfosKindPageKitaState extends State<InfosKindPageKita> {


  final currentUser = FirebaseAuth.instance.currentUser;


  final kinderCollection = FirebaseFirestore
      .instance
      .collection("Kinder"
  );




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text("Informácie",
          ),
        ),
      body: SingleChildScrollView(
        child:
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Kinder")
                .doc(widget.docID)
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

            if (userData["eltern"] == "")
            {
            return Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Dieťa ešte nebolo pridelené"),
                  ],
                ),
              ],
            );
            }

            else {
              // Inhalt Daten

              return
                Column(
                  children: [
                    const SizedBox(height: 15,),
                    ProfileDataReadOnly(
                      text: userData["child"],
                      sectionName: "Meno a Priezvisko",
                    ),

                    ProfileDataReadOnly(
                      text: userData["geschlecht"],
                      sectionName: "Pohlavie",
                    ),
                    ProfileDataReadOnly(
                      text: userData["geburtstag"],
                      sectionName: "Dátum narodenia",
                    ),

                    ProfileDataReadOnly(
                      text: userData["personen"],
                      sectionName: "Osoby oprávnené vyzdvihnuť dieťa",
                    ),

                    const SizedBox(height: 15,),
                    Text("Informácie o zdraví",
                      style: TextStyle(fontSize: 25),
                    ),

                    ProfileDataReadOnly(
                      text: userData["alergien"],
                      sectionName: "Alergie",
                    ),

                    ProfileDataReadOnly(
                      text: userData["krankheiten"],
                      sectionName: "Choroby",
                    ),

                    ProfileDataReadOnly(
                      text: userData["medikamente"],
                      sectionName: "Lieky",
                    ),

                    ProfileDataReadOnly(
                      text: userData["impfungen"],
                      sectionName: "Očkovania",
                    ),

                    ProfileDataReadOnly(
                      text: userData["kinderarzt"],
                      sectionName: "Detský doktor",
                    ),

                    ProfileDataReadOnly(
                      text: userData["krankenkasse"],
                      sectionName: "Zdravotná poisťovňa",
                    ),

                    ProfileDataReadOnly(
                      text: userData["bemerkungen"],
                      sectionName: "Ďalšie informácie",
                    ),


                    SizedBox(
                      height: 30,
                    ),


                  ],
                );
            }
                // Fehlermeldung wenn nichts vorhanden ist
              } else {
                return const Text("No Data");
              }
            },
        )
        )
    );
    }
    }






