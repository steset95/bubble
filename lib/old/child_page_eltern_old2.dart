/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/database/firestore_child.dart';
import 'package:socialmediaapp/pages/eltern_pages/images_page_eltern.dart';
import '../../components/my_image_upload_button_profile.dart';
import '../../components/my_image_viewer_profile.dart';
import '../../helper/helper_functions.dart';
import '../chat_page.dart';
import '../../old/einwilligungen_kind_page_eltern.dart';
import 'infos_kind_page_eltern.dart';
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

  final _raportTextController = TextEditingController();

  void addRaport(String field, String value, String childcode) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(childcode)
        .update({
      field: value,
      'timestamp': Timestamp.now(),
    });
  }






  void showRaportDialogAbsenz(String childcode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Absenz bis:"),
        content: TextField (
          maxLength: 5,
          keyboardType: TextInputType.number,
          controller: _raportTextController,
          decoration: InputDecoration(hintText: "TT.MM"),
        ),
        actions: [
          // cancel Button
          TextButton(
            onPressed: () {
              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Zrušiť"),
          ),

          // save Button
          TextButton(
            onPressed: () {
              final value = _raportTextController.text;
              // Raport hinzufügen
              addRaport("anmeldung", 'Absenz bis $value', childcode);
              // Textfeld schliessen
              Navigator.pop(context);
              return displayMessageToUser("Absenz wurde eingetragen.", context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Uložiť"),
          ),
        ],
      ),
    );
  }



  // Raport hinzufügen bzw. Allgemeiner Firebase Connect
  void addRaportAbholzeit(String abholzeit, String childcode) {
    String currentDate = DateTime.now().toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    // in Firestore Uložiť und "Raports" unter "Kinder" erstellen
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
        // Text Eingabe
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
            child: Text("Abholzeit bestätigen"),
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


  Future<List<String>> getImagePath(String childcode, ) async {
    String currentDate = DateTime.now().subtract(Duration(days:_counter)).toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    ListResult result =
    await FirebaseStorage.instance.ref('/images/$formattedDate/$childcode').listAll();
    return await Future.wait(
      result.items.map((e) async => await e.getDownloadURL()),
    );
  }

  Widget buildGallery(String childcode) {
    String currentDate = DateTime.now().subtract(Duration(days:_counter)).toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    final mediaQuery = MediaQuery.of(context);
    return FutureBuilder(
      future: getImagePath(childcode),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        return Container(
          width: 300,
          height: mediaQuery.size.height * 0.25,
          child: GridView.builder(
            scrollDirection: Axis.vertical,
            physics: const PageScrollPhysics(),
            itemCount: snapshot.data!.length,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
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
              child: Image.network(
                snapshot.data![index],
                fit: BoxFit.fitHeight,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child; Text("");
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
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
              icon: const Icon(Icons.timer,
              ),
            ),


            /// Absenzmeldung

            IconButton(
              onPressed: () => showRaportDialogAbsenz(childcode),
              icon: const Icon(Icons.sick_outlined,
              ),
            ),
            const SizedBox(width: 10),
                      ],
        );
      }
    }
   return Text("");
      }
    );


  }



/// Start Widget


  @override
  Widget build(BuildContext context)  {
    String currentDate = DateTime.now().subtract(Duration(days:_counter)).toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Colors.black,
              height: 2.0,
            ),
          ),
          title: Text("Tagesraport",
            style: TextStyle(color:Colors.black),
          ),
          actions: [
            showButtons(),
          ],
        ),
      
        body: SingleChildScrollView (
    child:
        StreamBuilder<DocumentSnapshot>(
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
            return Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  height: mediaQuery.size.height * 0.15,
                  color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [


                      /// Abholzeit


                      GestureDetector(
                        onTap:() => openChildBoxAbholzeit(childcode: childcode),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                             Icon(Icons.timer,
                               color: Theme.of(context).colorScheme.inversePrimary,
                             ),
                              const SizedBox(height: 5),
                              Text("Abholzeit",
                                style: TextStyle(color:Theme.of(context).colorScheme.inversePrimary,),
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// Profilbild
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Stack(
                                  children: [
                                    ImageViewerProfile(childcode: childcode),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ImageUploadProfile(childcode: childcode),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),

                      ),

                      /// Absenzmeldung


                      GestureDetector(
                        onTap: () => showRaportDialogAbsenz(childcode),
                        child: Container(
                          width: mediaQuery.size.width * 0.2,
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                             Icon(Icons.sick_outlined,
                               color: Theme.of(context).colorScheme.inversePrimary,
                             ),
                              const SizedBox(height: 5),
                              Text("Absenz",
                                style: TextStyle(color:Theme.of(context).colorScheme.inversePrimary,),
                              ),
                            ],
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: mediaQuery.size.height * 0.3,
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
                                          padding: const EdgeInsets.all(6.0),
                                          child: Container(
                                            padding: EdgeInsets.all(5),

                                            width: mediaQuery.size.width * 0.9,
                                            color: Colors.pinkAccent.withOpacity(0.3),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                        raport['Uhrzeit'],
                                                        style: TextStyle(fontWeight: FontWeight.bold)
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                        raport['RaportTitle']),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Container(
                                                        width: mediaQuery.size.width * 0.85,
                                                        child: Text(
                                                            textAlign: TextAlign.left,
                                                            raport['RaportText'])),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

                                        ),
                                      ],
                                    );
                                    raportWidgets.add(raportWidget);
                                    Text(raport['RaportText']);
                                  }

                                }
                                return
                                  ListView(
                                    children: raportWidgets,
                                  );
                              }
                          ),
                        ),
                                        ],
                    ),
                  ],
                ),
      
                /// Galerie
      
                const SizedBox(height: 20),
      
                buildGallery(childcode),
      
                const SizedBox(height: 20),
      
                /// Datum wählen
      
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _incrementCounterMinus,
                      child: Container(
                        width: 40,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Icon(Icons.arrow_back,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
      
                    Text(formattedDate),
      
                    const SizedBox(width: 20),
      
                    GestureDetector(
                      onTap: _incrementCounterPlus,
                      child: Container(
                        width: 40,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Icon(Icons.arrow_forward,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            );
          }
        }
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 71),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Bitte Kind hinzufügen",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ],
        );
      }
        ),
        ),
        ),
    );

                }
            }
*/