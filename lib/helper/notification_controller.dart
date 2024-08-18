import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {}

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {}

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {}


  final currentUser = FirebaseAuth.instance.currentUser;


  void notificationCheck() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .collection("notifications")
        .doc("notification")
        .get()
        .then((DocumentSnapshot document) {
          if (document.exists){
      var notification = document["notification"];
      int not = notification;

      FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser?.email)
          .collection("notifications")
          .doc("user")
          .get()
          .then((DocumentSnapshot document) {
        String username = document["username"];


        if (not > 0) {
          AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 1,
                channelKey: "basic_channel",
                title: '$not neue Nachrichten',
                body: 'Neue Nachrichten von $username'),
            //body: '$not neue Nachrichten'),
          );
          FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser?.email)
              .collection("notifications")
              .doc("notification")
              .update({"notification": 0});
        };
      }
      );
    }});
    }









}
