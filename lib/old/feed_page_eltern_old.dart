/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bubble/database/firestore_feed.dart';
import 'package:intl/intl.dart';

import '../../components/my_list_tile_feed_eltern.dart';
import '../../components/my_profile_data_read_only.dart';
import '../chat_page.dart';
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



  void getKitaInfos() {
    final mediaQuery = MediaQuery.of(context);
    FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .get()
        .then((DocumentSnapshot document) {
      final kitamail = document["kitamail"];
      if (document["kitamail"] != "")
      {
        return showDialog(

          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              "Kita Infos",
              textAlign: TextAlign.center,
            ),
            content: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(kitamail)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final username = snapshot.data!['username'];
                  final adress = snapshot.data!['adress'];
                  final adress2 = snapshot.data!['adress2'];
                  final tel = snapshot.data!['tel'];

                  return
                    SingleChildScrollView(
                      child: Column(
                      children: [
                        ProfileDataReadOnly(
                          text: username,
                          sectionName: "Name",
                        ),
                        ProfileDataReadOnly(
                          text: adress,
                          sectionName: "Adresse",
                        ),
                        ProfileDataReadOnly(
                          text: adress2,
                          sectionName: "Ort",
                        ),
                        ProfileDataReadOnly(
                          text: tel,
                          sectionName: "Telefonnummer",
                        ),
                      ],
                                            ),
                    );
                };
                return const Text("");
              },
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
        return Text("Noch kein Kind registriert...");
      }
    }).catchError((error) {
      print('Fehler beim Abrufen des Dokuments: $error');
    });
  }










  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.black,
            height: 2.0,
          ),
        ),
        title: Text("Feed",
          style: TextStyle(color:Colors.black),
        ),
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
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InfosKitaPageEltern(
                kitamail: kitamail,
              )),
            );
          },
          child: Container(
            width: mediaQuery.size.width * 0.2,
            height: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info,
                color: Theme.of(context).colorScheme.inversePrimary,
                ),
                const SizedBox(height: 5,),
                Text("Infos",
                    style: TextStyle(color:Theme.of(context).colorScheme.inversePrimary,),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: mediaQuery.size.width * 0.5,
          child: Text(
              username,
            textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25,),
          ),
        ),

        GestureDetector(
          onTap: () {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatPage(
          receiverID: kitamail,
          )),
          );
          },
          child: Container(
            width: mediaQuery.size.width * 0.2,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                const SizedBox(height: 5,),
                Text("Chat",
                  style: TextStyle(color:Theme.of(context).colorScheme.inversePrimary,),
                ),
              ],
            ),
          ),
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
                                // get all Posts
                                final posts = snapshot.data!.docs;

                                // no Data?
                                if (snapshot.data == null || posts.isEmpty){
                                  return const Center(
                                    child: Padding(
                                        padding: EdgeInsets.all(25),
                                        child: Text("Noch keine Einträge vorhanden...")
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
                        else Text("Noch kein Kind registriert...");
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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





              ],
            ),
        ],
      ),
    );
  }
}*/