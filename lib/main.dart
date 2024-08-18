import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/models/store.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:socialmediaapp/auth/auth.dart';
import 'package:socialmediaapp/firebase_options.dart';
import 'package:socialmediaapp/helper/store_helper.dart';
import 'package:socialmediaapp/theme/dark_mode.dart';
import 'package:socialmediaapp/theme/light_mode.dart';

import 'helper/appdata.dart';
import 'helper/constant.dart';
import 'helper/notification_controller.dart';


Future<void> _configureSDK() async {
  // Enable debug logs before calling `configure`.
  await Purchases.setLogLevel(LogLevel.debug);

  /*
    - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids

    - PurchasesAreCompletedyBy is PurchasesAreCompletedByRevenueCat, so Purchases will automatically handle finishing transactions. Read more about completing purchases here: https://www.revenuecat.com/docs/migrating-to-revenuecat/sdk-or-not/finishing-transactions
    */
  PurchasesConfiguration configuration;
  if (StoreConfig.isForAmazonAppstore()) {
    configuration = AmazonConfiguration(StoreConfig.instance.apiKey)
      ..appUserID = null
      ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
  } else {
    configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
      ..appUserID = null
      ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
  }
  await Purchases.configure(configuration);
}


void main() async {

  if (Platform.isIOS || Platform.isMacOS) {
    StoreConfig(
      store: Store.appStore,
      apiKey: appleApiKey,
    );
  } else if (Platform.isAndroid) {
    // Run the app passing --dart-define=AMAZON=true
    const useAmazon = bool.fromEnvironment("amazon");
    StoreConfig(
      store: useAmazon ? Store.amazon : Store.playStore,
      apiKey: useAmazon ? amazonApiKey : googleApiKey,
    );
  }

  WidgetsFlutterBinding.ensureInitialized();

  await _configureSDK();

  /// AwesomeNotifications
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelGroupKey: "basic_channel_group",
      channelKey: "basic_channel",
      channelName: "Basic Notification",
      channelDescription: "Basic notifications channel",
    )
  ], channelGroups: [
    NotificationChannelGroup(
      channelGroupKey: "basic_channel_group",
      channelGroupName: "Basic Group",
    )
  ]);
  bool isAllowedToSendNotification =
  await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();

  }
  /// AwesomeNotifications

  WidgetsFlutterBinding.ensureInitialized(); // in Firebase einbinden
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}





class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  void initState() {
    initState();
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
        NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
        NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
        NotificationController.onDismissActionReceivedMethod);
  }




  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
        statusBarColor: Colors.orange.shade300,
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
    ),

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthPage(),
        theme: lightMode,
        //darkTheme: darkMode,
      ),
    );
  }
}
