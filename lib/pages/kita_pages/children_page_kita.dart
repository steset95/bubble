import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:bubble/database/firestore_child.dart';
import 'package:bubble/pages/chat_page.dart';
import 'package:bubble/pages/kita_pages/child_overview_page_kita.dart';
import 'package:bubble/pages/kita_pages/raport_group_page.dart';
import '../../helper/notification_controller.dart';


class ChildrenPageKita extends StatefulWidget {

  ChildrenPageKita({super.key});

  @override
  State<ChildrenPageKita> createState() => _ChildrenPageKitaState();
}

class _ChildrenPageKitaState extends State<ChildrenPageKita> {



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



  final FirestoreDatabaseChild firestoreDatabaseChild = FirestoreDatabaseChild();

  final TextEditingController textController = TextEditingController();


  final usersCollection = FirebaseFirestore
      .instance
      .collection("Users"
  );

  // Gruppen
  var options = [
    '1',
    '2',
    '3',
  ];

  var _currentItemSelected = '1';
  var group = '1';


  bool showProgress = false;
  bool visible = false;
  final currentUser = FirebaseAuth.instance.currentUser;





  /// Kind hinzufügen Altert Dialog

  void openChildBoxNew({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(10.0))),
        title: Text("Pridajte dieťa",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        // Text Eingabe
        content: TextField(
          maxLength: 40,
          decoration: InputDecoration(hintText: "Meno a Priezvisko",
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
              addChild(textController.text,);
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

  DateTime absenzBis = DateTime.now().subtract(const Duration(days:1));

  void addChild(String child) async {
     DocumentReference docRef = await
    FirebaseFirestore.instance
        .collection("Kinder")
        .add({
      'child': child,
      'group': buttons,
      'anmeldung': "Neprítomná / ý",
      'absenzText': "",
      'absenz': "nein",
      "absenzBis": absenzBis,
      'timeStamp': Timestamp.now(),
      'kita': currentUser?.email,
      'abholzeit': "",
      'geschlecht': "Nechcem uviesť",
      'geburtstag': "",
      'personen': "",
      'eltern': "",
      'shownotification': "0",
      'registrierungen': 0,
      'active': true,
      'switch': true,
    });

     FirebaseFirestore.instance
         .collection("Users")
         .doc(currentUser?.email)
         .collection("Info_Felder")
         .get()
         .then((snapshot) {
       snapshot.docs.forEach((doc) {

         FirebaseFirestore.instance
             .collection("Users")
             .doc(currentUser?.email)
             .collection("Info_Felder")
             .doc(doc.reference.id)
             .get()
             .then((DocumentSnapshot document) {

           String field = document['titel'];

           FirebaseFirestore.instance
               .collection("Kinder")
               .doc(docRef.id)
               .collection("Info_Felder")
               .doc(field)
               .set({
             'titel': field,
             'value': "",
           });

         });

       });
       });

     FirebaseFirestore.instance
         .collection("Users")
         .doc(currentUser?.email)
         .collection("Einwilligungen_Felder")
         .get()
         .then((snapshot) {
       snapshot.docs.forEach((doc) {

         FirebaseFirestore.instance
             .collection("Users")
             .doc(currentUser?.email)
             .collection("Einwilligungen_Felder")
             .doc(doc.reference.id)
             .get()
             .then((DocumentSnapshot document) {

           String field = document['titel'];

           FirebaseFirestore.instance
               .collection("Kinder")
               .doc(docRef.id)
               .collection("Einwilligungen_Felder")
               .doc(field)
               .set({
             'titel': field,
             'value': "nicht erlaubt",
           });

         });

       });
     });



     await FirebaseFirestore.instance
    .collection("Users")
    .doc(currentUser?.email)
        .get()
        .then((DocumentSnapshot document) {
        int anzahlKinder = document["anzahlKinder$buttons"];
        usersCollection.doc(currentUser!.email).update({"anzahlKinder$buttons": anzahlKinder + 1});
      });



    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(10.0))),
        title: const Text(
          "Kľúč",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        content: Row(
          children: [
            Text(docRef.id),
            IconButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: docRef.id));
              },
              icon: Icon(Icons.copy_all_outlined),
            ),

          ],
        ),
        actions: [
          // Cancel Button
          TextButton(
            child: const Text("Zatvoriť",
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Odoslať",
            ),

            onPressed: () async {
              await Share.share('Na aktiváciu musíte zadať nasledujúci aktivačný kľúč do svojej aplikácie: ${docRef.id}',
                  subject: 'Activationkey',
                  sharePositionOrigin: Rect.fromLTWH(0, 0, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height / 2)
              );
            },
          ),
        ],
      ),
    );
  }






  /// Gruppe ändern Altert Dialog

  void openChildBoxGroup(String? docID, String group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(10.0))),
        title: Text("Zmeniť skupinu",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        // Text Eingabe
        content: DropdownButtonFormField<String>(

            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 15.0),
              labelText: '1/2/3',
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
          //dropdownColor: Colors.blue[900],
          isDense: true,
          isExpanded: false,
          //iconEnabledColor: Colors.black,
          //focusColor: Colors.black,

          items: options.map((String dropDownStringItem) {
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
          value: _currentItemSelected,
          onChanged: (newValueSelected) {
          setState(() {
            _currentItemSelected = newValueSelected!;
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
              if (docID != null) {

                FirebaseFirestore.instance
                      .collection("Users")
                      .doc(currentUser?.email)
                      .get()
                      .then((DocumentSnapshot document) {
                    int anzahlKinder = document['anzahlKinder$group'];
                    int anzahlKinderUpdate = (anzahlKinder - 1);

                    FirebaseFirestore.instance
                    .collection("Users")
                        .doc(currentUser?.email)
                        .update({'anzahlKinder$group': anzahlKinderUpdate});
                  });




                FirebaseFirestore.instance
                    .collection("Users")
                    .doc(currentUser?.email)
                    .get()
                    .then((DocumentSnapshot document) {
                  int anzahlKinder2 = document["anzahlKinder$_currentItemSelected"];


                  usersCollection.doc(currentUser!.email).update({"anzahlKinder$_currentItemSelected": anzahlKinder2 + 1});
                });

                firestoreDatabaseChild.updateChild(docID, _currentItemSelected);

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

  bool isVisible = false;
  Widget? selectedOption;


  var buttons = '1';


  Future<void> editField(String field, String titel, String text) async {
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
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: text,
          ),
          maxLength: 20,
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
          //Save Button
          TextButton(
            child: const Text("Uložiť",
            ),
            onPressed: () {
              Navigator.of(context).pop(newValue);
              usersCollection.doc(currentUser!.email).update({field: newValue});
            }
          ),
        ],
      ),
    );

  }


  void notificationNullKind(String docID) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(docID)
        .update({"shownotification": "0"});
  }


  /// ShowButtons

  Widget showButtons () {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        /// Abholzeit
        GestureDetector(
            onTap: openChildBoxNew,
            child: Row(
              children: [
                Text("Pridať dieťa",
                  style: TextStyle(fontFamily: 'Goli'),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.add_reaction_outlined,
                  color: Colors.black,
                ),
              ],
            )
        ),

        const SizedBox(width: 20),
      ],
    );
  }






  /// Start Widget


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text("Deti",
        ),
        actions: [
          showButtons (),
        ],
      ),



      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () =>


            FirebaseFirestore.instance
                .collection("Users")
                .doc(currentUser?.email)
                .get()
                .then((DocumentSnapshot document) {
              final  buttonstogroup = 'gruppe$buttons';
              final String titel = document[buttonstogroup];
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RaportGroupPage(group: buttons, name: titel)),
              );

            }),
        child: HugeIcon(
          icon: HugeIcons.strokeRoundedCalendarAdd01,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      /// Anzeige 3 Gruppen

      body:
      Container(
        child:
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(currentUser?.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Entsprechende Daten extrahieren
                    final userData = snapshot.data?.data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.only(top: 20,),
                      child: Column(
                        children: [
                          if (buttons == '1')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                     setState(()  {
                                        selectedOption = optiona();
                                    });
                                    buttons = '1';
                                  },

                                  child: optionCards(
                                    userData["gruppe1"],
                                    "assets/icons/recycle.png", context, "1",
                                    Theme.of(context).colorScheme.primary, userData["anzahlKinder1"]),
                                ),

                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedOption = optionb();
                                      });
                                      buttons = '2';
                                    },
                                    child: optionCards(
                                      userData["gruppe2"], "assets/icons/tools.png",
                                      context, "2", Colors.indigo.shade100, userData["anzahlKinder2"]),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedOption = optionc();
                                      });
                                      buttons = '3';
                                    },
                                    child: optionCards(
                                      userData["gruppe3"], "assets/icons/file.png",
                                      context, "3", Colors.indigo.shade100, userData["anzahlKinder3"]),
                                ),
                              ],
                            ),


                          if (buttons == '2')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedOption = optiona();
                                      });
                                      buttons = '1';
                                    },

                                    child: optionCards(
                                      userData["gruppe1"], "assets/icons/recycle.png",
                                      context, "1", Colors.indigo.shade200, userData["anzahlKinder1"] ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedOption = optionb();
                                      });
                                      buttons = '2';
                                    },
                                    child: optionCards(
                                      userData["gruppe2"], "assets/icons/tools.png",
                                      context, "2", Theme.of(context).colorScheme.primary, userData["anzahlKinder2"]),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedOption = optionc();
                                      });
                                      buttons = '3';
                                    },
                                    child: optionCards(
                                      userData["gruppe3"], "assets/icons/file.png",
                                      context, "3", Colors.indigo.shade200, userData["anzahlKinder3"]),
                                ),
                              ],
                            ),


                          if (buttons == '3')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedOption = optiona();
                                      });
                                      buttons = '1';
                                    },

                                    child: optionCards(
                                      userData["gruppe1"], "assets/icons/recycle.png",
                                      context, "1", Colors.indigo.shade200, userData["anzahlKinder1"]),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedOption = optionb();
                                      });
                                      buttons = '2';
                                    },
                                    child: optionCards(
                                      userData["gruppe2"], "assets/icons/tools.png",
                                      context, "2", Colors.indigo.shade200, userData["anzahlKinder2"]),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedOption = optionc();
                                      });
                                      buttons = '3';
                                    },
                                    child: optionCards(
                                      userData["gruppe3"], "assets/icons/file.png",
                                      context, "3", Theme.of(context).colorScheme.primary, userData["anzahlKinder3"]),
                                ),
                              ],
                            ),

                          if(selectedOption != null) selectedOption!
                          else
                            optiona(),


                        ],
                      ),
                    );
                  }
                  return Text("");
                }
            ),
                ),

    );

  }

  /// Funktion 3 Gruppen

  Widget optionCards (
      String text, String assetImage, BuildContext context, String cardId, var color, int anzahlKinder) {
    return
      Center(
        child: Stack(
          children: [
            Container(
              height: 50,
              width: 90,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 15,
                            width: 30,
                            child: IconButton(
                                onPressed: () => editField('gruppe$cardId', "Zmeniť meno skupiny", 'Skupina$cardId'),
                                icon: HugeIcon(
                                  icon: HugeIcons.strokeRoundedPencilEdit01,
                                  color: Colors.white,
                                  size: 10,
                                ),),
                          ),
                        ],
                      ),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child:
                            Container(
                              width: 70,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  text,
                                  style: TextStyle(color: Colors.white,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Column(
              children: [
                const SizedBox(height: 34),
                Row(
                  children: [
                    const SizedBox(width: 70),
                    Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.all(Radius.circular(100))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${anzahlKinder}',
                                  style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,
                                      fontSize: 10
                                  ),
                                )
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
      );
  }


  /// 3 Gruppen


  Widget optiona()  {
    return Expanded(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            // Abfrage des definierten Streams in firestoreDatabaseChild, Stream = getChildrenStream
              stream: firestoreDatabaseChild.getChildrenStream1(),
              builder: (context, snapshot) {
                // wenn Daten vorhanden _> gib alle Daten aus
                if (snapshot.hasData)  {
                  List childrenList1 = snapshot.data!.docs;
                  childrenList1.sort((a, b) => a['child'].compareTo(b['child']));
                  //als Liste wiedergeben
                  return ListView.builder (
                    padding: EdgeInsets.only(bottom: 55),
                    itemCount: childrenList1.length,
                    itemBuilder: (context, index) {
                      // individuelle Einträge abholen
                      DocumentSnapshot document = childrenList1[index];
                      String docID = document.id;

                      // Eintrag von jedem Dokument abholen
                      Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                      String childText = data['child'];
                      String anmeldungText = data['anmeldung'];
                      String elternmail = data['eltern'];
                      String shownotification = data['shownotification'];
                      String absenz = data['absenz'];

                      if (absenz == "ja" && data["absenzBis"].toDate().isBefore(DateTime.now()))
                      {
                        FirebaseFirestore.instance
                            .collection("Kinder")
                            .doc(document.id)
                            .update({
                          'absenz': "nein",
                          'anmeldung': "Neprítomná / ý",
                        });
                      }

                      bool istAngemeldet = anmeldungText == "Neprítomná / ý";
                      bool hatAbsenz = absenz == "nein";

                      var color = istAngemeldet ? Colors.white : Theme.of(context).colorScheme.primary;
                      var color2 = istAngemeldet ? Colors.black : Colors.white;
                      var color3 = hatAbsenz ? Colors.transparent : Theme.of(context).colorScheme.secondary;

                      // als List Tile wiedergeben
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChildOverviewPageKita(docID: docID, group: "1"
                            )),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: color3,
                            ),
                            color: color,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(2, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.only(left: 5, bottom: 5, right: 5, top: 3),
                          margin: EdgeInsets.only(left: 20, right: 20, top: 10),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 45,
                                child: Column(
                                  children: [

                                    if(shownotification == "1")
                                      Container(
                                        child: IconButton(
                                          onPressed: () {
                                            notificationNullKind(docID);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => ChatPage(
                                                receiverID: elternmail, childcode: docID,
                                              )),
                                            );
                                          },
                                          icon: HugeIcon(
                                            icon: HugeIcons.strokeRoundedMessage01,
                                            color: color2,
                                            size: 20,
                                          ),
                                        ),
                                      ),

                                  ],
                                ),
                              ),

                              Column(
                                children: [
                                  Text(childText,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: color2),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(anmeldungText,
                                    style: TextStyle(color: color2,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 45,
                                child: IconButton(
                                  onPressed: () => openChildBoxGroup(docID, "1"),
                                  icon: HugeIcon(
                                    icon: HugeIcons.strokeRoundedUserMultiple02,
                                    color: color2,
                                    size: 20,
                                  ),
                                ),
                              )
                                ],
                              ),


                          ),
                        );
                    },
                  );
                }
                else {
                  return const Text("");
                }
              }
          ),
        ),
      );
  }

  Widget optionb() {
    return Expanded(
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
          // Abfrage des definierten Streams in firestoreDatabaseChild, Stream = getChildrenStream
            stream: firestoreDatabaseChild.getChildrenStream2(),
            builder: (context, snapshot){
              // wenn Daten vorhanden _> gib alle Daten aus
              if (snapshot.hasData) {
                List childrenList2 = snapshot.data!.docs;
                childrenList2.sort((a, b) => a['child'].compareTo(b['child']));
                //als Liste wiedergeben
                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 55),
                  itemCount: childrenList2.length,
                  itemBuilder: (context, index) {
                    // individuelle Einträge abholen
                    DocumentSnapshot document = childrenList2[index];
                    String docID = document.id;

                    // Eintrag von jedem Dokument abholen
                    Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                    String childText = data['child'];
                    String anmeldungText = data['anmeldung'];
                    String elternmail = data['eltern'];
                    String shownotification = data['shownotification'];
                    String absenz = data['absenz'];

                    if (absenz == "ja" && data["absenzBis"].toDate().isBefore(DateTime.now()))
                    {
                      FirebaseFirestore.instance
                          .collection("Kinder")
                          .doc(document.id)
                          .update({
                        'absenz': "nein",
                        'anmeldung': "Neprítomná / ý",
                      });
                    }

                    bool istAngemeldet = anmeldungText == "Neprítomná / ý";
                    bool hatAbsenz = absenz == "nein";

                    var color = istAngemeldet ? Colors.white : Theme.of(context).colorScheme.primary;
                    var color2 = istAngemeldet ? Colors.black : Colors.white;
                    var color3 = hatAbsenz ? Colors.transparent : Theme.of(context).colorScheme.secondary;

                    // als List Tile wiedergeben
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChildOverviewPageKita(docID: docID, group: "2"
                          )),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: color3,
                          ),
                          color: color,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.only(left: 5, bottom: 5, right: 5, top: 3),
                        margin: EdgeInsets.only(left: 20, right: 20, top: 10),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 45,
                              child: Column(
                                children: [

                                  if(shownotification == "1")
                                    Container(
                                      child: IconButton(
                                        onPressed: () {
                                          notificationNullKind(docID);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => ChatPage(
                                              receiverID: elternmail, childcode: docID,
                                            )),
                                          );
                                        },
                                        icon: HugeIcon(
                                          icon: HugeIcons.strokeRoundedMessage01,
                                          color: color2,
                                          size: 20,
                                        ),
                                      ),
                                    ),

                                ],
                              ),
                            ),

                            Column(
                              children: [
                                Text(childText,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: color2),
                                ),
                                const SizedBox(height: 3),
                                Text(anmeldungText,
                                  style: TextStyle(color: color2,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 45,
                              child: IconButton(
                                onPressed: () => openChildBoxGroup(docID, "2"),
                                icon: HugeIcon(
                                  icon: HugeIcons.strokeRoundedUserMultiple02,
                                  color: color2,
                                  size: 20,
                                ),
                              ),
                            )
                          ],
                        ),


                      ),
                    );
                  },
                );
              }
              else {
                return const Text("");
              }
            }
        ),
      ),
    );
  }

  Widget optionc() {
    return Expanded(
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
          // Abfrage des definierten Streams in firestoreDatabaseChild, Stream = getChildrenStream
            stream: firestoreDatabaseChild.getChildrenStream3(),
            builder: (context, snapshot){
              // wenn Daten vorhanden _> gib alle Daten aus
              if (snapshot.hasData) {
                List childrenList3 = snapshot.data!.docs;
                childrenList3.sort((a, b) => a['child'].compareTo(b['child']));
                //als Liste wiedergeben
                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 55),
                  itemCount: childrenList3.length,
                  itemBuilder: (context, index) {
                    // individuelle Einträge abholen
                    DocumentSnapshot document = childrenList3[index];
                    String docID = document.id;

                    // Eintrag von jedem Dokument abholen
                    Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                    String childText = data['child'];
                    String anmeldungText = data['anmeldung'];
                    String elternmail = data['eltern'];
                    String shownotification = data['shownotification'];
                    String absenz = data['absenz'];



                    if (absenz == "ja" && data["absenzBis"].toDate().isBefore(DateTime.now()))
                    {
                      FirebaseFirestore.instance
                          .collection("Kinder")
                          .doc(document.id)
                          .update({
                        'absenz': "nein",
                        'anmeldung': "Neprítomná / ý",
                      });
                    }

                    bool istAngemeldet = anmeldungText == "Neprítomná / ý";
                    bool hatAbsenz = absenz == "nein";

                    var color = istAngemeldet ? Colors.white : Theme.of(context).colorScheme.primary;
                    var color2 = istAngemeldet ? Colors.black : Colors.white;
                    var color3 = hatAbsenz ? Colors.transparent : Theme.of(context).colorScheme.secondary;

                    // als List Tile wiedergeben
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChildOverviewPageKita(docID: docID, group: "3"
                          )),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: color3,
                          ),
                          color: color,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.only(left: 5, bottom: 5, right: 5, top: 3),
                        margin: EdgeInsets.only(left: 20, right: 20, top: 10),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 45,
                              child: Column(
                                children: [

                                  if(shownotification == "1")
                                    Container(
                                      child: IconButton(
                                        onPressed: () {
                                          notificationNullKind(docID);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => ChatPage(
                                              receiverID: elternmail, childcode: docID,
                                            )),
                                          );
                                        },
                                        icon:  HugeIcon(
                                          icon: HugeIcons.strokeRoundedMessage01,
                                          color: color2,
                                          size: 20,
                                        ),
                                      ),
                                    ),

                                ],
                              ),
                            ),

                            Column(
                              children: [
                                Text(childText,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: color2),
                                ),
                                const SizedBox(height: 3),
                                Text(anmeldungText,
                                  style: TextStyle(color: color2,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 45,
                              child: IconButton(
                                onPressed: () => openChildBoxGroup(docID, "3"),
                                icon: HugeIcon(
                                  icon: HugeIcons.strokeRoundedUserMultiple02,
                                  color: color2,
                                  size: 20,
                                ),
                              ),
                            )
                          ],
                        ),


                      ),
                    );
                  },
                );
              }
              else {
                return const Text("");
              }
            }
        ),
      ),
    );
  }
}