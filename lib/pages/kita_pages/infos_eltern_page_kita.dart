
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../components/my_profile_data_icon.dart';
import '../../components/my_profile_data_read_only.dart';







class InfosElternPageKita extends StatefulWidget {
  final String docID;

  InfosElternPageKita({
    super.key,
    required this.docID
  });



  @override
  State<InfosElternPageKita> createState() => _InfosElternPageKitaState();
}

class _InfosElternPageKitaState extends State<InfosElternPageKita> {


  final currentUser = FirebaseAuth.instance.currentUser;


  final kinderCollection = FirebaseFirestore
      .instance
      .collection("Kinder"
  );




  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text("Rodičia",
          ),
        ),
      body: SingleChildScrollView(
        child:
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Kinder")
                .doc(widget.docID)
                .snapshots(),
            builder: (context, snapshot)
            {
              // ladekreis
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              // Fehlermeldung
              else if (snapshot.hasError) {
                return Text("Error ${snapshot.error}");
              }
              // Daten abfragen funktioniert
              else if (snapshot.hasData) {
            // Entsprechende Daten extrahieren
            final userData = snapshot.data?.data() as Map<String, dynamic>;

            if (userData["eltern"] == "")
            {
            return Column(
              children: [
                SizedBox(
                  height: 50,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Dieťa ešte nebolo pridelené."),
                  ],
                ),
              ],
            );
            }

          else {
            final elternmail = userData["eltern"];

            // Inhalt Daten

            return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(elternmail)
                .snapshots(),
            builder: (context, snapshot) {
            if (snapshot.hasData) {
            final username = snapshot.data!['username'];
            final adress = snapshot.data!['adress'];
            final adress2 = snapshot.data!['adress2'];
            final tel = snapshot.data!['tel'];
            final email = snapshot.data!['email'];

            return
            SingleChildScrollView(
            child: Column(
            children: [
              const SizedBox(height: 30,),
              HugeIcon(icon: HugeIcons.strokeRoundedNote, color: Colors.black, size: 30),
              const SizedBox(height: 10,),
              Container(
                child: Text(username,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 10,),
            ProfileDataReadOnly(
            text: adress,
            sectionName: "Ulica / Číslo",
            ),
            ProfileDataReadOnly(
            text: adress2,
            sectionName: "PSČ / Mesto",
            ),
              MyProfileDataIcon(
                text: tel,
                sectionName: "Mobilné číslo",
                onPressed: () => setState(() {
                  _makePhoneCall(tel);
                }),
                icon: Icons.call_outlined,
              ),
              ProfileDataReadOnly(
                text: email,
                sectionName: "Email",
              ),
            ],
            ),
            );
            };
            return const Text("");
            },
            );
            }
                // Fehlermeldung wenn nichts vorhanden ist
              } else {
                return const Text("No Data");
              }
              return Text("");
            },
        )
        )
    );
    }
    }






