
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:bubble/helper/helper_functions.dart';
import 'package:bubble/pages/eltern_pages/paywall_eltern.dart';
import '../../components/my_button.dart';
import '../../helper/constant.dart';





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



  bool _isLoading = false;

  void perfomMagic() async {
    setState(() {
      _isLoading = true;
    });

    CustomerInfo customerInfo = await Purchases.getCustomerInfo();

    if (customerInfo.entitlements.all[entitlementID] != null &&
        customerInfo.entitlements.all[entitlementID]?.isActive == true) {
      if (!mounted) return;
      displayMessageToUser("Error", context);

      setState(() {
        _isLoading = false;
      });
    } else {
      Offerings? offerings;

        offerings = await Purchases.getOfferings();

      setState(() {
        _isLoading = false;
      });

      if (offerings.current == null) {
        // offerings are empty, show a message to your user
      } else {
        // current offering is available, show paywall
        if (!mounted) return;
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
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      for (var entitlement in customerInfo.entitlements.active.values) {
        String? expirationDate = entitlement.expirationDate;
        final String expirationDateOutput = expirationDate!.substring(0, 10);
        if (!mounted) return;
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
              content: SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Aktívna do: $expirationDateOutput"),
                       // Text("Abo gelöst am: ${originalpurchasedateOutput}"),
                        Text("(Automatické mesačné obnovenie)")
                      ],
                    ),
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
      }
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset("assets/images/bubbles.png", width: 350, height:350),
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
                        Text('2.99 Euro / mesiac'),
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

