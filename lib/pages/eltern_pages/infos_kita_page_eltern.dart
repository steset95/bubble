
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../components/my_profile_data_icon.dart';
import '../../components/my_profile_data.dart';
import '../../components/my_profile_data_read_only.dart';
import '../../helper/notification_controller.dart';
import 'package:url_launcher/url_launcher.dart';






class InfosKitaPageEltern extends StatefulWidget {
  final String kitamail;

  InfosKitaPageEltern({
    super.key,
    required this.kitamail
  });



  @override
  State<InfosKitaPageEltern> createState() => _InfosKitaPageElternState();
}

class _InfosKitaPageElternState extends State<InfosKitaPageEltern> {


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
          title: Text("Informácie o škôlke",

          ),
        ),
      body: SingleChildScrollView(
        child:
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(widget.kitamail)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final username = snapshot.data!['username'];
              final adress = snapshot.data!['adress'];
              final adress2 = snapshot.data!['adress2'];
              final beschreibung = snapshot.data!['beschreibung'];
              final tel = snapshot.data!['tel'];

              return
                SingleChildScrollView(
                  child: Column(
                    children: [
                      ProfileDataReadOnly(
                        text: username,
                        sectionName: "Názov",
                      ),
                      ProfileDataReadOnly(
                        text: adress,
                        sectionName: "Adresa",
                      ),
                      ProfileDataReadOnly(
                        text: adress2,
                        sectionName: "PSČ, Mesto",
                      ),
                      MyProfileDataIcon(
                        text: tel,
                        sectionName: "Telefónne číslo",
                        onPressed: () => setState(() {
                          _makePhoneCall(tel);
                        }),
                        icon:  Icons.call_outlined,
                      ),
                      ProfileDataReadOnly(
                        text: beschreibung,
                        sectionName: "Ďalšie informácie",
                      ),
                    ],
                  ),
                );
            };
            return const Text("");
          },


        ),
        )
    );
    }
    }






