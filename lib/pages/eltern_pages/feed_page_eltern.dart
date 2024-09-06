
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bubble/database/firestore_feed.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import '../../components/my_list_tile_feed_eltern.dart';
import '../../components/my_profile_data_read_only.dart';
import '../../helper/notification_controller.dart';
import '../../helper/abo_controller.dart';
import '../chat_page.dart';
import 'addkind_page_eltern.dart';
import 'bezahlung_page_eltern.dart';
import 'infos_kita_page_eltern.dart';







class FeedPageEltern extends StatefulWidget {
  FeedPageEltern({super.key});



  @override
  State<FeedPageEltern> createState() => _FeedPageElternState();
}

class _FeedPageElternState extends State<FeedPageEltern> {


  // Zugriff auf Firestore Datenbank
  final FirestoreDatabaseFeed database = FirestoreDatabaseFeed();
  final currentUser = FirebaseAuth.instance.currentUser;


  /// Notification
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => NotificationController().notificationCheck());
    configureSDK();
    Future.delayed(Duration(milliseconds: 20000), () {
      aboCheck();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  /// Notification

  void notificationNullEltern() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .update({"shownotification": "0"});
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
                  if (shownotification == "0" && userData["abo"] != "inaktiv")
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
                  if (shownotification == "1" && userData["abo"] != "inaktiv")
                    IconButton(
                      onPressed: () {

                        notificationNullEltern();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              ChatPage(
                                receiverID: kitamail, childcode: childcode,
                              )),
                        );
                      },
                      icon:  Icon(Icons.mark_unread_chat_alt_outlined,
                        color: Theme.of(context).colorScheme.primary,
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

                const SizedBox(height: 30,),

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


    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
            username,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
            ),
              ],
    );
    };
    return const Text("");
    },
    );
    }
         }
          return Text("");
            }
            ),
                // Textfeld für Benutzereingabe


                const SizedBox(height: 20),

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
                                /// Payment Check
                                if (userData["abo"] == "inaktiv")
                                  {
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
                                                        BezahlungPage(isActive: false, text: "Zur Vollversion"),
                                                    ),
                                                  );
                                                },
                                                child: Column(
                                                  children: [
                                                    Text("Obnovte si prosím predplatné",
                                                      style: TextStyle(fontSize: 20),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        HugeIcon(
                                                          icon: HugeIcons.strokeRoundedCreditCardPos,
                                                          color: Theme.of(context).colorScheme.primary,
                                                          size: 50,
                                                        ),
                                                        Icon(
                                                            Icons.arrow_forward,
                                                            color: Theme.of(context).colorScheme.primary,
                                                            size: 20
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
                                /// Payment Check

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
                        else Text("Žiadne dieťa ešte nie je zaregistrované...");
                      }

                      if (snapshot.connectionState != ConnectionState.waiting)

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
                      else
                        return
                          Text("");
                    }
                ),

              ],
            ),
        ],
      ),
    );
  }
}