
import 'dart:async';

import 'package:bubble/pages/kita_pages/pay_popup_kita.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../helper/abo_controller.dart';





class BezahlungPageKita extends StatefulWidget {


  const BezahlungPageKita({
    super.key,
      });


  @override
  State<BezahlungPageKita> createState() => BezahlungPageKitaState();
}

class BezahlungPageKitaState extends State<BezahlungPageKita> {


  @override
  void initState() {
    super.initState();
    configureSDK();
    Future.delayed(Duration(milliseconds: 4000), () {aboCheck();});
  }

  final currentUser = FirebaseAuth.instance.currentUser;



  bool _isLoading = false;



  void getOfferings(String aboType) async {


    setState(() {
      _isLoading = true;
    });

    CustomerInfo customerInfo = await Purchases.getCustomerInfo();

    if (customerInfo.entitlements.all[aboType] != null &&
        customerInfo.entitlements.all[aboType]?.isActive == true
    )
    {
      fetchExpirationDate();
      setState(() {
        _isLoading = false;
      });
    } else {
      Offerings? offerings;

      offerings = await Purchases.getOfferings();
      var offeringsType;
      offeringsType = offerings.getOffering(aboType);

      setState(() {
        _isLoading = false;
      });


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
                  return PayPopupKita(
                    offering: offeringsType,
                    aboType: aboType,
                  );
                });
          },
        );
    }
  }


  Future<void> fetchExpirationDate() async {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      for (var entitlement in customerInfo.entitlements.active.values) {
        String? expirationDate = entitlement.expirationDate;
        final String expirationDateOutput = expirationDate!.substring(0, 10);
          return
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
        StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
        .doc(currentUser?.email)
        .snapshots(),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(
    child: CircularProgressIndicator(),
    );
    }
    else if (snapshot.hasData) {
    // Entsprechende Daten extrahieren
    final userData = snapshot.data?.data() as Map<String, dynamic>;

    final abo = userData["abo"];
    final aboBis = userData["aboBis"].toDate();
    String currentDate = aboBis.toString();
    String formattedDate = currentDate.substring(0, 10);

    bool hatBronze = abo == "bronze";
    var iconBronze = hatBronze ? HugeIcons.strokeRoundedCheckmarkCircle02 : HugeIcons.strokeRoundedRocket01;
    var textBronze = hatBronze ? "Active" : "1 - 29 Deti";

    bool hatSilver = abo == "silver";
    var iconSilver  = hatSilver ? HugeIcons.strokeRoundedCheckmarkCircle02 : HugeIcons.strokeRoundedRocket01;
    var textSilver  = hatSilver ? "Active" : "30 - 59 Deti";

    bool hatGold = abo == "gold";
    var iconGold = hatGold ? HugeIcons.strokeRoundedCheckmarkCircle02 : HugeIcons.strokeRoundedRocket01;
    var textGold = hatGold ? "Active" : "59+ Deti";




     return SingleChildScrollView(
       child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (aboBis.isAfter(DateTime.now()))
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HugeIcon(
                          icon:  HugeIcons.strokeRoundedCheckmarkCircle02,
                          color: Colors.black,
                          size: 20,
                        ),
                        Text(" Aktívne skúšobné mesiace ",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        HugeIcon(
                          icon:  HugeIcons.strokeRoundedCheckmarkCircle02,
                          color: Colors.black,
                          size: 20,
                        ),
       
                      ],
                    ),
                    Text('(Do: $formattedDate)'),
                    const SizedBox(height: 30),
                  ],
                ),
       
              Container(
                height: 160,
                child: GestureDetector(
                  onTap: () => getOfferings('bronze'),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xedc97932).withOpacity(0.5),
                          Colors.white.withOpacity(0.7),
                          Color(0xedc97932).withOpacity(0.5),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        //stops: [0.6, 0.3,],
                        //center: Alignment.topRight,
                        //radius: 0.6,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(2, 6),
                        ),
                      ],
                    ),
       
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                            ),
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedStar,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .inversePrimary,
                              size: 30,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HugeIcon(
                              icon: iconBronze,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .inversePrimary,
                              size: 20,
                            ),
                            //const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Bronze",
                                  style: TextStyle(
                                      color: Theme
                                          .of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                            Text(textBronze,
                              style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                              child:
                              Text("59€ / mesiac",
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
       
              const SizedBox(height: 40),
              Container(
                height: 160,
                child:
                GestureDetector(
                  onTap: () => getOfferings('silver'),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey,
                          Colors.white.withOpacity(0.4),
                          Colors.grey,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        //stops: [0.6, 0.3,],
                        //center: Alignment.topRight,
                        //radius: 0.6,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(2, 6),
                        ),
                      ],
                    ),
       
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                            ),
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedStar,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .inversePrimary,
                              size: 30,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedStar,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .inversePrimary,
                              size: 30,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HugeIcon(
                              icon: iconSilver,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .inversePrimary,
                              size: 20,
                            ),
                            //const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Silver",
                                  style: TextStyle(
                                      color: Theme
                                          .of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                            Text(textSilver,
                              style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                              child:
                              Text("99€ / mesiac",
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
       
              const SizedBox(height: 40),
              Container(
                height: 160,
                child:
                GestureDetector(
                  onTap: () => getOfferings('gold'),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Colors.yellowAccent.shade700,
                          Colors.white.withOpacity(0.86),
                          Colors.yellowAccent.shade700,
                          Colors.yellowAccent.shade700.withOpacity(0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        //stops: [0.6, 0.3,],
                        //center: Alignment.topRight,
                        //radius: 0.6,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(2, 6),
                        ),
                      ],
                    ),
       
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                            ),
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedStar,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .inversePrimary,
                              size: 30,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedStar,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .inversePrimary,
                              size: 30,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedStar,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .inversePrimary,
                              size: 30,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HugeIcon(
                              icon: iconGold,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .inversePrimary,
                              size: 20,
                            ),
                            //const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Gold",
                                  style: TextStyle(
                                      color: Theme
                                          .of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                            Text(textGold,
                              style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                              child:
                              Text("139€ / mesiac",
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
       
              const SizedBox(height: 10),
            ],
          ),
        ),
     );

    }
        else
          {
            return Container();
          }
        }
    ),

        ],
      ),
    );
  }


}

