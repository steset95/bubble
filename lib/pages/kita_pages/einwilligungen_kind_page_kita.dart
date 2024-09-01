
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pay/pay.dart';
import 'package:socialmediaapp/components/my_profile_data.dart';

import '../../components/my_profile_data_icon_no_function.dart';
import '../../components/my_profile_data_read_only.dart';
import '../../helper/notification_controller.dart';
import '../../database/firestore_child.dart';



class EinwilligungenKindPageKita extends StatefulWidget {
  final String docID;

  EinwilligungenKindPageKita({
    super.key,
    required this.docID
  });



  @override
  State<EinwilligungenKindPageKita> createState() => _EinwilligungenKindPageKitaState();
}

class _EinwilligungenKindPageKitaState extends State<EinwilligungenKindPageKita> {


  final FirestoreDatabaseChild firestoreDatabaseChild = FirestoreDatabaseChild();
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
          title: Text("Povolenia",
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

                // Inhalt Daten

                return
                  Column(
                    children: [

                      MyProfileDataIconNoFunction(
                        text: userData["fotosSocialMedia"],
                        sectionName: "Fotky pre sociálne médiá",
                      ),

                      MyProfileDataIconNoFunction(
                        text: userData["fotosApp"],
                        sectionName: "Fotky pre aplikáciu",
                      ),

                      MyProfileDataIconNoFunction(
                        text: userData["nagellack"],
                        sectionName: "Lakovanie nechtov",
                      ),

                      MyProfileDataIconNoFunction(
                        text: userData["schminken"],
                        sectionName: "Líčenie",
                      ),

                      MyProfileDataIconNoFunction(
                        text: userData["fieber"],
                        sectionName: "Rektálne meranie teploty",
                      ),

                      MyProfileDataIconNoFunction(
                        text: userData["sonnencreme"],
                        sectionName: "Nanášanie opaľovacieho krému",
                      ),

                      MyProfileDataIconNoFunction(
                        text: userData["fremdkoerper"],
                        sectionName: "Odstránenie cudzieho predmetu",
                      ),

                      MyProfileDataIconNoFunction(
                        text: userData["homoeopathie"],
                        sectionName: "Homeopatiká",
                      ),

                      SizedBox(
                        height: 30,
                      ),


                    ],
                  );
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






