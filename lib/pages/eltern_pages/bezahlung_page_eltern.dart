

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../helper/payment_configurations.dart';

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







  Future<void> initPlatformState() async {
    await Purchases.setDebugLogsEnabled(true);

    PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration('goog_edQbTFZXsBGixBmXyGfIVawYltB');

    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration('goog_edQbTFZXsBGixBmXyGfIVawYltB');
    }
    await Purchases.configure(currentUser?.email as PurchasesConfiguration);
  }




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
                        GestureDetector(
                          onTap:  ()async {
                            await Purchases.purchaseProduct('id_coins');
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            color: Colors.red,
                          ),
                        ),
                      SizedBox(height: 50,),
                      GestureDetector(
                        onTap:  ()async {
                          await Purchases.purchaseProduct('id_subscripition');
                        },
                        child: Column(
                          children: [
                            Text("Provision",
                              style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.primary,),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [Colors.white.withOpacity(0.2), Theme.of(context).colorScheme.primary.withOpacity(0.2),],
                                                begin: const FractionalOffset(0.0, 0.1),
                                                end: const FractionalOffset(0.4, 0.6),
                                                stops: [0.1, 0.6],
                                                tileMode: TileMode.clamp
                                            ),
                                            //color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                                spreadRadius: 3,
                                                blurRadius: 6,
                                                offset: Offset(2, 4),
                                              ),
                                            ],
                                            borderRadius: BorderRadius.all(Radius.circular(100))
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text ("Abo",
                                                  style: TextStyle(color: Colors.black.withOpacity(0.5),
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(height: 21,),
                                        Row(
                                          children: [
                                            SizedBox(width: 30,),
                                            Container(
                                              width: 1,
                                              height: 9,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.white,
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset: Offset(2, 4),
                                                    ),
                                                  ],
                                                  borderRadius: BorderRadius.all(Radius.circular(100))
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(height: 24,),
                                        Row(
                                          children: [
                                            SizedBox(width: 26,),
                                            Container(
                                              width: 3,
                                              height: 4,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.white,
                                                      spreadRadius: 4,
                                                      blurRadius: 5,
                                                      offset: Offset(2, 4),
                                                    ),
                                                  ],
                                                  borderRadius: BorderRadius.all(Radius.circular(100))
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(height: 27,),
                                        Row(
                                          children: [
                                            SizedBox(width: 22,),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.white,
                                                      spreadRadius: 3,
                                                      blurRadius: 6,
                                                      offset: Offset(2, 4),
                                                    ),
                                                  ],
                                                  borderRadius: BorderRadius.all(Radius.circular(100))
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
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

