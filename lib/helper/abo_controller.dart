
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'constant.dart';
import 'store_helper.dart';
import '../pages/eltern_pages/bezahlung_page_eltern.dart';

final currentUser = FirebaseAuth.instance.currentUser;

Future<void> configureSDK() async {

  Purchases.setLogLevel(LogLevel.debug);

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

       String aboID = await document["aboID"].toString();

      PurchasesConfiguration configuration;
      await {
        configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
          ..appUserID = aboID
          ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat()
      };
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
    if (customerInfo.entitlements.all[entitlementID] == null
        && document["aboBis"].toDate().isBefore(DateTime.now()))
    {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser?.email)
          .update({"abo": "inaktiv"});
    }
    else if (customerInfo.entitlements.all[entitlementID] != null &&
        customerInfo.entitlements.all[entitlementID]?.isActive == false
        && document["aboBis"].toDate().isBefore(DateTime.now())
    ) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser?.email)
          .update({"abo": "inaktiv"});
    }
    else if (customerInfo.entitlements.all[entitlementID] != null &&
        customerInfo.entitlements.all[entitlementID]?.isActive == true
    ) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser?.email)
          .update({"abo": "aktiv"});
    }
  });


}