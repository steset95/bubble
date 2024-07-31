
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socialmediaapp/components/my_profile_data_icon.dart';
import 'package:socialmediaapp/components/my_textfield.dart';
import '../../components/my_profile_data_read_only.dart';
import '../../helper/helper_functions.dart';




class AddKindPageEltern extends StatefulWidget {

  AddKindPageEltern({
    super.key,
  });



  @override
  State<AddKindPageEltern> createState() => _AddKindPageElternState();
}

class _AddKindPageElternState extends State<AddKindPageEltern> {


  final currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController textController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;




  void addChildCode(String childcode) async{

    await FirebaseFirestore.instance
        .collection("Kinder")
        .doc(childcode)
        .get()
        .then((DocumentSnapshot document) {
      if (document["registrierungen"] > 3) {

        return displayMessageToUser("Zu viele verschiedene Mail-Adressen verwendet.", context);
      }
        else {

        FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser?.email)
            .get()
            .then((DocumentSnapshot document) {
              final childcode1 = document["childcode"];
              final childcode2 = document["childcode2"];


              if (childcode1.isEmpty && childcode2.isEmpty)
              {

                FirebaseFirestore.instance
                    .collection("Users")
                    .doc(currentUser?.email)
                    .update({
                  "childcode": childcode,
                });
              }
              else

                {

                  if (childcode1.isNotEmpty)
                  {

                    FirebaseFirestore.instance
                        .collection("Users")
                        .doc(currentUser?.email)
                        .update({
                      "childcode2": childcode1,
                      "childcode": childcode,

                    });
                  }
                  else

                    {
                      if (childcode1.isNotEmpty && childcode2.isNotEmpty)
                      {

                        FirebaseFirestore.instance
                            .collection("Users")
                            .doc(currentUser?.email)
                            .update({
                          "childcode2": childcode,
                        });
                      }
                      else

                        {
                          if (childcode2.isNotEmpty)
                          {

                            FirebaseFirestore.instance
                                .collection("Users")
                                .doc(currentUser?.email)
                                .update({
                              "childcode": childcode,
                            });
                          }
                        }
                    }

                    }


        });

        var registrierungen = document["registrierungen"];
        int reg = (registrierungen + 1);
        FirebaseFirestore.instance
            .collection("Kinder")
            .doc(childcode)
            .update({"registrierungen": reg});
      }

    });
  }

  /// Eltern Mail in Kind hinzufügen

  void addElternMail(String childcode) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(childcode)
        .update({
      "eltern" : currentUser?.email,
    });
  }



  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(

      child: Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0.0,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            title: Text("Kind hinzufügen",
            ),
          ),
        body:
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Text("Bitte den Aktivierungsschlüsser von Ihrer Kita eingeben:"),
                  const SizedBox(height: 20,),
                  MyTextField(hintText: "Aktivierungsschlüssel...", obscureText: false, controller: textController),
                  const SizedBox(height: 20,),
                  TextButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("Kinder")
                          .doc(textController.text)
                          .get()
                          .then((DocumentSnapshot document) {
                        if (document.exists) {
                          addChildCode(textController.text);
                          addElternMail(textController.text);
                          // Textfeld leeren nach Eingabe
                          textController.clear();
                          //Box schliessen
                          Navigator.pop(context);
            
                          displayMessageToUser("Kind wird hinzugefügt...", context);
                        }
                        else {
                          return displayMessageToUser("Aktivierungscode ist unglütig.", context);
                        }
                      }
                      );
                    }, child: Text("Kind Hinzufügen"),
                  ),
            
                  const SizedBox(height: 30,),
            
                StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(currentUser?.email)
                    .snapshots(),
                builder: (context, snapshot) {
                if (snapshot.hasData) {
                final userData = snapshot.data?.data() as Map<String, dynamic>;
                final childcode = userData["childcode"];
                final childcode2 = userData["childcode2"];







                return Column(
                  children: [


                  if (childcode == "")


    Container(
    width: mediaQuery.size.width * 1,
    decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.inversePrimary,
    borderRadius: BorderRadius.circular(5),

    boxShadow: const [
    BoxShadow(
    color: Colors.grey,
    spreadRadius: 1,
    blurRadius: 3,
    offset: Offset(2, 4),
    ),
    ],
    //border: Border.all(color: Colors.black)
    ),
    padding: const EdgeInsets.only(left: 15, bottom: 15, right: 15, top: 15),
    margin: EdgeInsets.only(left: 10, right: 10, top: 10),

    child: Column(
    children: [
    const SizedBox(height: 5,),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text("Kind 1",
    style: TextStyle(color: Colors.black.withOpacity(0.3),
    fontSize: 20,
    ),
    ),

    ],
    ),
    ],
    ),

    ),




                  if (childcode != "")
                    StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
              .collection("Kinder")
              .doc(childcode)
              .snapshots(),
                    builder: (context, snapshot) {
    if (snapshot.hasData) {
      final userData2 = snapshot.data?.data() as Map<String, dynamic>;
      final child = userData2["child"];
      return

        Container(
          width: mediaQuery.size.width * 1,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inversePrimary,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 2,
              color: Theme.of(context).colorScheme.secondary,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(2, 4),
              ),
            ],
            //border: Border.all(color: Colors.black)
          ),
          padding: const EdgeInsets.only(left: 15, bottom: 15, right: 15, top: 15),
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),

          child: Column(
            children: [
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(child,
                    style: TextStyle(color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                   Icon(Icons.check,
                    size: 25,
                  ),
                ],
              ),
            ],
          ),
        );
    }
    return Text("");

                    }
                    ),

                    SizedBox(
            height: 20,
                    ),
                    IconButton(
            icon:  Icon(Icons.change_circle_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ), onPressed: () =>
                    _firestore
              .collection("Users")
              .doc(currentUser?.email)
              .update({
            "childcode": childcode2,
            "childcode2": childcode,
              }),
                    ),

                    if (childcode2 == "")


                      Container(
                        width: mediaQuery.size.width * 1,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(2, 4),
                            ),
                          ],
                          //border: Border.all(color: Colors.black)
                        ),
                        padding: const EdgeInsets.only(left: 15, bottom: 15, right: 15, top: 15),
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),

                        child: Column(
                          children: [
                            const SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Kind 2",
                                  style: TextStyle(color: Colors.black.withOpacity(0.3),
                                    fontSize: 20,
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),

                      ),


                    if (childcode2 != "")

                    StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
            .collection("Kinder")
            .doc(childcode2)
            .snapshots(),
                  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final userData3 = snapshot.data?.data() as Map<String, dynamic>;
      final child2 = userData3["child"];


      return
        Container(
          width: mediaQuery.size.width * 1,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inversePrimary,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(2, 4),
              ),
            ],
            //border: Border.all(color: Colors.black)
          ),
          padding: const EdgeInsets.only(left: 15, bottom: 15, right: 15, top: 15),
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),

          child: Column(

            children: [
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(child2,
                    style: TextStyle(color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  Text(""),
                ],
              ),
            ],
          ),
        );
    }
    return Text("");
                  }
                  ),
                  ],
                );


                }
                return Text("");
                }
            
            
            
            
                ),
            
            
                ],
              ),
            ),
          ),
    ),
    );
    }
    }






