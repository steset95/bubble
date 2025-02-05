

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';


final currentUser = FirebaseAuth.instance.currentUser;

class CheckMeldung {
  final BuildContext context;

  CheckMeldung(this.context);


  Future<void> checkMeldung() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .get()
        .then((DocumentSnapshot document) async {
      if (document["checkmeldung"] == true) {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser?.email)
            .update({"checkmeldung": false});

        await FirebaseFirestore.instance
            .collection("admin")
            .doc("meldung")
            .get()
            .then((DocumentSnapshot document2) async {
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(
                            Radius.circular(10.0))),
                    title: Text(document2["titel"],
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black,
                        fontSize: 20,

                      ),
                    ),
                    content: SizedBox(
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(document2["content"]),
                          const SizedBox(height: 40),
                          if (document2["link"] != "")
                            GestureDetector(
                              onTap: () async {
                                await launchUrl(
                                    Uri.parse(
                                        document2["link"])); // Add URL which you want here
                                // Navigator.of(context).pushNamed(SignUpScreen.routeName);
                              },
                              child: HugeIcon(
                                icon: HugeIcons.strokeRoundedLinkForward,
                                color: Colors.indigoAccent,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
            );
          }
        });
      }
    });
  }
}