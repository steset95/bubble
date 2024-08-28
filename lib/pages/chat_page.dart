import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/components/my_textfield.dart';
import '../components/my_chatbubble.dart';
import '../database/firebase_chat.dart';
import 'package:intl/intl.dart';


class ChatPage extends StatefulWidget {
  //final String receiverEmail;
  final String receiverID;
  final String childcode;

  ChatPage({
    super.key,
    //required this.receiverEmail,
    required this.receiverID,
    required this.childcode,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // text controller
  final TextEditingController _messageController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  // chat & auth services
  final MyChat _chatService = MyChat();

  // send message
  void sendMessage() async {
    //if there is something inside the Textfield
    if (_messageController.text.isNotEmpty) {
      _chatService.sendMessage(widget.receiverID, _messageController.text, widget.childcode);

    _messageController.clear();
  }
}

  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) =>
    FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .get()
        .then((DocumentSnapshot document) {

          String rool = document["rool"];
          if (rool == "Eltern") {

        FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser?.email)
            .update({"shownotification": "0"});


        FirebaseFirestore.instance
        .collection("Users")
          .doc(currentUser?.email)
          .collection("notifications")
          .doc("notification")
          .update({"notification": 0});


      }
          if (rool == "Kita") {

        FirebaseFirestore.instance
            .collection("Kinder")
            .doc(widget.childcode)
            .update({"shownotification": "0"});


      }


    }),
    );

         }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text("Chat",
        ),
      ),
            body: Column(
             children: [
               Expanded(
                child: _buildMessageList(),
               ),
               const SizedBox(height: 10,),
               _buildUserInput(),
             ],
            ),
    );
  }

Widget _buildMessageList() {
  String? senderID = _chatService.getCurrentUser()!.email;
  return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot)
  {
    if (snapshot.hasError) {
      return const Text("error");
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Text("loading");
    }
    return ListView(
      reverse: true,
      children:
        snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
    );

  },
  );
}

Widget _buildMessageItem(DocumentSnapshot doc) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

  bool isCurrentUser = data['senderID'] == _chatService.getCurrentUser()!.email;

  var alignment =
  isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

  Timestamp timestamp = data['timestamp'];
final datum = DateFormat('dd.MM.yyyy').format(timestamp.toDate());


  return Container(
    alignment: alignment,
    child: Column(
      children: [
        ChatBubble(
          message: data["message"],
          isCurrentUser: isCurrentUser,
          datum: datum,
          uhrzeit: data['uhrzeit'],
        ),
      ],
    ),
  );

}

Widget _buildUserInput() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Row(
  children: [
    const SizedBox(width: 20,),
    Expanded(
        child: TextField(
          minLines: 1,
          maxLines: 5,
          controller: _messageController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            hintText: "Správa...",
          ),
        ),
    ),
    const SizedBox(width: 10,),
    Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        shape: BoxShape.circle,
      ),
      margin: const EdgeInsets.only(right: 20),
      child: IconButton(
        onPressed: sendMessage,
        icon: const Icon(Icons.arrow_upward,
        ),
      ),
    ),
  ],
),

    );
}
}
