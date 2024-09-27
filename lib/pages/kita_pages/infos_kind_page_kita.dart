
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../components/my_profile_data_icon.dart';
import '../../components/my_profile_data_icon_delete.dart';
import '../../components/my_profile_data_read_only.dart';
import '../../database/firestore_child.dart';
import '../../helper/helper_functions.dart';




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
  final TextEditingController textController = TextEditingController();
  final FirestoreDatabaseChild firestoreDatabaseChild = FirestoreDatabaseChild();

  final kinderCollection = FirebaseFirestore
      .instance
      .collection("Kinder"
  );





  void openBoxNew() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(10.0))),
        title: Text("Nové pole",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        // Text Eingabe
        content: TextField(
          maxLength: 50,
          decoration: InputDecoration(hintText: "Názov",
            counterText: "",
          ),
          //Abfrage Inhalt Textfeld - oben definiert
          controller: textController,
          autofocus: true,
        ),
        actions: [
          TextButton(
            child: const Text("Zrušiť",
            ),
            onPressed: () => Navigator.pop(context),
          ),
          // Speicher Button
          TextButton(
            onPressed: () {
              addField(textController.text,);
              // Textfeld leeren nach Eingabe
              textController.clear();
              //Box Zatvoriť
              Navigator.pop(context);
            },
            child: Text("Pridať"),
          )
        ],
      ),
    );
  }



  void addField(String titel) async {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .collection("Info_Felder")
        .doc(titel)
        .get()
        .then((DocumentSnapshot document) {
if (document.exists)
  {
    displayMessageToUser("Pole už existuje", context);
  }
else {
  FirebaseFirestore.instance
      .collection("Users")
      .doc(currentUser?.email)
      .collection("Info_Felder")
      .doc(titel)
      .set({
      'titel': titel,
      'value': "",
      });

      FirebaseFirestore.instance
          .collection("Kinder")
          .where("kita", isEqualTo: currentUser?.email)
          .get()
          .then((snapshot) {
      snapshot.docs.forEach((doc) {
      doc.reference
          .collection("Info_Felder")
          .doc(titel)
          .set({
      'titel': titel,
      'value': "",
      });
      });
      });
    }
    });
  }


  void openDeleteField(String field) {
    // Bestätigungsdialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Zmazať oznam?",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        actions: [
          //Cancel Button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Zrušiť"),
          ),
          //Löschen bestätigen
          TextButton(
            onPressed: () async{
              deleteField(field);
              Navigator.pop(context);
            },
            child: const Text("Potvrdiť"),
          ),
        ],
      ),
    );
  }


  void deleteField(String titel) async {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .collection("Info_Felder")
        .doc(titel)
        .delete();

    FirebaseFirestore.instance
        .collection("Kinder")
        .where("kita", isEqualTo: currentUser?.email)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) {
        doc.reference
            .collection("Info_Felder")
            .doc(titel)
            .delete();
      });
    });

  }





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
        child: Column(
          children: [
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

                  return
                    Column(
                      children: [

                        const SizedBox(height: 30,),
                        HugeIcon(icon: HugeIcons.strokeRoundedUserAccount, color: Colors.black, size: 30),
                        const SizedBox(height: 10,),
                        Text(userData["child"],
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),

                        const SizedBox(height: 10,),

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

                        const SizedBox(height: 30,),
                        HugeIcon(icon: HugeIcons.strokeRoundedStethoscope02, color: Colors.black, size: 25),
                        const SizedBox(height: 5,),
                        Text("Ďalšie informácie",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    );

                  // Fehlermeldung wenn nichts vorhanden ist
                } else {
                  return const Text("No Data");
                }
              },
            ),
            SizedBox(
              height: 15,
            ),
            StreamBuilder(
                stream: firestoreDatabaseChild.getChildrenInofs(widget.docID),
                builder: (context, snapshot){
    if(snapshot.connectionState == ConnectionState.waiting)
    {
    Text("");
    }
    else if (snapshot.data != null) {
      final fields = snapshot.data!.docs;
      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: fields.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            // Individuelle Posts abholen
            final post = fields[index];

            // Daten von jedem Post abholen
            String title = post['titel'];
            String content = post['value'];

            // Liste als Tile wiedergeben
            return MyProfileDataIconDelete(
              text: content,
              sectionName: title,
              onPressed: () => openDeleteField(title),
            );
          }
      );
    }
    return Text("");
                }
            ),
            SizedBox(
              height: 20,
            ),
            IconButton(
              onPressed: openBoxNew,
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedAddCircle,
                color: Theme.of(context).colorScheme.primary,
                size: 30,
              ),
            ),
            Text("Pridať polia",
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      )
    );
    }
    }






