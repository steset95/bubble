

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../components/my_profile_data_erlaubnis.dart';
import '../../helper/helper_functions.dart';
import '../../database/firestore_child.dart';



class EinwilligungenKindPageKita extends StatefulWidget {
  final String docID;

  const EinwilligungenKindPageKita({
    super.key,
    required this.docID
  });



  @override
  State<EinwilligungenKindPageKita> createState() => _EinwilligungenKindPageKitaState();
}

class _EinwilligungenKindPageKitaState extends State<EinwilligungenKindPageKita> {


  final FirestoreDatabaseChild firestoreDatabaseChild = FirestoreDatabaseChild();
  final currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController textController = TextEditingController();

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
        .collection("Einwilligungen_Felder")
        .doc(titel)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists)
      {
        if (!mounted) return;
        displayMessageToUser("Pole už existuje", context);
      }
      else {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser?.email)
            .collection("Einwilligungen_Felder")
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
          for (var doc in snapshot.docs) {
            doc.reference
                .collection("Einwilligungen_Felder")
                .doc(titel)
                .set({
              'titel': titel,
              'value': "nicht erlaubt",
            });
          }
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
        .collection("Einwilligungen_Felder")
        .doc(titel)
        .delete();

    FirebaseFirestore.instance
        .collection("Kinder")
        .where("kita", isEqualTo: currentUser?.email)
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference
            .collection("Einwilligungen_Felder")
            .doc(titel)
            .delete();
      }
    });

  }


  Widget showButtons () {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        /// Abholzeit
        GestureDetector(
            onTap: openBoxNew,
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  Text("Pridať polia",
                    style: TextStyle(fontFamily: 'Goli'),
                  ),
                  const SizedBox(width: 5),
                  const HugeIcon(
                    icon: HugeIcons.strokeRoundedFileAdd,
                    color: Colors.black,
                    size: 20,

                  ),
                ],
              ),
            )
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
          title: Text("Povolenia",
          ),
          actions: [
            showButtons (),
          ],
        ),
      body: SingleChildScrollView(
        child:
          Column(
            children: [
              StreamBuilder(
                  stream: firestoreDatabaseChild.getChildrenEinwilligungen(widget.docID),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting)
                    {
                      CircularProgressIndicator();
                    }
                    else if (snapshot.data != null) {
                      final fields = snapshot.data!.docs;
                      return Column(
                        children: [
                          const SizedBox(height: 20,),
                          HugeIcon(icon: HugeIcons.strokeRoundedSafe, color: Colors.black, size: 50),
                          const SizedBox(height: 10,),
                          ListView.builder(
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
                                return Dismissible(
                                  key: Key(title),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    // Remove the item from the list when dismissed
                                    openDeleteField(title);
                                    setState(() {
                                      fields.removeAt(index);
                                    });
                                  },
                                  background: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      color: Colors.red.withOpacity(0.5),
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.only(right: 20), // Background color when swiping
                                      child: HugeIcon(
                                        icon: HugeIcons.strokeRoundedDelete02,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  child:  MyProfileDataErlaubnis(
                                    text: content,
                                    sectionName: title,
                                  ),
                                );
                              }
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    }
                    return Text("");
                  }
              ),


            ],
          )
        )
    );
    }
    }






