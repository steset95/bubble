
/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pay/pay.dart';
import 'package:bubble/components/my_profile_data.dart';







class InfosKindPageEltern extends StatefulWidget {
  final String childcode;

  InfosKindPageEltern({
    super.key,
    required this.childcode
  });



  @override
  State<InfosKindPageEltern> createState() => _InfosKindPageElternState();
}

class _InfosKindPageElternState extends State<InfosKindPageEltern> {


  final currentUser = FirebaseAuth.instance.currentUser;


  final kinderCollection = FirebaseFirestore
      .instance
      .collection("Kinder"
  );



// Bearbeitungsfeld
  void editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            backgroundColor: Colors.grey,
            title: Text(
              "Bearbeiten",
              //"Edit $field",
              style: const TextStyle(color: Colors.white),
            ),
            content: TextField(
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter new $field",
                hintStyle: const TextStyle(color: Colors.grey),
              ),
              onChanged: (value) {
                newValue = value;
              },
            ),
            actions: [
              // Cancel Button
              TextButton(
                child: const Text("Zrušiť",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              //Save Button
              TextButton(
                child: const Text("Uložiť",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.of(context).pop(newValue),
              ),
            ],
          ),
    );


    if (newValue.trim().length > 0) {

      await kinderCollection.doc(widget.childcode).update({field: newValue});
    }
  }

  Widget showData () {
      return SingleChildScrollView(
          child:
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Kinder")
                .doc(widget.childcode)
                .snapshots(),
            builder: (context, snapshot) {
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
                      Text("Infos Eltern"),

                      ProfileData(
                        text: userData["child"],
                        sectionName: "Name",
                        onPressed: () => editField("child"),
                      ),

                      ProfileData(
                        text: userData["geschlecht"],
                        sectionName: "Geschlecht",
                        onPressed: () => editField("geschlecht"),
                      ),
                      ProfileData(
                        text: userData["geburtstag"],
                        sectionName: "Geburtstag",
                        onPressed: () => editField("geburtstag"),
                      ),

                      ProfileData(
                        text: userData["alergien"],
                        sectionName: "Alergien",
                        onPressed: () => editField("alergien"),
                      ),

                      ProfileData(
                        text: userData["krankheiten"],
                        sectionName: "Krankheiten",
                        onPressed: () => editField("krankheiten"),
                      ),

                      ProfileData(
                        text: userData["medikamente"],
                        sectionName: "Medikamente",
                        onPressed: () => editField("medikamente"),
                      ),

                      ProfileData(
                        text: userData["impfungen"],
                        sectionName: "Impfungen",
                        onPressed: () => editField("impfungen"),
                      ),

                      ProfileData(
                        text: userData["kinderarzt"],
                        sectionName: "Kinderarzt",
                        onPressed: () => editField("kinderarzt"),
                      ),

                      ProfileData(
                        text: userData["krankenkasse"],
                        sectionName: "Krankenkasse",
                        onPressed: () => editField("krankenkasse"),
                      ),

                      ProfileData(
                        text: userData["bemerkungen"],
                        sectionName: "Bemerkungen",
                        onPressed: () => editField("bemerkungen"),
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
      );

  }





  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Infos Kind"),
        ),
        body: showData(),

      )
            );
    }
}
*/






