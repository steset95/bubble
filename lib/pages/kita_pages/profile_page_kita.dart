
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bubble/components/my_profile_data.dart';
import 'package:bubble/pages/impressum_page.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../components/my_profile_data_icon_delete.dart';
import '../../helper/abo_controller.dart';
import 'bezahlung_page_kita.dart';




class ProfilePageKita extends StatefulWidget {
  const ProfilePageKita({super.key});



  @override
  State<ProfilePageKita> createState() => _ProfilePageKitaState();
}

class _ProfilePageKitaState extends State<ProfilePageKita> {


  @override
  void initState() {
    super.initState();
    configureSDK();
    Future.delayed(Duration(milliseconds: 10000), () {aboCheck();});
  }


  final currentUser = FirebaseAuth.instance.currentUser;


  // Referenz zu "Users" Datenbank
  final usersCollection = FirebaseFirestore
      .instance
      .collection("Users"
  );

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final TextEditingController deleteCheck = TextEditingController();


  void waiting(){
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(10.0))), // Text Eingabe
            content: SizedBox(
              height: 45,
              child: Column(
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            ),

          ),
    );

  }


  void openBoxDelete({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(10.0))),
        title: Text("Zmazať používateľský účet?",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        content:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("6 + 11 ="),
            const SizedBox(width: 5,),
            SizedBox(
              width: 50,
              child: TextFormField(
                contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
                  // If supported, show the system context menu.
                  if (SystemContextMenu.isSupported(context)) {
                    return SystemContextMenu.editableText(
                      editableTextState: editableTextState,
                    );
                  }
                  // Otherwise, show the flutter-rendered context menu for the current
                  // platform.
                  return AdaptiveTextSelectionToolbar.editableText(
                    editableTextState: editableTextState,
                  );
                },
                controller: deleteCheck,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "?",
                  counterText: "",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (deleteCheck.text == "17") {
                final user = currentUser?.email;
                Navigator.pop(context);
                FirebaseFirestore.instance
                    .collection("Users")
                    .doc(user)
                    .delete();
                _firebaseAuth.currentUser?.delete();
                _firebaseAuth.signOut();
              }
              else
              {
                deleteCheck.clear();
                Navigator.pop(context);
              }
            },
            child: Text("Potvrdiť Vymazať"),
          ),
          TextButton(
            onPressed: () {
              deleteCheck.clear();
              Navigator.pop(context);
            },
            child: Text("Zrušiť"),
          )
        ],
      ),
    );
  }



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
          titel,
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
          //"Edit $field",
        ),
        content: TextFormField(
          contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
            // If supported, show the system context menu.
            if (SystemContextMenu.isSupported(context)) {
              return SystemContextMenu.editableText(
                editableTextState: editableTextState,
              );
            }
            // Otherwise, show the flutter-rendered context menu for the current
            // platform.
            return AdaptiveTextSelectionToolbar.editableText(
              editableTextState: editableTextState,
            );
          },
          decoration: InputDecoration(
            counterText: "",
            hintText: titel,
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
                  usersCollection.doc(currentUser!.email).update({field: newValue});
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
          titel,
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
          //"Edit $field",
        ),
        content: TextFormField(
          contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
            // If supported, show the system context menu.
            if (SystemContextMenu.isSupported(context)) {
              return SystemContextMenu.editableText(
                editableTextState: editableTextState,
              );
            }
            // Otherwise, show the flutter-rendered context menu for the current
            // platform.
            return AdaptiveTextSelectionToolbar.editableText(
              editableTextState: editableTextState,
            );
          },
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
                  usersCollection.doc(currentUser!.email).update({field: newValue});
              }
          ),
        ],
      ),
    );
  }

  Future logOut()  async {
    OneSignal.logout();
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
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Text("O applikácii",
                           style: TextStyle(fontFamily: 'Goli'),
                          ),
                          const SizedBox(width: 15),
                          Container(
                            color: Colors.black,
                            height: 25.0,
                            width: 1.0,
                          ),
                        ],
                      ),
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
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset("assets/images/bubbles_login.png", width: 350, height:350),
                ],
              ),
            ],
          ),
          SingleChildScrollView(
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
                          sectionName: "Meno",
                          onPressed: () => editField("username", "Meno", userData["username"], ),
                        ),

                        MyProfileDataIconDelete(
                          text: userData["email"],
                          sectionName: "Email", onPressed: () => openBoxDelete(),
                        ),
                        ProfileData(
                          text: userData["adress"],
                          sectionName: "Ulica / Číslo",
                          onPressed: () => editField("adress", "Ulica / Číslo", userData["adress"],),
                        ),

                        ProfileData(
                          text: userData["adress2"],
                          sectionName: "PSČ / Mesto",
                          onPressed: () => editField("adress2", "PSČ / Mesto", userData["adress2"],),
                        ),

                        ProfileData(
                          text: userData["tel"],
                          sectionName: "Mobilné číslo",
                          onPressed: () => editField("tel", "Mobilné číslo", userData["tel"],),
                        ),

                        ProfileData(
                          text: userData["beschreibung"],
                          sectionName: "O nás",
                          onPressed: () => editFieldBeschreibung("beschreibung", "O nás", userData["beschreibung"],),
                        ),
                        SizedBox(
                          height: 30,
                        ),



                        /// Payment
                        if (kIsWeb == false)
                        GestureDetector(
                          onTap: () {
                            waiting();
                            Future.delayed(Duration(milliseconds: 1800), () {Navigator.pop(context);});
                            Future.delayed(Duration(milliseconds: 2000), () {Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    BezahlungPageKita()
                                ));});

                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Predplatné",
                                  style: TextStyle(color: Theme.of(context).colorScheme.primary,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                HugeIcon(
                                  icon:  HugeIcons.strokeRoundedCircleArrowRight02,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
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
        ],
      ),
    );
  }
}


