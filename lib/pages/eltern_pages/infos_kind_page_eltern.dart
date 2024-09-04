
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pay/pay.dart';
import 'package:bubble/components/my_profile_data.dart';
import 'package:bubble/pages/eltern_pages/bezahlung_page_eltern.dart';

import '../../components/my_image_viewer_profile.dart';
import '../../components/my_profile_data_switch.dart';
import '../../helper/notification_controller.dart';
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
    'Žena',
    'Muž',
    'Nechcem uviesť'
  ];

  var _currentItemSelectedGeschlecht = 'Nechcem uviesť';
  var fieldGeschlecht = 'Nechcem uviesť';




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
        title: Text("Pohlavie",
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
            child: const Text("Zrušiť",
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
              //Box Zatvoriť
              Navigator.pop(context);
            },
            child: Text("Uložiť"),
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
                child: const Text("Zrušiť",
                ),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                  child: const Text("Uložiť",
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                      kinderCollection.doc(childcode).update({field: newValue});
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
                        sectionName: "Pohlavie",
                        onPressed: () =>
                        openChildBoxGeschlecht(
                        childcode: childcode,
                        datensatz: 'geschlecht'),
                      ),



                      ProfileData(
                        text: userData["geburtstag"],
                        sectionName: "Dátum narodenia",
                        onPressed: () => editFieldInfos("Dátum narodenia", "geburtstag", childcode, userData["geburtstag"]),
                      ),

                      ProfileData(
                        text: userData["personen"],
                        sectionName: "Osoby oprávnené vyzdvihnuť dieťa",
                        onPressed: () => editFieldInfos("Oprávnené osoby", "personen", childcode, userData["personen"]),
                      ),

                      SizedBox(
                        height: 30,
                      ),
                      Text("Informácie o zdraví",
                        style: TextStyle(fontSize: 20),
                      ),


                      ProfileData(
                        text: userData["alergien"],
                        sectionName: "Alergie",
                        onPressed: () => editFieldInfos("Alergie", "alergien", childcode, userData["alergien"]),
                      ),

                      ProfileData(
                        text: userData["krankheiten"],
                        sectionName: "Choroby",
                        onPressed: () => editFieldInfos("Choroby", "krankheiten", childcode, userData["krankheiten"]),
                      ),

                      ProfileData(
                        text: userData["medikamente"],
                        sectionName: "Lieky",
                        onPressed: () => editFieldInfos("Lieky", "medikamente", childcode, userData["medikamente"]),
                      ),

                      ProfileData(
                        text: userData["impfungen"],
                        sectionName: "Očkovania",
                        onPressed: () => editFieldInfos("Očkovania", "impfungen", childcode, userData["impfungen"]),
                      ),

                      ProfileData(
                        text: userData["kinderarzt"],
                        sectionName: "Detský doktor",
                        onPressed: () => editFieldInfos("Detský doktor", "kinderarzt", childcode, userData["kinderarzt"]),
                      ),

                      ProfileData(
                        text: userData["krankenkasse"],
                        sectionName: "Zdravotná poisťovňa",
                        onPressed: () => editFieldInfos("Zdravotná poisťovňa", "krankenkasse", childcode, userData["krankenkasse"]),
                      ),

                      ProfileData(
                        text: userData["bemerkungen"],
                        sectionName: "Ďalšie informácie",
                        onPressed: () => editFieldInfos("Ďalšie informácie", "bemerkungen", childcode, userData["bemerkungen"]),
                      ),


                      SizedBox(
                        height: 30,
                      ),
                      Text("Povolenia",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ProfileDataSwitch(
                        text: userData["fotosSocialMedia"],
                        sectionName: "Fotky pre sociálne médiá",
                        field: "fotosSocialMedia",
                        childcode: childcode,
                      ),

                      ProfileDataSwitch(
                        text: userData["fotosApp"],
                        sectionName: "Fotky pre aplikáciu",
                        field: "fotosApp",
                        childcode: childcode,
                      ),

                      ProfileDataSwitch(
                        text: userData["nagellack"],
                        sectionName: "Lakovanie nechtov",
                        field: "nagellack",
                        childcode: childcode,
                      ),

                      ProfileDataSwitch(
                        text: userData["schminken"],
                        sectionName: "Líčenie",
                        field: "schminken",
                        childcode: childcode,
                      ),

                      ProfileDataSwitch(
                        text: userData["fieber"],
                        sectionName: "Meranie teploty",
                        field: "fieber",
                        childcode: childcode,
                      ),

                      ProfileDataSwitch(
                        text: userData["sonnencreme"],
                        sectionName: "Nanášanie opaľovacieho krému",
                        field: "sonnencreme",
                        childcode: childcode,
                      ),

                      ProfileDataSwitch(
                        text: userData["fremdkoerper"],
                        sectionName: "Odstránenie cudzieho predmetu",
                        field: "fremdkoerper",
                        childcode: childcode,
                      ),

                      ProfileDataSwitch(
                        text: userData["homoeopathie"],
                        sectionName: "Homeopatiká",
                        field: "homoeopathie",
                        childcode: childcode,
                      ),


                    ],
                  );
                // Fehlermeldung wenn nichts vorhanden ist
              } else {
                return const Text("No Data");
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
                  Text("Prosím pridajte dieťa",
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
              Text("Súrodenec"),
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
        title: Text("Dieťa",
        ),
        actions: [
          showButtons(),
        ],
      ),
      body: showData(),
    );
    }
}







