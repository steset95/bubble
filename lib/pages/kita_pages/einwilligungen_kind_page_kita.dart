
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
            title: Text("Einwilligungen",
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

                  // Inhalt Daten

                  return
                    Column(
                      children: [

                        ProfileDataReadOnly(
                          text: userData["fotosSocialMedia"],
                          sectionName: "Fotos für SocialMedia",
                        ),

                        ProfileDataReadOnly(
                          text: userData["fotosApp"],
                          sectionName: "Fotos für App",
                        ),

                        ProfileDataReadOnly(
                          text: userData["nagellack"],
                          sectionName: "Nagellack auftragen",
                        ),

                        ProfileDataReadOnly(
                          text: userData["schminken"],
                          sectionName: "Schminken",
                        ),

                        ProfileDataReadOnly(
                          text: userData["fieber"],
                          sectionName: "Rektales Fiebermessen",
                        ),

                        ProfileDataReadOnly(
                          text: userData["sonnencreme"],
                          sectionName: "Sonnencreme auftragen",
                        ),

                        ProfileDataReadOnly(
                          text: userData["fremdkoerper"],
                          sectionName: "Fremdkörper entfernen (bspw. Zecken)",
                        ),

                        ProfileDataReadOnly(
                          text: userData["homoeopathie"],
                          sectionName: "Homöopathie",
                        ),

                        SizedBox(
                          height: 30,
                        ),


                      ],
                    );
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






