
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pay/pay.dart';
import 'package:bubble/components/my_profile_data.dart';
import 'package:bubble/pages/eltern_pages/bezahlung_page_eltern.dart';

import '../../components/my_image_viewer_profile.dart';
import '../../components/my_profile_data_icon.dart';
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


  /// Notification

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => NotificationController().notificationCheck());
  }


  /// Notification



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


  bool showProgress = false;
  bool visible = false;


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
                hintText: title,
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


  // Bearbeitungsfeld
  void editFieldInfos2(String title, String field, String childcode, String value ) async {
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
                hintText: title,
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
                    FirebaseFirestore.instance
                        .collection("Kinder")
                        .doc(childcode)
                        .collection("Info_Felder")
                        .doc(field)
                        .update({'value': newValue});
                    Navigator.pop(context);
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
                var _currentItemSelectedGeschlecht = userData["geschlecht"];

               // Inhalt Daten

                return
                  Column(
                    children: [
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  height: 100,
                                  child: ImageViewerProfile(childcode: childcode)),
                              const SizedBox(height: 15),
                                if (userData["active"] == false)
                                  Text("Pozor: Dieťa bolo zo Škôlky odhlásené!"),
                            ],
                          ),

                        ],
                      ),

                      Container(
                        color: Colors.cyan.shade100,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Column(
                              children: [
                                HugeIcon(icon: HugeIcons.strokeRoundedNote, color: Colors.black, size: 30),
                                const SizedBox(height: 10,),
                                GestureDetector(
                                  onTap: () => editFieldInfos("Name", "child", childcode, userData["child"]),
                                  child: Text(userData["child"],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.inversePrimary,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(2, 4),
                                  ),
                                ],
                                //border: Border.all(color: Colors.black)
                              ),
                              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                              child: Column(
                                children: [
                                  InputDecorator(
                                    decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.transparent)),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 15.0),
                                    ),


                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        isDense: true,
                                        isExpanded: false,
                                        items: optionsGeschlecht.map((String dropDownStringItem) {
                                          return DropdownMenuItem<String>(
                                            value: dropDownStringItem,
                                            child: Text(
                                              dropDownStringItem,
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (newValueSelected) {
                                          setState(() {
                                            _currentItemSelectedGeschlecht = newValueSelected!;
                                          });
                                          kinderCollection.doc(childcode).update({'geschlecht': _currentItemSelectedGeschlecht});
                                        },
                                        value: _currentItemSelectedGeschlecht,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                              height: 15,
                            ),
                          ],
                        ),
                      ),



                      Container(
                        color: Colors.purple.shade100,
                        child: Column(
                          children: [
                            StreamBuilder(
                                stream: firestoreDatabaseChild.getChildrenInofs(childcode),
                                builder: (context, snapshot){
                                  if(snapshot.connectionState == ConnectionState.waiting)
                                  {
                                    Text("");
                                  }
                                  else if (snapshot.data != null)
                                  {
                                    final fields = snapshot.data!.docs;
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Column(
                                          children: [
                                            HugeIcon(icon: HugeIcons.strokeRoundedStethoscope02, color: Colors.black, size: 25),
                                            const SizedBox(height: 5,),
                                            Text("Ďalšie informácie",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
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
                                              return Column(
                                                children: [
                                                  ProfileData(
                                                    text: content,
                                                    sectionName: title,
                                                    onPressed: () =>
                                                        editFieldInfos2(
                                                            title, title,
                                                            childcode, content),
                                                  ),
                                                ],
                                              );
                                            }
                                        ),
                                      ],
                                    );
                                  }
                                  return Text("");
                                }
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),




                      Container(
                        color: Colors.deepOrange.shade100,
                        child: StreamBuilder(
                            stream: firestoreDatabaseChild.getChildrenEinwilligungen(childcode),
                            builder: (context, snapshot){
                              if(snapshot.connectionState == ConnectionState.waiting)
                              {
                                Text("");
                              }
                              else if (snapshot.data != null)
                              {
                                final fields = snapshot.data!.docs;
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Column(
                                      children: [
                                        HugeIcon(icon: HugeIcons.strokeRoundedSafe, color: Colors.black, size: 25),
                                        const SizedBox(height: 5,),
                                        Text("Povolenia",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
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
                                          return Column(
                                            children: [
                                              ProfileDataSwitch(
                                                text: content,
                                                sectionName: title,
                                                field: title,
                                                childcode: childcode,
                                              ),
                                            ],
                                          );
                                        }
                                    ),
                                  ],
                                );
                              }
                              return Text("");
                            }
                        ),
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
              HugeIcon(
                  icon: HugeIcons.strokeRoundedKid,
                  color: Colors.black,
                  size: 22
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







