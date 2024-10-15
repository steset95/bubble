

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../helper/constant.dart';




class PaywallEltern extends StatefulWidget {
  final Offering offering;

  const PaywallEltern({
    super.key,
    required this.offering,


  });


  @override
  State<PaywallEltern> createState() => PaywallElternState();
}

class PaywallElternState extends State<PaywallEltern> {


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
                  child: Text(
                    'Plná verzia',
                  ),
                  width: double.infinity,
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
                          try {
                            CustomerInfo customerInfo =
                            await Purchases.purchasePackage(
                                myProductList[index]);
                            EntitlementInfo? entitlement =
                            customerInfo.entitlements.all[entitlementID];

                          } catch (e) {
                            print(e);
                          }

                          setState(() {});
                          Navigator.pop(context);
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
                  child: Column(
                    children: [
                      const Text(
                        footerText,
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
                  width: double.infinity,
                ),
              ),
            ],
          ),
        )
    );
  }


}

