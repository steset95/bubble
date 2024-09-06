import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bubble/components/my_list_tile_feed_kita.dart';
import 'package:bubble/database/firestore_feed.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:bubble/pages/kita_pages/post_page_kita.dart';

import '../../helper/notification_controller.dart';
import '../../helper/helper_functions.dart';


class FeedPageKita extends StatefulWidget {
  FeedPageKita({super.key});


  @override
  State<FeedPageKita> createState() => _FeedPageKitaState();
}

class _FeedPageKitaState extends State<FeedPageKita> {


  // Zugriff auf Firestore Datenbank
  final FirestoreDatabaseFeed database = FirestoreDatabaseFeed();


  // Text Controller
  final TextEditingController newPostControllerTitel = TextEditingController();
  final TextEditingController newPostControllerInhalt = TextEditingController();


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


  // Methode: Nachricht Posten Extern
  void postMessageExt(){
    // Nur Posten wenn etwas im Textfeld ist
    if (newPostControllerInhalt.text.isNotEmpty){
      String title = newPostControllerTitel.text;
      String content = newPostControllerInhalt.text;
      database.addPostExt(title, content);
    }
    // Eingabefeld nach Eingabe leeren
    newPostControllerInhalt.clear();
    newPostControllerTitel.clear();
  }


  // Methode: Nachricht Posten Intern
  void postMessageInt(){
    // Nur Posten wenn etwas im Textfeld ist
    if (newPostControllerInhalt.text.isNotEmpty){
      String title = newPostControllerTitel.text;
      String content = newPostControllerInhalt.text;
      database.addPostInt(title, content);
    }
    // Eingabefeld nach Eingabe leeren
    newPostControllerInhalt.clear();
    newPostControllerTitel.clear();
  }

bool externPost = false;


  Widget showButtons () {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        /// Abholzeit
        GestureDetector(
            onTap: () => setState(() => externPost = !externPost),
            child: Row(
              children: [
                Text("Zmeniť násťenku",
                  style: TextStyle(fontFamily: 'Goli'),
                ),
                const SizedBox(width: 5),
                const HugeIcon(
                    icon: HugeIcons.strokeRoundedExchange01,
                    color: Colors.black,
                ),
              ],
            )
        ),

        const SizedBox(width: 20),
      ],
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text("Nástenka",
        ),
        actions: [
          showButtons ()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed:  () {
          if (externPost == true) {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                PostPageKita(externPost: externPost, umgebung: "Nový externý oznam")),
          );
          }
          else
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
              PostPageKita(externPost: externPost, umgebung: "Nový interný oznam")),
            );
        },
        child: HugeIcon(
          icon: HugeIcons.strokeRoundedPencilEdit01,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
        body:
        Container(

          child: Stack(
            children: [

              if (externPost)
                /// Externer Feed
              Column(
                children: [
                  const SizedBox(height: 30,),
                  Text(
                    "Externá nástenka",
                    style: TextStyle(fontSize: 25,
                    color: Colors.black,
                        fontFamily: 'Goli',
                    ),
                  ),


                  const SizedBox(height: 20,),
                  StreamBuilder(
                      stream: database.getPostsStreamExt(),
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

                                // Liste als Tile wiedergeben
                                return Column(
                                  children: [
                                    Stack(
                                      children: [
                                        MyListTileFeedKita(
                                            title: title,
                                            content: content,
                                            subTitle: DateFormat('dd.MM.yyyy').format(timestamp.toDate()),
                                            postId: post.id,
                                            feed: "Feed_Extern"
                                      ),
                                      ]
                                    ),
                                  ],
                                );
                              }
                            )
                        );
                  }
                  ),
                ],
              ),

              /// Feed Intern
              if (externPost != true)
              Column(

                children: [
                  const SizedBox(height: 30,),
                  Text(
                    "Interná násťenka",
                    style: TextStyle(fontSize: 25,
                      color: Colors.black,
                      fontFamily: 'Goli',
                    ),
                  ),


                  const SizedBox(height: 20,),


                  // Posts
                  StreamBuilder(
                      stream: database.getPostsStreamInt(),
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

                                  // Liste als Tile wiedergeben
                                  return Column(
                                    children: [
                                      Stack(
                                          children: [
                                            MyListTileFeedKita(
                                              title: title,
                                              content: content,
                                              subTitle: DateFormat('dd.MM.yyyy').format(timestamp.toDate()),
                                              postId: post.id,
                                                feed: "Feed_Intern"
                                            ),
                                          ]
                                      ),
                                    ],
                                  );
                                }
                            )
                        );
                      }
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}