import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/my_message.dart';
import 'package:intl/intl.dart';


class MyChat{

final currentUser = FirebaseAuth.instance.currentUser;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


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
      .collection("notifications")
      .doc("block")
      .get()
      .then((DocumentSnapshot document) async {

    if (document.exists) {
      String block = document["block"];

      if (block != currentUserEmail) {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(receiverEmail)
            .collection("notifications")
            .doc("notification")
            .get()
            .then((DocumentSnapshot document) {
          if (document.exists) {
            var notificationNumber = document["notification"];
            int not = (notificationNumber + 1);


            _firestore
                .collection("Users")
                .doc(receiverEmail)
                .collection("notifications")
                .doc("notification")
                .update({"notification": not});
          }
          else {
            _firestore
                .collection("Users")
                .doc(receiverEmail)
                .collection("notifications")
                .doc("notification")
                .set({"notification": 1});
          }
        });


        await FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUserEmail)
            .get()
            .then((DocumentSnapshot document) {
          String username = document["username"];


          _firestore
              .collection("Users")
              .doc(receiverEmail)
              .update({"shownotification": "1"});

          _firestore
              .collection("Users")
              .doc(receiverEmail)
              .collection("notifications")
              .doc("user")
              .set({"username": username});

          if (document["rool"] == "Eltern") {
            _firestore
                .collection("Kinder")
                .doc(childcode)
                .update({"shownotification": "1"});
          }
        });
      }
    }
    else {

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(receiverEmail)
          .collection("notifications")
          .doc("notification")
          .get()
          .then((DocumentSnapshot document) {
        if (document.exists) {
          var notificationNumber = document["notification"];
          int not = (notificationNumber + 1);


          _firestore
              .collection("Users")
              .doc(receiverEmail)
              .collection("notifications")
              .doc("notification")
              .update({"notification": not});
        }
        else {
          _firestore
              .collection("Users")
              .doc(receiverEmail)
              .collection("notifications")
              .doc("notification")
              .set({"notification": 1});
        }
      });


      await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUserEmail)
          .get()
          .then((DocumentSnapshot document) {
        String username = document["username"];


        _firestore
            .collection("Users")
            .doc(receiverEmail)
            .update({"shownotification": "1"});

        _firestore
            .collection("Users")
            .doc(receiverEmail)
            .collection("notifications")
            .doc("user")
            .set({"username": username});

        if (document["rool"] == "Eltern") {
          _firestore
              .collection("Kinder")
              .doc(childcode)
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


