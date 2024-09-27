import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'my_delete_button.dart';


class MyListTileFeedKita extends StatefulWidget {
  final String title;
  final String content;
  final String subTitle;
  final String postId;
  final String feed;
  final bool istNeu;

  const MyListTileFeedKita({
    super.key,
    required this.title,
    required this.content,
    required this.subTitle,
    required this.postId,
    required this.feed,
    required this.istNeu,


  });

  @override
  State<MyListTileFeedKita> createState() => _MyListTileFeedKitaState();
}

class _MyListTileFeedKitaState extends State<MyListTileFeedKita> {

  final CollectionReference users = FirebaseFirestore.instance.collection("Users");
  final CollectionReference posts = FirebaseFirestore.instance.collection("Feed");

  User? user = FirebaseAuth.instance.currentUser;

  void deletePost(String feed) {
    // Bestätigungsdialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Zmazať oznam?",
          style: TextStyle(color: Colors.black,
          fontSize: 20,
        ),
        ),
        actions: [
          //Cancel Button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Zrušiť"),
          ),
          //Löschen bestätigen
          TextButton(
            onPressed: () async{
              FirebaseFirestore.instance
                  .collection("Users")
                  .doc(user!.email)
                  .collection(feed)
                  .doc(widget.postId)
                  .delete();
              Navigator.pop(context);
            },
            child: const Text("Potvrdiť"),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.only(
          left: 10, right: 10, bottom: 10
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
                //border: Border.all(color: Colors.black),
              boxShadow:  [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(2, 4),
            ),
            ],
            ),
            child:
                ListTile(
                  title: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text(
                                textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18,),
                                  widget.title,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: mediaQuery.size.width * 0.82,
                            child: Text(
                              style: TextStyle(fontSize: 12,
                              ),
                                widget.content,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.subTitle,
                      style: TextStyle(
                          fontSize: 8,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      ),
                      IconButton(
                        onPressed: ()  {
                          deletePost(widget.feed);
                        },
                        icon:  HugeIcon(
                            icon: HugeIcons.strokeRoundedDelete02,
                            color: Theme.of(context).colorScheme.primary,
                            size: 12
                        ),
                      ),
                      ],
                    ),
                    ),
                  ),
          if (widget.istNeu == true)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  HugeIcon(
                                    icon: HugeIcons.strokeRoundedSeal,
                                    color: Theme.of(context).colorScheme.secondary,
                                    size: 37,
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
                                    Text("Nové",
                                      style: TextStyle(color: Theme.of(context).colorScheme.secondary,
                                        fontSize: 7,
                                      ),
                                    ),
                                  ]
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
        ],
      ),
    );
  }
}
