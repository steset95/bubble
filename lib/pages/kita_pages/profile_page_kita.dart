
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socialmediaapp/components/my_profile_data.dart';
import 'package:socialmediaapp/components/my_profile_data_read_only.dart';
import 'package:socialmediaapp/pages/impressum_page.dart';
import 'package:socialmediaapp/pages/kita_pages/provision_page_kita.dart';

import '../../helper/notification_controller.dart';



class ProfilePageKita extends StatefulWidget {
  ProfilePageKita({super.key});



  @override
  State<ProfilePageKita> createState() => _ProfilePageKitaState();
}

class _ProfilePageKitaState extends State<ProfilePageKita> {


  final currentUser = FirebaseAuth.instance.currentUser;


  // Referenz zu "Users" Datenbank
  final usersCollection = FirebaseFirestore
      .instance
      .collection("Users"
  );

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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



// Bearbeitungsfeld
  Future<void> editField(String field, String titel, String text,) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
          TextButton(
              child: const Text("Uložiť",
              ),
              onPressed: () {
                Navigator.pop(context);
                if (newValue.trim().length > 0) {
                  // In Firestore updaten
                  usersCollection.doc(currentUser!.email).update({field: newValue});
                }
              }
          ),
        ],
      ),
    );
  }

  // Bearbeitungsfeld
  Future<void> editFieldBeschreibung(String field, String titel, String text,) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
          maxLength: 300,
          initialValue: text,
          keyboardType: TextInputType.multiline,
          maxLines: 4,
          autofocus: true,
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
          TextButton(
              child: const Text("Uložiť",
              ),
              onPressed: () {
                Navigator.pop(context);
                if (newValue.trim().length > 0) {
                  // In Firestore updaten
                  usersCollection.doc(currentUser!.email).update({field: newValue});
                }
              }
          ),
        ],
      ),
    );
  }


  Future logOut()  async {
    await _firebaseAuth.signOut();
  }

  Widget showButtons () {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// Abholzeit
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            ImpressumPage()),
                      );
                    },
                    child: Row(
                      children: [
                        Text("Über die App",
                         style: TextStyle(fontFamily: 'Goli'),
                        ),
                        const SizedBox(width: 15),
                        Container(
                          color: Colors.black,
                          height: 25.0,
                          width: 1.0,
                        ),
                      ],
                    )
                  ),

                  const SizedBox(width: 15),

                  /// Absenzmeldung

                  IconButton(
                    onPressed: logOut,
                    icon: const Icon(Icons.logout,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              );
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text("Profil",
        ),
        actions: [
          showButtons ()
        ],
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
                      text: userData["username"],
                      sectionName: "Name",
                      onPressed: () => editField("username", "Name", userData["username"], ),
                    ),

                    ProfileDataReadOnly(
                      text: userData["email"],
                      sectionName: "Email-Adresse",
                    ),
                    ProfileData(
                      text: userData["adress"],
                      sectionName: "Strasse und Hausnummer",
                      onPressed: () => editField("adress", "Strasse und Hausnummer", userData["adress"],),
                    ),

                    ProfileData(
                      text: userData["adress2"],
                      sectionName: "PLZ und Ort",
                      onPressed: () => editField("adress2", "PLZ und Ort", userData["adress2"],),
                    ),

                    ProfileData(
                      text: userData["tel"],
                      sectionName: "Telefonnummer",
                      onPressed: () => editField("tel", "Telefonnummer", userData["tel"],),
                    ),

                    ProfileData(
                      text: userData["beschreibung"],
                      sectionName: "Über uns",
                      onPressed: () => editFieldBeschreibung("beschreibung", "Über uns", userData["beschreibung"],),
                    ),

                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap:  () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              ProvisionPageKita()),
                        );
                      },
                      child: Column(
                        children: [
                          Text("Provision",
                          style: TextStyle(
                            fontSize: 15,
                          color: Theme.of(context).colorScheme.primary,),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(

                                          borderRadius: BorderRadius.all(Radius.circular(100))
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text (userData["guthaben"].toString(),
                                                  style: TextStyle(
                                                  fontSize: 30,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
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



