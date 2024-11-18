import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';





class MyListTileFeedEltern extends StatefulWidget {
  final String title;
  final String subTitle;
  final String postId;
  final String content;
  final bool istNeu;


  const MyListTileFeedEltern({
    super.key,
    required this.title,
    required this.subTitle,
    required this.postId,
    required this.content,
    required this.istNeu,


  });

  @override
  State<MyListTileFeedEltern> createState() => _MyListTileFeedElternState();
}

class _MyListTileFeedElternState extends State<MyListTileFeedEltern> {

  final CollectionReference users = FirebaseFirestore.instance.collection("Users");
  final CollectionReference posts = FirebaseFirestore.instance.collection("Feed");

  User? user = FirebaseAuth.instance.currentUser;



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
                borderRadius: BorderRadius.circular(10),
                //border: Border.all(color: Colors.black),
              color: Colors.white,

              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
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
                            style: TextStyle(fontSize: 18,

                            ),
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
                      SizedBox(
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
              subtitle: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(widget.subTitle,
                        style: TextStyle(
                          fontSize: 8,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
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
                  SizedBox(
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
