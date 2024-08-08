
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pay/pay.dart';
import 'package:socialmediaapp/components/my_profile_data.dart';
import 'package:socialmediaapp/pages/eltern_pages/bezahlung_page_eltern.dart';

import '../../components/my_image_viewer_profile.dart';
import '../../components/my_profile_data_switch.dart';
import '../../components/notification_controller.dart';
import '../../database/firestore_child.dart';
import '../../helper/helper_functions.dart';
import 'addkind_page_eltern.dart';







class InfosKindPageEltern extends StatefulWidget {


  InfosKindPageEltern({
    super.key,

  });



  @override
  State<InfosKindPageEltern> createState() => _InfosKindPageElternState();
}

class _InfosKindPageElternState extends State<InfosKindPageEltern> {


  final currentUser = FirebaseAuth.instance.currentUser;
  final FirestoreDatabaseChild firestoreDatabaseChild = FirestoreDatabaseChild();


  final kinderCollection = FirebaseFirestore
      .instance
      .collection("Kinder"
  );


  var field = 'erlaubt';



  var optionsGeschlecht = [
    'weiblich',
    'männlich',
    'keine Angabe'
  ];

  var _currentItemSelectedGeschlecht = 'keine Angabe';
  var fieldGeschlecht = 'keine Angabe';




  bool showProgress = false;
  bool visible = false;



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






  void openChildBoxGeschlecht({String? childcode, String? datensatz}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(10.0))),
        title: Text("Geschlecht",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        // Text Eingabe
        content: DropdownButtonFormField<String>(
          isDense: true,
          isExpanded: false,

          items: optionsGeschlecht.map((String dropDownStringItem) {
            return DropdownMenuItem<String>(
              value: dropDownStringItem,
              child: Text(
                dropDownStringItem,
                style: TextStyle(

                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            );
          }).toList(),
          value: _currentItemSelectedGeschlecht, onChanged: (newValueSelected) {
          setState(() {
            _currentItemSelectedGeschlecht = newValueSelected!;
            field = newValueSelected;
          });
        },
        ),
        actions: [
          TextButton(
            child: const Text("Abbrechen",
            ),
            onPressed: () => Navigator.pop(context),
          ),
          // Speicher Button
          TextButton(
            onPressed: () {

              // Button wird für hinzufügen(unten) und anpassen (neben Kind) genutzt, daher wird zuerst geprüft ob
              // es um einen bestehenden oder neuen Datensatz geht
              if (childcode != null) {
                // Child Datensatz hinzufügen
                // Verweis auf "firestoreDatabaseChild" Widget in "firestore_child.dart" File
                // auf die Funktion "addChild" welche dort angelegt ist
                // TextController wurde oben definiert und fragt den Text im Textfeld ab
                firestoreDatabaseChild.updateChildEinwilligungen(childcode, datensatz!, _currentItemSelectedGeschlecht,);
              }
              //Box schliessen
              Navigator.pop(context);
            },
            child: Text("Speichern"),
          )
        ],
      ),
    );
  }







