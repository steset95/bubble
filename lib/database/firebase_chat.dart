import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/my_message.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


class MyChat{

final currentUser = FirebaseAuth.instance.currentUser;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;



void sendNotification(String externalUserId, String message) async {
  const String apiKey = 'ODhiMzkzMGQtOGRhZS00YThjLWI4OWEtNjRjZWYxZDA5MWYx';
  const String appId = '07271cf6-8465-4933-afc9-6e964380f91c';

    var url = Uri.parse("https://onesignal.com/api/v1/notifications");
    var client = http.Client();

    var headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization": "Basic $apiKey", //from one signal
    };

    var body = {
      "app_id": appId,
      "contents": {"en": message, "sk": message, "de": message},
      "include_external_user_ids": [externalUserId],
      "ios_sound": "default",
      "android_sound": "default",
    };

    var response =
    await client.post(url, headers: headers, body: json.encode(body));

}


Future<void> sendMessage(String receiverEmail, message, String childcode) async {
  //get current user Info
  final String currentUserID = _firebaseAuth.currentUser!.email!;
  final String currentUserEmail = _firebaseAuth.currentUser!.email!;
  final Timestamp timestamp = Timestamp.now();
  DateTime now = DateTime.now();
  String uhrzeit = DateFormat('kk:mm').format(now);


  // create a new message
  Message newMessage = Message(

    senderID: currentUserEmail,
    senderEmail: currentUserEmail,
    receiverID: receiverEmail,
    message: message,
    timestamp: timestamp,
    uhrzeit: uhrzeit,

  );

// construct room ID for the two users (sorted to ensure uniqueness)
  List<String> ids = [currentUserID, receiverEmail];
  ids
      .sort(); // sort the ids (this ensure the chatroomID is the same for any 2 people)
  String chatRoomID = ids.join('_');


  //add new message to database
  await _firestore
      .collection("chat_rooms")
      .doc(chatRoomID)
      .collection("messages")
      .add(newMessage.toMap());

  await FirebaseFirestore.instance
      .collection("Users")
      .doc(receiverEmail)
      .get()
      .then((DocumentSnapshot document) async {

      String block = document["notificationBlock"];

      if (block != currentUserEmail) {

        await FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUserEmail)
            .get()
            .then((DocumentSnapshot document) async {

          String username = document["username"];

          sendNotification(receiverEmail, "Nové správy od $username");

          if (document["rool"] == "Eltern") {
            _firestore
                .collection("Kinder")
                .doc(childcode)
                .update({"shownotification": "1"});
          }
          else
            {
              _firestore
                  .collection("Users")
                  .doc(receiverEmail)
                  .update({"shownotification": "1"});
            }
        });
      }
      });

  }


  //get messages
Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
  // construct a chatroom ID for the two users
  List <String> ids = [userID, otherUserID];
  ids.sort();
  String chatRoomID = ids.join('_');

  return _firestore
      .collection("chat_rooms")
      .doc(chatRoomID)
      .collection("messages")
      .orderBy("timestamp", descending: true)
      .snapshots();
}


User? getCurrentUser() {
  return FirebaseAuth.instance.currentUser;
}



}


