
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:bubble/components/my_profile_data.dart';
import 'package:bubble/components/my_profile_data_read_only.dart';
import 'package:bubble/pages/eltern_pages/bezahlung_page_eltern.dart';
import '../../helper/abo_controller.dart';
import '../../helper/constant.dart';
import '../../helper/helper_functions.dart';
import '../../helper/notification_controller.dart';
import 'package:intl/intl.dart';
import '../../helper/store_helper.dart';
import '../impressum_page.dart';




class ProfilePageEltern extends StatefulWidget {
  ProfilePageEltern({super.key});



  @override
  State<ProfilePageEltern> createState() => _ProfilePageElternState();
}

class _ProfilePageElternState extends State<ProfilePageEltern> {



  /// Notification

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => NotificationController().notificationCheck());
    _configureSDK();
  }


  /// Notification






  final currentUser = FirebaseAuth.instance.currentUser;


  // Referenz zu "Users" Datenbank
  final usersCollection = FirebaseFirestore
      .instance
      .collection("Users"
  );

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;



// Bearbeitungsfeld
  Future<void> editField(String field, String title, String text) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(10.0))),
        title: Text(
          "$title",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
          //"Edit $field",
        ),
        content: TextFormField(
          contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
            // If supported, show the system context menu.
            if (SystemContextMenu.isSupported(context)) {
              return SystemContextMenu.editableText(
                editableTextState: editableTextState,
              );
            }
            // Otherwise, show the flutter-rendered context menu for the current
            // platform.
            return AdaptiveTextSelectionToolbar.editableText(
              editableTextState: editableTextState,
            );
          },
          decoration: InputDecoration(
            counterText: "",
            hintText: title,
          ),
          maxLength: 100,
          initialValue: text,
          autofocus: true,
          onChanged: (value){
            newValue = value;
          },
        ),
        actions: [
          // Cancel Button
          TextButton(
            child: const Text("Zrušiť",
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
              child: const Text("Uložiť",
              ),
              onPressed: () {
                Navigator.pop(context);
                  usersCollection.doc(currentUser!.email).update({field: newValue});
              }
          ),
        ],
      ),
    );
  }


  Future<void> _configureSDK() async {

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
    }

    FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .get()
        .then((DocumentSnapshot document) async {

      String aboID = document["aboID"].toString();

      // Enable debug logs before calling `configure`.
      await Purchases.setLogLevel(LogLevel.debug);


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


  void goToPage() async {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .get()
        .then((DocumentSnapshot document) {
      if (customerInfo.entitlements.all[entitlementID] != null &&
          customerInfo.entitlements.all[entitlementID]?.isActive == true
          ) {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser?.email)
            .update({"abo": "aktiv"});
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              BezahlungPage(isActive: true, text: "Aktívne predplatné")),
        );
      }

      else if
      (customerInfo.entitlements.all[entitlementID] == null &&
          document["aboBis"].toDate().isAfter(DateTime.now()))
      {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              BezahlungPage(isActive: true, text: "Aktívne skúšobné mesiace")),
        );
      }
      else if
      (customerInfo.entitlements.all[entitlementID] != null &&
          customerInfo.entitlements.all[entitlementID]?.isActive == false &&
          document["aboBis"].toDate().isAfter(DateTime.now()))
      {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              BezahlungPage(isActive: true, text: "Aktívne skúšobné mesiace")),
        );
      }

      else
        {
          FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser?.email)
              .update({"abo": "inaktiv"});

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                BezahlungPage(isActive: false, text: "Na plnú verziu")),
          );

        }
    });
  }





  Future logOut()  async {
    await _firebaseAuth.signOut();
  }


  Widget showButtons () {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    ImpressumPage()),
              );
            },
            child: Row(
              children: [
                Text("O applikácii",
                  style: TextStyle(fontFamily: 'Goli'),
                ),
                const SizedBox(width: 15),
                Container(
                  color: Colors.black,
                  height: 25.0,
                  width: 1.0,
                ),
              ],
            )
        ),

        const SizedBox(width: 15),

        /// Absenzmeldung

        IconButton(
          onPressed: logOut,
          icon: const Icon(Icons.logout,
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
        title: Text("Profil",
        ),
        actions: [
          showButtons (),
        ],
      ),

      // Abfrage der entsprechenden Daten - Sammlung = Users
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(child: Image.asset("assets/images/bubbles_login.png", width: 350, height:350)),
                ],
              ),
            ],
          ),
          SingleChildScrollView(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(currentUser?.email)
                  .snapshots(),
              builder: (context, snapshot)
              {
                // ladekreis
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                // Fehlermeldung
                else if (snapshot.hasError) {
                  return Text("Error ${snapshot.error}");
                }
                // Daten abfragen funktioniert
                else if (snapshot.hasData) {
                  // Entsprechende Daten extrahieren
                  final userData = snapshot.data?.data() as Map<String, dynamic>;


                  return
                    Column(
                      children: [

                        SizedBox(
                          height: 15,
                        ),
                        ProfileData(
                          text: userData["username"],
                          sectionName: "Meno a Priezvisko",
                          onPressed: () => editField("username", "Meno a Priezvisko", userData["username"]),
                        ),

                        ProfileDataReadOnly(
                          text: userData["email"],
                          sectionName: "Email",

                        ),
                        ProfileData(
                          text: userData["adress"],
                          sectionName: "Ulica / Číslo",
                          onPressed: () => editField("adress", "Ulica / Číslo", userData["adress"]),
                        ),

                        ProfileData(
                          text: userData["adress2"],
                          sectionName: "PSČ / Mesto",
                          onPressed: () => editField("adress2", "PSČ / Mesto", userData["adress2"]),
                        ),

                        ProfileData(
                          text: userData["tel"],
                          sectionName: "Mobilné číslo",
                          onPressed: () => editField("tel", "Mobilné číslo", userData["tel"]),
                        ),

                        SizedBox(
                          height: 30,
                        ),


                        /// Payment


                        GestureDetector(
                          onTap: () => goToPage(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Text("Predplatné",
                                style: TextStyle(color: Theme.of(context).colorScheme.primary,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Icon(
                                  Icons.arrow_forward,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 10
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  // Fehlermeldung wenn nichts vorhanden ist
                } else {
                  return const Text("No  Data");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}



