
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

  void aboCheck(BuildContext context) async {

    if (kIsWeb == false) {
      if (Platform.isIOS || Platform.isMacOS) {
        StoreConfig(
          store: Store.appStore,
          apiKey: appleApiKey,
        );
      } else if (Platform.isAndroid) {
        // Run the app passing --dart-define=AMAZON=true
        StoreConfig(
          store: Store.playStore,
          apiKey: googleApiKey,
        );
      }


      WidgetsFlutterBinding.ensureInitialized();

    }

    _configureSDK();

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



Future<void> _configureSDK() async {

  FirebaseFirestore.instance
      .collection("Users")
      .doc(currentUser?.email)
      .get()
      .then((DocumentSnapshot document) async {

    String aboID = document["aboID"].toString();

    // Enable debug logs before calling `configure`.
    await Purchases.setLogLevel(LogLevel.debug);

    /*
    - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids

    - PurchasesAreCompletedyBy is PurchasesAreCompletedByRevenueCat, so Purchases will automatically handle finishing transactions. Read more about completing purchases here: https://www.revenuecat.com/docs/migrating-to-revenuecat/sdk-or-not/finishing-transactions
    */

    PurchasesConfiguration configuration;
    if (StoreConfig.isForAmazonAppstore()) {
      configuration = AmazonConfiguration(StoreConfig.instance.apiKey)
        ..appUserID = aboID
        ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
    } else {
      configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
        ..appUserID = aboID
        ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
    }
    await Purchases.configure(configuration);

  });
}