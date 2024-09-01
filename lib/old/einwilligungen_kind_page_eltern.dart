
/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pay/pay.dart';
import 'package:socialmediaapp/components/my_profile_data.dart';

import '../database/firestore_child.dart';



class EinwilligungenKindPageEltern extends StatefulWidget {
  final String childcode;

  EinwilligungenKindPageEltern({
    super.key,
    required this.childcode
  });



  @override
  State<EinwilligungenKindPageEltern> createState() => _EinwilligungenKindPageElternState();
}

class _EinwilligungenKindPageElternState extends State<EinwilligungenKindPageEltern> {


  final FirestoreDatabaseChild firestoreDatabaseChild = FirestoreDatabaseChild();
  final currentUser = FirebaseAuth.instance.currentUser;

  final kinderCollection = FirebaseFirestore
      .instance
      .collection("Kinder"
  );


  var options = [
    'erlaubt',
    'nicht erlaubt',
  ];

  var _currentItemSelected = 'erlaubt';
  var field = 'erlaubt';

  bool showProgress = false;
  bool visible = false;


// Bearbeitungsfeld
  void openChildBoxEinwilligungen({String? childcode, String? datensatz}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // Text Eingabe
        content: DropdownButtonFormField<String>(
          dropdownColor: Colors.blue[900],
          isDense: true,
          isExpanded: false,
          iconEnabledColor: Colors.white,
          focusColor: Colors.white,

          items: options.map((String dropDownStringItem) {
            return DropdownMenuItem<String>(
              value: dropDownStringItem,
              child: Text(
                dropDownStringItem,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            );
          }).toList(),
          value: _currentItemSelected, onChanged: (newValueSelected) {
          setState(() {
            _currentItemSelected = newValueSelected!;
            field = newValueSelected;
          });
        },
        ),
        actions: [
          // Speicher Button
          ElevatedButton(
            onPressed: () {

              // Button wird für hinzufügen(unten) und anpassen (neben Kind) genutzt, daher wird zuerst geprüft ob
              // es um einen bestehenden oder neuen Datensatz geht
              if (childcode != null) {
                // Child Datensatz hinzufügen
                // Verweis auf "firestoreDatabaseChild" Widget in "firestore_child.dart" File
                // auf die Funktion "addChild" welche dort angelegt ist
                // TextController wurde oben definiert und fragt den Text im Textfeld ab
                firestoreDatabaseChild.updateChildEinwilligungen(childcode, datensatz!, _currentItemSelected,);
              }
              //Box Zatvoriť
              Navigator.pop(context);
            },
            child: Text("Ändern auf:"),
          )
        ],
      ),
    );
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
                  final userData = snapshot.data?.data() as Map<String,
                      dynamic>;

                  // Inhalt Daten

                  return
                    Column(
                      children: [
                        Text("Infos Eltern"),

                        ProfileData(
                          text: userData["fotosSocialMedia"],
                          sectionName: "Fotos für SocialMedia",
                          onPressed: () =>
                              openChildBoxEinwilligungen(
                                  childcode: widget.childcode,
                                  datensatz: 'fotosSocialMedia'),
                        ),

                        ProfileData(
                          text: userData["fotosApp"],
                          sectionName: "Fotos für App",
                          onPressed: () =>
                              openChildBoxEinwilligungen(
                                  childcode: widget.childcode,
                                  datensatz: 'fotosApp'),
                        ),

                        ProfileData(
                          text: userData["nagellack"],
                          sectionName: "Nagellack auftragen",
                          onPressed: () =>
                              openChildBoxEinwilligungen(
                                  childcode: widget.childcode,
                                  datensatz: 'nagellack'),
                        ),

                        ProfileData(
                          text: userData["schminken"],
                          sectionName: "Schminken",
                          onPressed: () =>
                              openChildBoxEinwilligungen(
                                  childcode: widget.childcode,
                                  datensatz: 'schminken'),
                        ),

                        ProfileData(
                          text: userData["fieber"],
                          sectionName: "Rektales Fiebermessen",
                          onPressed: () =>
                              openChildBoxEinwilligungen(
                                  childcode: widget.childcode,
                                  datensatz: 'fieber'),
                        ),

                        ProfileData(
                          text: userData["sonnencreme"],
                          sectionName: "Sonnencreme auftragen",
                          onPressed: () =>
                              openChildBoxEinwilligungen(
                                  childcode: widget.childcode,
                                  datensatz: 'sonnencreme'),
                        ),

                        ProfileData(
                          text: userData["fremdkoerper"],
                          sectionName: "Fremdkörper entfernen (bspw. Zecken)",
                          onPressed: () =>
                              openChildBoxEinwilligungen(
                                  childcode: widget.childcode,
                                  datensatz: 'fremdkoerper'),
                        ),

                        ProfileData(
                          text: userData["homoeopathie"],
                          sectionName: "Homöopathie",
                          onPressed: () =>
                              openChildBoxEinwilligungen(
                                  childcode: widget.childcode,
                                  datensatz: 'homoeopathie'),
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
    return  SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Einwilligungen Kind"),
        ),
        body: showData(),
      )
            );
    }
    }


*/



