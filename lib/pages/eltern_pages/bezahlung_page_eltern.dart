import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pay/pay.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:socialmediaapp/helper/helper_functions.dart';
import 'package:socialmediaapp/pages/eltern_pages/paywall_eltern.dart';

import '../../helper/appdata.dart';
import '../../helper/constant.dart';




// Pay Package
const _paymentItems = [
  PaymentItem(
    label: 'Total',
    amount: '00.10',
    status: PaymentItemStatus.final_price,
  )
];
///////// Pay Package


class BezahlungPage extends StatefulWidget {


  const BezahlungPage({
    super.key,



  });


  @override
  State<BezahlungPage> createState() => BezahlungPageState();
}

class BezahlungPageState extends State<BezahlungPage> {


  ///////// Pay Package
  final Future<PaymentConfiguration> _googlePayConfigFuture =
  PaymentConfiguration.fromAsset('google_pay_config.json');


  final Future<PaymentConfiguration> _applePayConfigFuture =
  PaymentConfiguration.fromAsset('apple_pay_config.json');


  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  void onApplePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }


  ///////// Pay Package

  final currentUser = FirebaseAuth.instance.currentUser;


  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  Future<void> initPlatformState() async {
    appData.appUserID = await Purchases.appUserID;

    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      appData.appUserID = await Purchases.appUserID;

      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      EntitlementInfo? entitlement =
      customerInfo.entitlements.all[entitlementID];
      appData.entitlementIsActive = entitlement?.isActive ?? false;

      setState(() {});
    });
  }

  bool _isLoading = false;

  void perfomMagic() async {
    setState(() {
      _isLoading = true;
    });

    CustomerInfo customerInfo = await Purchases.getCustomerInfo();

    if (customerInfo.entitlements.all[entitlementID] != null &&
        customerInfo.entitlements.all[entitlementID]?.isActive == true) {
      displayMessageToUser("Hat Abo", context);

      setState(() {
        _isLoading = false;
      });
    } else {
      Offerings? offerings;
      try {
        offerings = await Purchases.getOfferings();
      } on PlatformException catch (e) {
        displayMessageToUser("Error", context);// optional error handling
      }

      setState(() {
        _isLoading = false;
      });

      if (offerings == null || offerings.current == null) {
        // offerings are empty, show a message to your user
      } else {
        // current offering is available, show paywall
        await showModalBottomSheet(
          useRootNavigator: true,
          isDismissible: true,
          isScrollControlled: true,

          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
                  return PaywallEltern(
                    offering: offerings!.current!,
                  );
                });
          },
        );
      }
    }
  }


/*

  void perfomMagic() async {

    await Purchases.setDebugLogsEnabled(true);
    if (Platform.isAndroid) {
      await Purchases.configure(
          PurchasesConfiguration('goog_edQbTFZXsBGixBmXyGfIVawYltB')
            ..appUserID = currentUser?.email
      );
    } else if (Platform.isIOS) {
      await Purchases.configure(
          PurchasesConfiguration('goog_edQbTFZXsBGixBmXyGfIVawYltB')
            ..appUserID = currentUser?.email
      );
    }

    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              PaywallEltern(
                offering: offerings!.current!,
              )),
        );

      }
    } on PlatformException catch (e) {
      displayMessageToUser("Error", context);// optional error handling
    }
  }


*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      scrolledUnderElevation: 0.0,
      backgroundColor: Theme.of(context).colorScheme.secondary,
    title: Text("Abonnement",
    ),
    ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      /// Payment

    StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        // Entsprechende Daten extrahieren
        final userData = snapshot.data?.data() as Map<String, dynamic>;
        final aboBis = userData["aboBis"].toDate();
        final abo = userData["abo"];


        String currentDate = aboBis.toString(); // Aktuelles Datum als String
        String formattedDate = currentDate.substring(
            0, 10); // Nur das Datum extrahieren

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(abo),
            Row(
              children: [
                Text('Aktiv bis: '),
                Text(formattedDate,
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                )
              ],
            ),
          ],
        );
      }
      return Text("");
    }),


                      SizedBox(
                        height: 15,
                      ),


                      TextButton(
                        onPressed: () => perfomMagic(),
                        child: Text(
                          "Abonnement aktivieren",
                        ),
                      ),


                      /*

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
*/
                    ],
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }


}

