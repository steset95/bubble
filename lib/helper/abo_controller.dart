
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'constant.dart';
import 'store_helper.dart';

final currentUser = FirebaseAuth.instance.currentUser;

Future<void> configureSDK() async {
  await Purchases.setLogLevel(LogLevel.debug);

  if (kIsWeb == false) {
    if (Platform.isIOS || Platform.isMacOS) {
      StoreConfig(
        store: Store.appStore,
        apiKey: appleApiKey,
      );
    } else if (Platform.isAndroid) {
      StoreConfig(
        store: Store.playStore,
        apiKey: googleApiKey,
      );
    }
  }

  await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .get()
        .then((DocumentSnapshot document) async {

       String aboID = document["aboID"].toString();

      PurchasesConfiguration configuration;
      {
        configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
          ..appUserID = aboID
          ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
      }
      await Purchases.configure(configuration);
    });
  }



void aboCheck() async {

  CustomerInfo customerInfo = await Purchases.getCustomerInfo();

  await FirebaseFirestore.instance
      .collection("Users")
      .doc(currentUser?.email)
      .get()
      .then((DocumentSnapshot document) async {
    if ((customerInfo.entitlements.all['bronze'] == null && customerInfo.entitlements.all['silver'] == null && customerInfo.entitlements.all['gold'] == null)
        && document["aboBis"].toDate().isBefore(DateTime.now()))
    {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser?.email)
          .update({"abo": "inaktiv"});
    }
    else if (
        (customerInfo.entitlements.all['bronze']?.isActive == false && customerInfo.entitlements.all['silver']?.isActive == false && customerInfo.entitlements.all['gold']?.isActive == false)
        && document["aboBis"].toDate().isBefore(DateTime.now())
    ) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser?.email)
          .update({"abo": "inaktiv"});
    }
    else if (customerInfo.entitlements.all['gold'] != null &&
        customerInfo.entitlements.all['gold']?.isActive == true
    ) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser?.email)
          .update({"abo": "gold"});
    }
    else if (customerInfo.entitlements.all['silver'] != null &&
        customerInfo.entitlements.all['silver']?.isActive == true
    ) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser?.email)
          .update({"abo": "silver"});
    }
    else if (customerInfo.entitlements.all['bronze'] != null &&
        customerInfo.entitlements.all['bronze']?.isActive == true
    ) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser?.email)
          .update({"abo": "bronze"});
    }

  });


}