// Bearbeitungsfeld
  void editFieldInfos(String title, String field, String childcode, String value ) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(10.0))),
            title: Text(
              "$title",
              style: TextStyle(color: Colors.black,
                fontSize: 20,
              ),
              //"Edit $field",
            ),
            content: TextFormField(
              decoration: InputDecoration(
                counterText: "",
              ),
              maxLength: 150,
              initialValue: value,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 10,
              autofocus: true,

              onChanged: (value) {
                newValue = value;
              },
            ),
            actions: [
              // Cancel Button
              TextButton(
                child: const Text("Abbrechen",
                ),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                  child: const Text("Speichern",
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    if (newValue.trim().length > 0) {
                      // In Firestore updaten
                      kinderCollection.doc(childcode).update({field: newValue});
                    }
                  }
              ),
            ],
          ),
    );
  }

  Widget showData () {

      return SingleChildScrollView(
          child:
          StreamBuilder(
          stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser?.email)
          .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final userData = snapshot.data?.data() as Map<String, dynamic>;
        final childcode = userData["childcode"];


        /// PaymentCheck


        if (userData["aboBis"].toDate().isBefore(DateTime.now())){
          return
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 71),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap:  () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              BezahlungPage(),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Text("Bitte Abonnement erneuern",
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.credit_card_outlined,
                                color: Theme.of(context).colorScheme.primary,
                                size: 60,
                              ),
                              Icon(
                                  Icons.arrow_forward,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 30
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
        }

        /// PaymentCheck





        if (snapshot.hasData && childcode != "") {
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Kinder")
                .doc(childcode)
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
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  height: 100,
                                  child: ImageViewerProfile(childcode: childcode)),
                              const SizedBox(height: 10),

                              GestureDetector(
                              onTap: () => editFieldInfos("Name", "child", childcode, userData["child"]),
                                child: Text(userData["child"],
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ProfileData(
                        text: userData["geschlecht"],
                        sectionName: "Geschlecht",
                        onPressed: () =>
                        openChildBoxGeschlecht(
                        childcode: childcode,
                        datensatz: 'geschlecht'),
                      ),



                      ProfileData(
                        text: userData["geburtstag"],
                        sectionName: "Geburtstag",
                        onPressed: () => editFieldInfos("Geburtstag", "geburtstag", childcode, userData["geburtstag"]),
                      ),

                      ProfileData(
                        text: userData["personen"],
                        sectionName: "Zur Abholung berechtigte Personen",
                        onPressed: () => editFieldInfos("Berechtigte Personen", "personen", childcode, userData["personen"]),
                      ),

                      SizedBox(
                        height: 30,
                      ),
                      Text("Gesundheitsangaben",
                        style: TextStyle(fontSize: 20),
                      ),


                      ProfileData(
                        text: userData["alergien"],
                        sectionName: "Alergien",
                        onPressed: () => editFieldInfos("Alergien", "alergien", childcode, userData["alergien"]),
                      ),

                      ProfileData(
                        text: userData["krankheiten"],
                        sectionName: "Krankheiten",
                        onPressed: () => editFieldInfos("Krankheiten", "krankheiten", childcode, userData["krankheiten"]),
                      ),

                      ProfileData(
                        text: userData["medikamente"],
                        sectionName: "Medikamente",
                        onPressed: () => editFieldInfos("Medikamente", "medikamente", childcode, userData["medikamente"]),
                      ),

                      ProfileData(
                        text: userData["impfungen"],
                        sectionName: "Impfungen",
                        onPressed: () => editFieldInfos("Impfungen", "impfungen", childcode, userData["impfungen"]),
                      ),

                      ProfileData(
                        text: userData["kinderarzt"],
                        sectionName: "Kinderarzt",
                        onPressed: () => editFieldInfos("Kinderarzt", "kinderarzt", childcode, userData["kinderarzt"]),
                      ),

                      ProfileData(
                        text: userData["krankenkasse"],
                        sectionName: "Krankenkasse",
                        onPressed: () => editFieldInfos("Krankenkasse", "krankenkasse", childcode, userData["krankenkasse"]),
                      ),

                      ProfileData(
                        text: userData["bemerkungen"],
                        sectionName: "Bemerkungen",
                        onPressed: () => editFieldInfos("Bemerkungen", "bemerkungen", childcode, userData["bemerkungen"]),
                      ),


                      SizedBox(
                        height: 30,
                      ),
                      Text("Einwilligungen Kind",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ProfileDataSwitch(
                        text: userData["fotosSocialMedia"],
                        sectionName: "Fotos für SocialMedia",
                        field: "fotosSocialMedia",
                        childcode: childcode,
                      ),

                      ProfileDataSwitch(
                        text: userData["fotosApp"],
                        sectionName: "Fotos für App",
                        field: "fotosApp",
                        childcode: childcode,
                      ),

                      ProfileDataSwitch(
                        text: userData["nagellack"],
                        sectionName: "Nagellack auftragen",
                        field: "nagellack",
                        childcode: childcode,
                      ),

                      ProfileDataSwitch(
                        text: userData["schminken"],
                        sectionName: "Schminken",
                        field: "schminken",
                        childcode: childcode,
                      ),

                      ProfileDataSwitch(
                        text: userData["fieber"],
                        sectionName: "Rektales Fiebermessen",
                        field: "fieber",
                        childcode: childcode,
                      ),

                      ProfileDataSwitch(
                        text: userData["sonnencreme"],
                        sectionName: "Sonnencreme auftragen",
                        field: "sonnencreme",
                        childcode: childcode,
                      ),

                      ProfileDataSwitch(
                        text: userData["fremdkoerper"],
                        sectionName: "Fremdkörper entfernen",
                        field: "fremdkoerper",
                        childcode: childcode,
                      ),

                      ProfileDataSwitch(
                        text: userData["homoeopathie"],
                        sectionName: "Homöopathie",
                        field: "homoeopathie",
                        childcode: childcode,
                      ),


                    ],
                  );
                // Fehlermeldung wenn nichts vorhanden ist
              } else {
                return const Text("Keine Daten vorhanden");
              }
            },

          );

    }
    }
      if (snapshot.connectionState != ConnectionState.waiting)

        return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 71),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text("Bitte Kind hinzufügen",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  IconButton(
                    icon:  Icon(Icons.add_reaction_outlined,
                      size: 60,
                      color: Theme.of(context).colorScheme.primary,
                    ), onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          AddKindPageEltern(),
                      ),
                    );
                  },
                  ),
                ],
              ),
            ],
          ),
        ],
      );
      else
        return
          Text("");
    }

          )
      );

  }




  Widget showButtons () {
    return
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                AddKindPageEltern(),
            ),
          );
        },
        child: Container(
          child: Row(
            children: [
              Text("Kind wechseln"),
              const SizedBox(width: 10),
              Icon(Icons.child_care,
                color: Colors.black,
              ),
              const SizedBox(width: 15),
            ],
          ),
        ),
      );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text("Infos Kind",
        ),
        actions: [
          showButtons(),
        ],
      ),
      body: showData(),
    );
    }
}







