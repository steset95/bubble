import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:purchases_flutter/models/storekit_version.dart';
import 'package:intl/intl.dart';

abstract class PurchasesAreCompletedBy {
  const PurchasesAreCompletedBy();
}

class PurchasesAreCompletedByRevenueCat extends PurchasesAreCompletedBy {
  const PurchasesAreCompletedByRevenueCat();
}

class PurchasesAreCompletedByMyApp extends PurchasesAreCompletedBy {
  final StoreKitVersion storeKitVersion;

  PurchasesAreCompletedByMyApp({
    required this.storeKitVersion,
  });




  final currentUser = FirebaseAuth.instance.currentUser;


  void setProvision() async {

    final String month = DateFormat("MMMM").format(DateTime.now());

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        if (document["kitamail"] != "") {



          final String? name = currentUser!.email;

          FirebaseFirestore.instance
              .collection("Abonnements")
              .doc(document["kitamail"])
              .collection(month)
              .add({'$name': DateTime.now()});
        }
      }
    });
  }

}