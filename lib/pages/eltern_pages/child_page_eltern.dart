import 'dart:async';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/database/firestore_child.dart';
import 'package:socialmediaapp/pages/eltern_pages/images_page_eltern.dart';
import '../../components/my_progressindicator.dart';
import '../../components/notification_controller.dart';
import 'package:intl/intl.dart';
import '../../helper/helper_functions.dart';

import 'addkind_page_eltern.dart';
import 'bezahlung_page_eltern.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class ChildPageEltern extends StatefulWidget {

  ChildPageEltern({super.key});

  @override
  State<ChildPageEltern> createState() => _ChildPageElternState();
}



class _ChildPageElternState extends State<ChildPageEltern> {

  // Verweis auf FirestoreDatabaseChild

  final FirestoreDatabaseChild firestoreDatabaseChild = FirestoreDatabaseChild();

  // Text Controller für Abfrage des Inhalts im Textfeld

  final TextEditingController textController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  /// Notification
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) =>
        NotificationController().notificationCheck());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  /// Notification


  var optionsAbholzeit = [
    '07:00',
    '07:30',
    '08:00',
    '08:30',
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '12:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
    '18:30',
    '19:00',
    '19:30',
    '20:00',
  ];

  var _currentItemSelectedAbholzeit = '17:00';
  var abholzeit = '';


  bool showProgress = false;
  bool visible = false;


  final _bemerkungTextController = TextEditingController();

  void addRaport(String field, String value, String childcode) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(childcode)
        .update({
      field: value,
    });
  }

  void addRaportDate(String field, DateTime value, String childcode) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(childcode)
        .update({
      field: value,
      'timestamp': Timestamp.now(),
    });
  }


  DateTime date = DateTime.now();

  DateTime dateAbsenz = DateTime.now().add(Duration(days:7));
  late var formattedDateAbsenz = DateFormat('d-MMM-yy').format(dateAbsenz);
  DateTime absenzBis = DateTime.now().add(const Duration(days:7));



  void showRaportDialogAbsenz(String childcode) {
  showDialog(
  context: context,
  builder: (context) {
  return StatefulBuilder(
  builder: (context, setState) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.all(
            Radius.circular(10.0))),
    title: Text("Absenz",
      style: TextStyle(color: Colors.black,
        fontSize: 20,
      ),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Bis: $formattedDateAbsenz',
              style: TextStyle(
                fontSize: 18,
              ),
            ),

            IconButton(
                icon: Icon(Icons.calendar_today,
color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () async {
                  DateTime? _newDate = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2030),
                  );
                  if (_newDate == null) {
                    return;
                  } else {
                    formattedDateAbsenz = DateFormat('d-MMM-yy').format(_newDate);
                    absenzBis = _newDate;
                    setState(()  {});
                  };
                }
            ),

          ],
        ),

        TextFormField (
          maxLength: 50,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 3,
          autofocus: true,
          controller: _bemerkungTextController,
          decoration: InputDecoration(hintText: "Bemerkung",
          ),
        ),
      ],
    ),

    actions: [
      // cancel Button
      TextButton(
        child: Text("Abbrechen"),
        onPressed: () {
          // Textfeld schliessen
          Navigator.pop(context);
          //Textfeld leeren
          _bemerkungTextController.clear();
        },

      ),

      // save Button
      TextButton(
        child: Text("Speichern"),
        onPressed: () {
          final value2 = _bemerkungTextController.text;
          final absenzBis24 = absenzBis.copyWith(hour:23, minute: 59);


          // Raport hinzufügen

            addRaport("anmeldung", 'Absenz bis $formattedDateAbsenz', childcode);
            addRaport("absenzText", value2, childcode);
          addRaportDate("absenzBis", absenzBis24, childcode);
            addRaport("absenz", "ja", childcode);
            // Textfeld schliessen
            Navigator.pop(context);
          _bemerkungTextController.clear();

            return displayMessageToUser(
                "Absenz wurde eingetragen.", context);

        },

      ),
    ],
  );
  },
  );
  },

  );
}




  // Raport hinzufügen bzw. Allgemeiner Firebase Connect
  void addRaportAbholzeit(String abholzeit, String childcode) {
    String currentDate = DateTime.now().toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    // in Firestore speichern und "Raports" unter "Kinder" erstellen
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(childcode)
        .collection(formattedDate)
        .doc("abholzeit")
        .set({
      "Abholzeit" : abholzeit,
    });
  }



  void openChildBoxAbholzeit({String? childcode}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(10.0))),
        title: Text("Abholzeit",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        content: DropdownButtonFormField<String>(
          isDense: true,
          isExpanded: false,

          items: optionsAbholzeit.map((String dropDownStringItem) {
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
          value: _currentItemSelectedAbholzeit, onChanged: (newValueSelected) {
          setState(() {
            _currentItemSelectedAbholzeit = newValueSelected!;
            abholzeit = newValueSelected;
          });
        },
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _bemerkungTextController.clear();
            },
            child: Text("Abbrechen"),
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
                addRaport("abholzeit", _currentItemSelectedAbholzeit, childcode);
              }
              //Box schliessen
              Navigator.pop(context);
              return displayMessageToUser("Abholzeit wurde eingetragen.", context);
            },
            child: Text("Speichern"),
          )
        ],
      ),
    );
  }



  int _counter = 0;

  void _incrementCounterMinus() {
    setState(() {
      _counter++;
    });
  }

  void _incrementCounterPlus() {
    setState(() {
      _counter--;
    });
  }


  Future<List<String>> getImagePath(String childcode, DateTime date) async {
    String currentDate = date.toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    ListResult result =
    await FirebaseStorage.instance.ref('/images/$formattedDate/$childcode').listAll();
    return await Future.wait(
      result.items.map((e) async => await e.getDownloadURL()),
    );
  }

  Widget buildGallery(String childcode, DateTime date) {
    String currentDate = date.toString();// Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    final mediaQuery = MediaQuery.of(context);
    return FutureBuilder(
      future: getImagePath(childcode, date),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return const Text("");
        }
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.length,
          shrinkWrap: false,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            childAspectRatio: 1.0,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          ),
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ImagesPageEltern(
                  childcode: childcode, date: formattedDate,
                )),
              );
            },
            child: CachedNetworkImage(
              imageUrl: snapshot.data![index],
              fit: BoxFit.fitHeight,
              placeholder: (context, url) => ProgressWithIcon(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        );
      },
    );
  }







  /// Kita Mail in User hinzufügen

  void getKitaEmail(String childID) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(childID)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        String kita = document["kita"];
        FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser?.email)
            .update({
          "kitamail" : kita,
      });
            }
    });
  }



  Widget showButtons () {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser?.email)
            .snapshots(),
      builder: (context, snapshot) {
    if (snapshot.hasData) {
      final userData = snapshot.data?.data() as Map<String, dynamic>;
      final childcode = userData["childcode"];
      if (snapshot.hasData && childcode != "") {
        getKitaEmail(userData["childcode"]);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [


            /// Abholzeit
            IconButton(
              onPressed: () => openChildBoxAbholzeit(childcode: childcode),
              icon: const Icon(Icons.watch_later_outlined,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 10),

            /// Absenzmeldung

            IconButton(
              onPressed: () => showRaportDialogAbsenz(childcode),
              icon: const Icon(Icons.beach_access_outlined,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 15),
                      ],
        );
      }
    }
   return Text("");
      }
    );


  }


  Future<void> showRaportDialogDatum(BuildContext context, DateTime currentDate1) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: currentDate1,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
        _counter = 0;
      });
    }
  }




  /// Start Widget


  @override
  Widget build(BuildContext context)  {
    final currentDate1 = date.subtract(Duration(days:_counter));
    final String currentDate2 = currentDate1.toString(); // Aktuelles Datum als String
    final String formattedDate = currentDate2.substring(0, 10);
    final String showDatum = DateFormat('d-MMM-yy').format(currentDate1);
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text("Tagesraport",
          ),
          actions: [
            showButtons(),
          ],
        ),

        body: StreamBuilder<DocumentSnapshot>(
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
            getKitaEmail(userData["childcode"]);
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [

                const SizedBox(height: 10),
                Flexible(
                  flex: 1,
                    child: buildGallery(childcode, currentDate1)),
                const SizedBox(height: 10),
                Flexible(
                  flex: 9,
                  child: Container(
                   // height: mediaQuery.size.height * 0.55,
                    width: mediaQuery.size.width * 1,
                    child: StreamBuilder<QuerySnapshot>(
                        stream:  FirebaseFirestore.instance
                            .collection("Kinder")
                            .doc(childcode)
                            .collection(formattedDate)
                            .orderBy('TimeStamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          List<Row> raportWidgets = [];
                          if (snapshot.hasData) {
                            final raports = snapshot.data?.docs.reversed.toList();
                            for (var raport in raports!) {
                              final raportWidget = Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Container(
                                    padding: EdgeInsets.only(top: 8, bottom: 8, left: 15,),
                                    decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.inversePrimary,
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
                                      width: mediaQuery.size.width * 0.9,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                  raport['Uhrzeit'],
                                                  style: TextStyle(fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                    color: Theme.of(context).colorScheme.primary,
                                                  )
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                  raport['RaportTitle'],
                                                style: TextStyle(fontWeight: FontWeight.bold,
                                                  color: Theme.of(context).colorScheme.primary,
                                                fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Container(
                                                  width: mediaQuery.size.width * 0.80,
                                                  child: Text(
                                                      textAlign: TextAlign.left,
                                                      raport['RaportText'],
                                                    style: TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                  ),
                                ],
                              );
                              raportWidgets.add(raportWidget);
                             // Text(raport['RaportText']);
                            }
                          }
                          if (raportWidgets.isNotEmpty) {
                            return
                            ListView(
                              children: raportWidgets,
                            );
                          }
                          else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Noch keine Einträge..."
                                ),
                              ],
                            );
                          }
                        }
                    ),
                  ),
                ),



                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5.0,),
                    child: Column(
                      children: [

                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: _incrementCounterMinus,
                              child: Container(
                                width: 50,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Icon(Icons.arrow_back_ios_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap:  ()  {
                                showRaportDialogDatum(context, currentDate1);

                              },
                              child: Text(showDatum,
                                textAlign: TextAlign.center,
                                style: TextStyle( fontFamily: 'Goli',
                                  color: Theme.of(context).colorScheme.primary,
                                ),

                              ),
                            ),
                            GestureDetector(
                              onTap: _incrementCounterPlus,
                              child: Container(
                                width: 50,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Icon(Icons.arrow_forward_ios_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        }
        if (snapshot.connectionState != ConnectionState.waiting) {
          return Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
        } else
                return
                Text("");
              }
        ),
        ),
    );

                }
            }
