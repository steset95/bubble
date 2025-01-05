

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';





class PayPopupKita extends StatefulWidget {
  final Offering offering;
  final String aboType;

  const PayPopupKita({
    super.key,
    required this.offering,
    required this.aboType,
  });


  @override
  State<PayPopupKita> createState() => PayPopupKitaState();
}

class PayPopupKitaState extends State<PayPopupKita> {


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SafeArea(
          child: Wrap(
            children: <Widget>[
              Container(
                height: 70.0,
                width: double.infinity,
                decoration: const BoxDecoration(

                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25.0))),
                child: const Center(
                    child:
                    Text('Bubble-App')),
              ),
              const Padding(
                padding:
                EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Plná verzia',
                  ),
                ),
              ),
              ListView.builder(
                itemCount: widget.offering.availablePackages.length,
                itemBuilder: (BuildContext context, int index) {
                  var myProductList = widget.offering.availablePackages;

                  return Card(
                    color: Colors.white,
                    child: ListTile(
                        onTap: () async {

                            CustomerInfo customerInfo =
                            await Purchases.purchasePackage(
                                myProductList[index]);
                            EntitlementInfo? entitlement =
                            customerInfo.entitlements.all[widget.aboType];
                          setState(() {});
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                        },
                        title: Text(
                          myProductList[index].storeProduct.title,
                        ),
                        subtitle: Text(
                          myProductList[index].storeProduct.description,
                        ),
                        trailing: Text(
                            myProductList[index].storeProduct.priceString,
                            )),
                  );
                },
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
              ),
              Padding(
                padding:
                const EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      if (widget.aboType == 'bronze')
                       Text(
                           """Bubble-App Bronze (1 mesiac / 59 euro): Predplatné bude pridané do vášho účtu iTunes alebo Play Store.
Predplatné sa mesačne automaticky predlžuje až do aktívneho zrušenia. Predplatné môžete kedykoľvek zrušiť vo svojom účte iTunes alebo Play Store.
Pre viac informácií: Všeobecné obchodné podmienky a zásady ochrany osobných údajov."""
                      ),
                      if (widget.aboType == 'silver')
                        Text(
                            """Bubble-App Silver (1 mesiac / 99 euro): Predplatné bude pridané do vášho účtu iTunes alebo Play Store.
Predplatné sa mesačne automaticky predlžuje až do aktívneho zrušenia. Predplatné môžete kedykoľvek zrušiť vo svojom účte iTunes alebo Play Store.
Pre viac informácií: Všeobecné obchodné podmienky a zásady ochrany osobných údajov."""
                        ),
                      if (widget.aboType == 'gold')
                        Text(
                            """Bubble-App Gold (1 mesiac / 139 euro): Predplatné bude pridané do vášho účtu iTunes alebo Play Store.
Predplatné sa mesačne automaticky predlžuje až do aktívneho zrušenia. Predplatné môžete kedykoľvek zrušiť vo svojom účte iTunes alebo Play Store.
Pre viac informácií: Všeobecné obchodné podmienky a zásady ochrany osobných údajov."""
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (Platform.isIOS)
                          TextButton(
                            onPressed: () async {
                              await launchUrl(
                                  Uri.parse('https://www.apple.com/legal/internet-services/itunes/dev/stdeula/')); // Add URL which you want here
                              // Navigator.of(context).pushNamed(SignUpScreen.routeName);
                            },
                            child: const Text("EULA",
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await launchUrl(
                                  Uri.parse('https://bubble-app.sk/terms_and_conditions')); // Add URL which you want here
                              // Navigator.of(context).pushNamed(SignUpScreen.routeName);
                            },
                            child: Text("AGB",
                              style: TextStyle(fontSize: 10),
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }


}

