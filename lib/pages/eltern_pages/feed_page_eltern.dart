
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bubble/database/firestore_feed.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import '../../components/my_list_tile_feed_eltern.dart';
import '../../helper/check_meldung.dart';
import '../chat_page.dart';
import 'infos_kita_page_eltern.dart';







class FeedPageEltern extends StatefulWidget {
  const FeedPageEltern({super.key});



  @override
  State<FeedPageEltern> createState() => _FeedPageElternState();
}

class _FeedPageElternState extends State<FeedPageEltern> {


  // Zugriff auf Firestore Datenbank
  final FirestoreDatabaseFeed database = FirestoreDatabaseFeed();
  final currentUser = FirebaseAuth.instance.currentUser;



  @override
  void initState() {
    super.initState();
    CheckMeldung(context).checkMeldung();
  }





  void notificationNullEltern() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .update({
      "shownotification": "0",
      "notificationNumber": 0,
    });
  }

  Widget showButtons() {
    return
      StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser?.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data?.data() as Map<String, dynamic>;
              final kitamail = userData["kitamail"];
              final childcode = userData["childcode"];
              final shownotification = userData["shownotification"];
              final notificationNumber = userData["notificationNumber"].toString();
              if (kitamail != "") {
                return Row(
                  mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            InfosKitaPageEltern(
                              kitamail: kitamail,
                            )),
                      );
                    },
                    icon: const  HugeIcon(
                      icon: HugeIcons.strokeRoundedPassport,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (shownotification == "0")
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            ChatPage(
                              receiverID: kitamail, childcode: childcode,
                            )),
                      );
                    },
                    icon:  HugeIcon(
                      icon: HugeIcons.strokeRoundedChatting01,
                      color: Colors.black,
                      ),
                  ),
                  if (shownotification == "1")
                    GestureDetector(
                      onTap: () {

                        notificationNullEltern();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              ChatPage(
                                receiverID: kitamail, childcode: childcode,
                              )),
                        );
                      },
                      child:
                      Row(
                        children: [
                          const SizedBox(width: 11),
                          Stack(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      HugeIcon(
                                        icon: HugeIcons.strokeRoundedChatting01,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 20),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.primary,
                                              borderRadius: BorderRadius.all(Radius.circular(100))
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(notificationNumber,
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
                            ]
                          ),
                        ],
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



  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text("Škôlka",
        ),
        actions: [
          showButtons(),
        ],

      ),
      body:
      Stack(
        children: [
          Column(
            children: [



              ///Kitamail abholen

                  StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
          .collection("Users")
                  .doc(currentUser?.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
              final userData = snapshot.data?.data() as Map<String, dynamic>;
                  if (userData["kitamail"] == "")
              {
                return Text("");
              }

              else {
              final kitamail = userData["kitamail"];

              return

              ///Kita name ausgeben

              StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(kitamail)
                  .snapshots(),
              builder: (context, snapshot) {
              if (snapshot.hasData) {
              final username = snapshot.data!['username'];


              return Column(
                children: [
                  const SizedBox(height: 3,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      HugeIcon(icon: HugeIcons.strokeRoundedRocket, color: Colors.deepPurpleAccent, size: 14),
                      HugeIcon(icon: HugeIcons.strokeRoundedRollerSkate, color: Colors.redAccent, size: 14),
                      HugeIcon(icon: HugeIcons.strokeRoundedToyTrain, color: Colors.black, size: 14),
                      HugeIcon(icon: HugeIcons.strokeRoundedLollipop, color: Colors.red, size: 14),
                      HugeIcon(icon: HugeIcons.strokeRoundedFootball, color: Colors.teal, size: 14),
                      HugeIcon(icon: HugeIcons.strokeRoundedAirplane01, color: Colors.lightBlueAccent, size: 14),
                      HugeIcon(icon: HugeIcons.strokeRoundedMusicNote03, color: Colors.black, size: 14),
                      HugeIcon(icon: HugeIcons.strokeRoundedHotdog, color: Colors.redAccent, size: 14),
                      HugeIcon(icon: HugeIcons.strokeRoundedTree02, color: Colors.green, size: 14),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
          SizedBox(
            width: mediaQuery.size.width * 0.6,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                username,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 25,
                ),
              ),
            ),
          ),
                    ],
                  ),
                  const SizedBox(height: 15),

                ],
              );
              }
              return const Text("");
              },
              );
              }
                   }
                    return Text("");
          }
          ),
              // Textfeld für Benutzereingabe


              StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(currentUser?.email)
                      .snapshots(),
                  builder: (context, snapshot)
                  {
                    if (snapshot.hasData) {
                      final userData = snapshot.data?.data() as Map<String, dynamic>;

                      /// Feed nach KitaMail anzeigen und prüfen ob leer

                      if (userData["kitamail"] != "") {
                        return StreamBuilder(
                            stream: database.getPostsStreamEltern(userData["kitamail"]),
                            builder: (context, snapshot){
                              // Ladekreis anzeigen
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              // get all Posts
                              final posts = snapshot.data!.docs;

                              // no Data?
                              if (snapshot.data == null || posts.isEmpty){
                                return const Center(
                                  child: Padding(
                                      padding: EdgeInsets.all(25),
                                      child: Text("Žiadne záznamy...")
                                  ),
                                );
                              }

                              // Als Liste zurückgeben
                              return Expanded(
                                  child: ListView.builder(
                                      itemCount: posts.length,
                                      itemBuilder: (context, index) {

                                        // Individuelle Posts abholen
                                        final post = posts[index];

                                        // Daten von jedem Post abholen
                                        String title = post['titel'];
                                        String content = post['inhalt'];
                                        Timestamp timestamp = post['TimeStamp'];

                                        final timestampToDateTime = timestamp.toDate();
                                        final timestampNeu = timestampToDateTime.add(Duration(days:2));

                                        bool istNeu = timestampNeu.isBefore(DateTime.now()) == false;

                                        // Liste als Tile wiedergeben
                                        return Column(
                                          children: [
                                            Stack(
                                                children: [
                                                  MyListTileFeedEltern(
                                                    content: content,
                                                    title: title,
                                                    subTitle: DateFormat('dd.MM.yyyy').format(timestamp.toDate()),
                                                    postId: post.id,
                                                    istNeu: istNeu,
                                                  ),
                                                ]
                                            ),
                                          ],
                                        );
                                      }
                                  )
                              );
                            }
                        );
                      }
                      else {
                        Text("Žiadne dieťa ešte nie je zaregistrované...");
                      }
                    }

                    if (snapshot.connectionState != ConnectionState.waiting) {
                      return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.all(25),
                            child: Text("Žiadne záznamy..."

                            )
                        ),
                      ],
                    );
                    } else {
                      return
                        Text("");
                    }
                  }
              ),

            ],
          ),
        ],
      ),
    );
  }
}