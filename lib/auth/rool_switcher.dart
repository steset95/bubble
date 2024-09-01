import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/auth/login_or_register.dart';

import 'package:socialmediaapp/pages/kita_pages/home_page_kita.dart';
import 'package:socialmediaapp/pages/kita_pages/profile_page_kita.dart';
import '../pages/eltern_pages/home_page_eltern.dart';


class RoolSwitcher extends StatefulWidget {
  RoolSwitcher({super.key});

  @override
  State<RoolSwitcher> createState() => _RoolSwitcherState();
}

class _RoolSwitcherState extends State<RoolSwitcher> {

  final currentUser = FirebaseAuth.instance.currentUser;


  // Referenz zu "Users" Datenbank
  final usersCollection = FirebaseFirestore
      .instance
      .collection("Users"
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Benutzer ist eingeloggt
          if (snapshot.hasData) {


            return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(currentUser?.email)
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

                    // Inhalt Daten
                    if (userData["rool"] == "Eltern") {
                      return
                        HomePageEltern();
                    }
                    else {
                      return HomePageKita();
                    }

                  } else {
                    return Text('Error');
                  }
                }

            );
          }
          // Benutzer ist NICHT eingeloggt

          else {
            return const LoginOrRegister();
          }
          return LoginOrRegister();
        },

      ),
    );
  }
}