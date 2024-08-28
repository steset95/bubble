/*
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pay/pay.dart';
import 'package:socialmediaapp/components/my_profile_data.dart';
import 'package:socialmediaapp/assets/payment_configurations.dart' as payment_configurations;

import '../assets/payment_configurations.dart';

// Pay Package
const _paymentItems = [
  PaymentItem(
    label: 'Total',
    amount: '99.99',
    status: PaymentItemStatus.final_price,
  )
];
///////// Pay Package

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});


  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  ///////// Pay Package
  final Future<PaymentConfiguration> _googlePayConfigFuture =
  PaymentConfiguration.fromAsset('google_pay_config.json');

 */
/*
  final Future<PaymentConfiguration> _applePayConfigFuture =
  PaymentConfiguration.fromAsset('apple_pay_config.json');


  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  void onApplePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }


  ///////// Pay Package


  // festlegen dass es um den aktuell eingeloggten User geht
  final User? currentUser = FirebaseAuth.instance.currentUser;


  /// Unnötig?
/*

  // Future zum User Attribute abfragen, Dokument = Users (in register_page erstellt)
 Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
   return await FirebaseFirestore.instance
       .collection("Users")
       .doc(currentUser!.email)
       .get();
 }
*/
  /// Unnötig?


  // Referenz zu "Users" Datenbank
  final usersCollection = FirebaseFirestore
      .instance
      .collection("Users"
  );

// Bearbeitungsfeld
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey,
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value){
            newValue = value;
          },
        ),
        actions: [
          // Cancel Button
          TextButton(
            child: const Text("Zrušiť",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          //Save Button
          TextButton(
            child: const Text("Uložiť",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
        ],
      ),
    );

    // prüfen ob etwas geschrieben
    if (newValue.trim().length > 0) {
      // In Firestore updaten
      await usersCollection.doc(currentUser!.email).update({field: newValue});
    }
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Profil"),
          actions: [
            IconButton(
              onPressed: logout,
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        // Abfrage der entsprechenden Daten - Sammlung = Users
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser!.email)
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
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              // Inhalt Daten

              return
                Column(
                  children: [

                    ProfileData(
                      text: userData['username'],
                      sectionName: "Benutzername",
                      onPressed: () => editField('username'),
                    ),

                    ProfileData(
                      text: userData['email'],
                      sectionName: "Email-Adresse",
                      onPressed: () => editField('Email-Adresse'),
                    ),
                    SizedBox(
                      height: 200,
                    ),


                    /// Payment


                    Container(
                      child: Text(
                        "Monatsabo kaufen",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    FutureBuilder<PaymentConfiguration>(
                        future: _googlePayConfigFuture,
                        builder: (context, snapshot) => snapshot.hasData
                            ? GooglePayButton(
                          paymentConfiguration: snapshot.data!,
                          paymentItems: _paymentItems,
                          type: GooglePayButtonType.buy,
                          margin: const EdgeInsets.only(top: 15.0),
                          onPaymentResult: onGooglePayResult,
                          loadingIndicator: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                            : const SizedBox.shrink()),
                    GooglePayButton(
                      paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
                      paymentItems: _paymentItems,
                    ),

                    FutureBuilder<PaymentConfiguration>(
                        future: _applePayConfigFuture,
                        builder: (context, snapshot) => snapshot.hasData
                            ? ApplePayButton(
                          paymentConfiguration: snapshot.data!,
                          paymentItems: _paymentItems,
                          type: ApplePayButtonType.buy,
                          margin: const EdgeInsets.only(top: 15.0),
                          onPaymentResult: onApplePayResult,
                          loadingIndicator: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                            : const SizedBox.shrink()),
                    ApplePayButton(
                      paymentConfiguration: PaymentConfiguration.fromJsonString(defaultApplePay),
                      paymentItems: _paymentItems,
                    )

                    /// Payment

                  ],
                );
              // Fehlermeldung wenn nichts vorhanden ist
            } else {
              return const Text("Keine Daten vorhanden");
            }
          },
        ),
      ),
    );
  }
}
*/