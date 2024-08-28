import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;
import 'package:purchases_flutter/models/store.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:socialmediaapp/auth/auth.dart';
import 'package:socialmediaapp/firebase_options.dart';
import 'package:socialmediaapp/helper/store_helper.dart';
import 'package:socialmediaapp/theme/light_mode.dart';
import 'components/abo_controller.dart';
import 'helper/constant.dart';
import 'helper/notification_controller.dart';


/// Purchase


void main() async {


  intl.Intl.defaultLocale = 'sk';

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

  /// Purchase


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
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('sk'),
        ],
        debugShowCheckedModeBanner: false,
        home: AuthPage(),
        theme: lightMode,
        //darkTheme: darkMode,
      ),
    );
  }
}
