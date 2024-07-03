
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pay/pay.dart';
import 'package:socialmediaapp/components/my_profile_data.dart';

import '../../components/my_profile_data_read_only.dart';
import '../../components/notification_controller.dart';







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
            title: Text("Infos Kind",
              style: TextStyle(color:Colors.black),
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
              return Text("Kind wurde noch nicht zugeordnet.");
              }

              else {
                // Inhalt Daten

                return
                  Column(
                    children: [
                      const SizedBox(height: 15,),
                      ProfileDataReadOnly(
                        text: userData["child"],
                        sectionName: "Name",
                      ),

                      ProfileDataReadOnly(
                        text: userData["geschlecht"],
                        sectionName: "Geschlecht",
                      ),
                      ProfileDataReadOnly(
                        text: userData["geburtstag"],
                        sectionName: "Geburtstag",
                      ),

                      ProfileDataReadOnly(
                        text: userData["personen"],
                        sectionName: "Zur Abholung berechtigte Personen",
                      ),

                      const SizedBox(height: 15,),
                      Text("Gesundheitsangaben",
                        style: TextStyle(fontSize: 25),
                      ),

                      ProfileDataReadOnly(
                        text: userData["alergien"],
                        sectionName: "Alergien",
                      ),

                      ProfileDataReadOnly(
                        text: userData["krankheiten"],
                        sectionName: "Krankheiten",
                      ),

                      ProfileDataReadOnly(
                        text: userData["medikamente"],
                        sectionName: "Medikamente",
                      ),

                      ProfileDataReadOnly(
                        text: userData["impfungen"],
                        sectionName: "Impfungen",
                      ),

                      ProfileDataReadOnly(
                        text: userData["kinderarzt"],
                        sectionName: "Kinderarzt",
                      ),

                      ProfileDataReadOnly(
                        text: userData["krankenkasse"],
                        sectionName: "Krankenkasse",
                      ),

                      ProfileDataReadOnly(
                        text: userData["bemerkungen"],
                        sectionName: "Bemerkungen",
                      ),


                      SizedBox(
                        height: 30,
                      ),


                    ],
                  );
              }
                  // Fehlermeldung wenn nichts vorhanden ist
                } else {
                  return const Text("Keine Daten vorhanden");
                }
              },
    )
    )
      )
            );
    }
    }






