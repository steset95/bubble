
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:bubble/helper/helper_functions.dart';
import 'package:bubble/pages/eltern_pages/paywall_eltern.dart';
import '../../helper/abo_controller.dart';
import '../../components/my_button.dart';
import '../../helper/appdata.dart';
import '../../helper/constant.dart';
import '../../helper/store_helper.dart';





class BezahlungPage extends StatefulWidget {
  bool isActive;
  String text;

   BezahlungPage({
    super.key,
    required this.isActive,
     required this.text,
      });


  @override
  State<BezahlungPage> createState() => BezahlungPageState();
}

class BezahlungPageState extends State<BezahlungPage> {




  final currentUser = FirebaseAuth.instance.currentUser;



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
      displayMessageToUser("Error", context);

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


  Future<void> fetchExpirationDate() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      for (var entitlement in customerInfo.entitlements.active.values) {
        String? expirationDate = entitlement.expirationDate;
        String? originalpurchasedate = entitlement.originalPurchaseDate;
        final String expirationDateOutput = expirationDate!.substring(0, 10);
        final String originalpurchasedateOutput = originalpurchasedate!.substring(0, 10);
        if (expirationDate != null) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(
                      Radius.circular(10.0))),
              title: Text("Predplatné",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black,
                  fontSize: 20,

                ),
              ),
              content: Container(
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Aktívna do: ${expirationDateOutput}"),
                   // Text("Abo gelöst am: ${originalpurchasedateOutput}"),
                    Text("(Automatické mesačné obnovenie)")
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    // Textfeld Zatvoriť
                    Navigator.pop(context);
                    //Textfeld leeren
                  },
                  child: Text("Zatvoriť"),
                ),
              ],
            ),
          );
// Hier kannst du das Ablaufdatum in deiner UI anzeigen
        }
      }
    } catch (e) {
      print("Error fetching customer info: $e");
    }
  }







  Widget showButtons () {
    return Row(
      children: [
        IconButton(
          onPressed: fetchExpirationDate,
          icon: const Icon(Icons.info_outline,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      scrolledUnderElevation: 0.0,
      backgroundColor: Theme.of(context).colorScheme.secondary,
    title: Text("Predplatné",
    ),
    ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(child: Image.asset("assets/images/bubbles.png", width: 350, height:350)),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text('Zabezpečte si prístup k:',
                      style: TextStyle(color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Icon(Icons.check,
                          color: Colors.green,
                        ),
                        Text(' Dennik '),
                        Icon(Icons.check,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.check,
                          color: Colors.green,
                        ),
                        Text(' Chatovacej funkcii '),
                        Icon(Icons.check,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.check,
                          color: Colors.green,
                        ),
                        Text(' Škôlka nástenka '),
                        Icon(Icons.check,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    if (widget.text == "Aktívne skúšobné mesiace")
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(2, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(25),
                            child: Center(
                              child: Text(
                                widget.text,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                                .collection("Users")
                                .doc(currentUser?.email)
                                .snapshots(),
                            builder: (context, snapshot) {

                            final userData = snapshot.data?.data() as Map<String, dynamic>;
                            final aboBis = userData["aboBis"].toDate();
                            String currentDate = aboBis.toString(); // Aktuelles Datum als String
                            String formattedDate = currentDate.substring(0, 10); // Nur das Dat

                            return Text('Do: $formattedDate');
                        }),
                        ],
                      ),
                    if (widget.text == "Aktívne predplatné")
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(2, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(25),
                            child: Center(
                              child: Text(
                                widget.text,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          IconButton(
                            onPressed: fetchExpirationDate,
                            icon: const Icon(Icons.info_outline,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    if (widget.isActive == false)
                    Column(
                      children: [
                        MyButton(
                          text: widget.text,
                          onTap: () => perfomMagic(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('9,90 EURO / mesiac'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}

