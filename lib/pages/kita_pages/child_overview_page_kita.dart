

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bubble/pages/chat_page.dart';
import 'package:bubble/pages/kita_pages/raport_page.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:share_plus/share_plus.dart';
import '../../helper/helper_functions.dart';
import '../../database/firestore_child.dart';
import 'einwilligungen_kind_page_kita.dart';
import 'images_page_kita.dart';
import 'infos_eltern_page_kita.dart';
import 'infos_kind_page_kita.dart';





class ChildOverviewPageKita extends StatefulWidget {
  final String docID;
  final String group;


  const ChildOverviewPageKita({
    super.key,
    required this.docID,
    required this.group,
  });

  @override
  State<ChildOverviewPageKita> createState() => _ChildOverviewPageKitaState();
}


class _ChildOverviewPageKitaState extends State<ChildOverviewPageKita> {



  final FirestoreDatabaseChild firestoreDatabaseChild = FirestoreDatabaseChild();

  /// Absenz Meldung

  void openChildBoxAbsenz({String? docID}) {
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
              title: Text("Odstrániť neprítmnosť",
                style: TextStyle(color: Colors.black,
                  fontSize: 20,
                ),
              ),
              content: Text("Je zaznamenaná neprítomnosť, chcete ju odstrániť?"),
              actions: [
                TextButton(
                  onPressed: () {
                    firestoreDatabaseChild.deleteAbsenz(docID!);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RaportPage(docID: widget.docID,)),
                    );
                    setState(()  {});
                  },
                  child: Text("Odstrániť"),

                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Zrušiť"),
                )
              ],
            );
          },
        );
      },

    );
  }





  /// Aktivierungsschlüssel
  void getDocumentID() {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(widget.docID)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        String documentID = document.id;
        if (!mounted) return;
        showDialog(
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
                Text(documentID),
                IconButton(
                  onPressed: () async {
                    await Share.share('Na aktiváciu musíte zadať nasledujúci aktivačný kľúč do svojej aplikácie: $documentID',
                    subject: 'Activationkey',
                        sharePositionOrigin: Rect.fromLTWH(0, 0, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height / 2)
                    );
                    },
                    icon: Icon(Icons.share),
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
            ],
          ),
        );
      } else {
      }
    }).catchError((error) {
    });
  }

  void notificationNullKind(String docID) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(docID)
        .update({"shownotification": "0"});
  }


  void openChildBoxDelete({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(10.0))),
        title: Text("Potvrdiť vymazanie?",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              firestoreDatabaseChild.deleteChild(docID!, widget.group);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Vymazať"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Zrušiť"),
          )
        ],
      ),
    );
  }


  /// ShowButtons

  Widget showButtons () {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        /// Abholzeit
        GestureDetector(
            onTap: () => openChildBoxDelete(docID: widget.docID),
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  Text("Odstrániť dieťa",
                    style: TextStyle(fontFamily: 'Goli'),
                  ),
                  const SizedBox(width: 5),
                  const HugeIcon(
                    icon: HugeIcons.strokeRoundedDelete02,
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
    String currentDate = DateTime.now().toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    //bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
   // var heightList = isIOS ? 0.38 : 0.42;


    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text("Prehľad",
        ),
          actions: [
            showButtons (),
          ]
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: ()

        {
         FirebaseFirestore.instance
            .collection("Kinder")
            .doc(widget.docID,)
            .get()
            .then((DocumentSnapshot document) {
           if (document["absenz"] == "ja") {
             openChildBoxAbsenz(docID: widget.docID);
           }
           else {
             if (context.mounted) {
               Navigator.push(
               context,
               MaterialPageRoute(
                   builder: (context) => RaportPage(docID: widget.docID,)),
             );
             }
           }
         });
        },
        child: HugeIcon(
          icon: HugeIcons.strokeRoundedCalendarAdd01,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),


      body: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: mediaQuery.size.height * 0.09,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child:  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Kinder")
                        .doc(widget.docID)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(

                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold,),
                                snapshot.data!['child']),
                          ],
                        );
                      }
                      return const Text("");
                    },
                  ),
                ),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Kinder")
                      .doc(widget.docID)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final abholzeit = snapshot.data!['abholzeit'];
                      final absenz = snapshot.data!['absenz'];
                      final absenzText = snapshot.data!['absenzText'];
                      final absenzBis = snapshot.data!['anmeldung'];




                      if (absenz == "ja"){

                        return Column(

                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              absenzBis,
                              style: TextStyle(color: Colors.black,
                                fontFamily: 'Goli',
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              absenzText,
                              style: TextStyle(color: Colors.black,
                                fontFamily: 'Goli',
                                fontSize: 10,
                              ),
                            ),
                          ],
                        );
                      }
                      else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              'Čas vyzdvihnutia: $abholzeit',
                              style: TextStyle(color: Colors.black,
                                fontFamily: 'Goli',
                              ),
                            ),
                          ],
                        );
                      }
                    }
                    return const Text("");
                  },
                ),
              ],
            ),
          ),






          //const SizedBox(height: 10),

          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: getDocumentID,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(2, 4),
                          ),
                        ],
                      ),
                      height: 100,
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          HugeIcon(
                            icon: HugeIcons.strokeRoundedKey01,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                           SizedBox(height: 7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Aktivácia",
                          style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),
                if (kIsWeb == false)
                  Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            ImagesPageKita(
                                docID: widget.docID)),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(2, 4),
                        ),
                        ],
                      ),
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          HugeIcon(
                            icon: HugeIcons.strokeRoundedCamera01,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                          SizedBox(height: 7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Fotky",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.inversePrimary,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  flex: 1,
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Kinder")
                          .doc(widget.docID)
                          .snapshots(),
                      builder: (context, snapshot)
                      {
                        if (snapshot.connectionState == ConnectionState.waiting) {

                          return Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(2, 4),
                              ),
                              ],
                            ),
                            height: 100,
                            child:  Column(

                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                HugeIcon(
                                  icon: HugeIcons.strokeRoundedChatting01,
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                ),
                                const SizedBox(height: 7),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Chat",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.inversePrimary,),
                          ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }

                        // ladekreis
                        if (snapshot.hasData) {
                          // Entsprechende Daten extrahieren
                          final userData = snapshot.data?.data() as Map<String, dynamic>;


                          final elternmail = userData["eltern"];
                          String shownotification = userData['shownotification'];

                          if(shownotification == "0") {
                            return GestureDetector(
                            onTap: () {
                              if (elternmail == "")
                                {
                                  displayMessageToUser("Dieťa ešte nebolo pridelené.", context);
                                }
                              else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                      ChatPage(
                                        receiverID: elternmail,
                                        childcode: widget.docID,
                                      )),
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(2, 4),
                                ),
                                ],
                              ),
                              height: 100,
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  HugeIcon(
                                    icon: HugeIcons.strokeRoundedChatting01,
                                    color: Theme.of(context).colorScheme.inversePrimary,
                                  ),
                                   SizedBox(height: 7),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Chat",
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.inversePrimary,),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                          }
                          if(shownotification == "1") {
                            return GestureDetector(
                              onTap: () {
                                notificationNullKind(widget.docID);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ChatPage(
                                    receiverID: elternmail, childcode: widget.docID,
                                  )),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(2, 4),
                                  ),
                                  ],
                                ),
                                height: 100,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    HugeIcon(
                                      icon: HugeIcons.strokeRoundedChatting01,
                                      color: Colors.black
                                    ),
                                    SizedBox(height: 7),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Chat"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                        }
                        return Text("");
                      }
                  ),
                ),
              ],
            ),
          ),




          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            InfosKindPageKita(
                                docID: widget.docID)),
                      );
                    },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(2, 4),
                      ),
                      ],
                    ),
                    height: 100,
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        HugeIcon(
                          icon: HugeIcons.strokeRoundedPassport,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        SizedBox(height: 7),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Informácie",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.inversePrimary,),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            EinwilligungenKindPageKita(
                                docID: widget.docID)),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(2, 4),
                        ),
                        ],
                      ),
                      height: 100,
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          HugeIcon(
                            icon: HugeIcons.strokeRoundedCheckmarkCircle02,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                          SizedBox(height: 7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Povolenia",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.inversePrimary,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            InfosElternPageKita(
                                docID: widget.docID)),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(2, 4),
                        ),
                        ],
                      ),
                    height: 100,
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Icon(Icons.family_restroom_outlined,
                          color: Theme.of(context).colorScheme.inversePrimary,

                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Rodičia",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.inversePrimary,),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(height: 10),
          Flexible(

            child: SizedBox(

                                //height: mediaQuery.size.height * heightList,
                                width: mediaQuery.size.width * 1,
                                child: StreamBuilder<QuerySnapshot>(

                                stream:  FirebaseFirestore.instance
                                    .collection("Kinder")
                                    .doc(widget.docID)
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
                                              padding: EdgeInsets.only(top: 6, bottom: 6, left: 15,),
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
                                              style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(width: 10),
                  if (raport['RaportTitle'] == "Angemeldet")
                  Text(
                      "Prihlásená/ý",
                      style: TextStyle(fontWeight: FontWeight.bold)
                      )
                  else if (raport['RaportTitle'] == "Essen: ")
                    Text(
                        "Strava: ",
                        style: TextStyle(fontWeight: FontWeight.bold)
                    )
                  else if (raport['RaportTitle'] == "Schlaf: ")
                    Text(
                        "Spánok: ",
                        style: TextStyle(fontWeight: FontWeight.bold)
                    )
                  else if (raport['RaportTitle'] == "Aktivität: ")
                    Text(
                        "Aktivity: ",
                        style: TextStyle(fontWeight: FontWeight.bold)
                    )
                  else if (raport['RaportTitle'] == "Diverses: ")
                    Text(
                        "Rôzne: ",
                        style: TextStyle(fontWeight: FontWeight.bold)
                    )
                  else if (raport['RaportTitle'] == "Abgemeldet")
                    Text(
                        "Odhlásená/ý",
                        style: TextStyle(fontWeight: FontWeight.bold)
                    ),
                ],
              ),
            const SizedBox(height: 5),
              if (raport['RaportTitle'] != "Angemeldet" && raport['RaportTitle'] != "Abgemeldet" )
              Row(
                children: [
                  SizedBox(
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
                                      //padding: EdgeInsets.only(bottom: 30),
                                      children: raportWidgets,
                                    );
                                }
                                ),
                              ),
          ),
                      ],
      ),
        );
  }




}
