import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class FirestoreDatabaseChild {


  // get Collection of children
  final CollectionReference children = FirebaseFirestore.instance.collection("Kinder");


  final currentUser = FirebaseAuth.instance.currentUser;


  DateTime absenzBis = DateTime.now().subtract(const Duration(days:1));

  /// Kita Seite




  // READ: get Child-Data from Database nach Gruppe

  Stream<QuerySnapshot> getChildrenStream1() {
    final postStream = FirebaseFirestore.instance
        .collection("Kinder")
        .where("kita", isEqualTo: currentUser?.email)
        .where("group", isEqualTo: '1')
        .snapshots();
    return postStream;
  }

  Stream<QuerySnapshot> getChildrenStream2() {
    final postStream = FirebaseFirestore.instance
        .collection("Kinder")
        .where("kita", isEqualTo: currentUser?.email)
        .where("group", isEqualTo: '2')
        .snapshots();
    return postStream;
  }

  Stream<QuerySnapshot> getChildrenStream3() {
    final postStream = FirebaseFirestore.instance
        .collection("Kinder")
        .where("kita", isEqualTo: currentUser?.email)
        .where("group", isEqualTo: '3' )
        .snapshots();
    return postStream;
  }



// Daten ändern

  void updateChild(String docID, String newGroup) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(docID)
        .update({
      'group': newGroup,
      'timestamp': Timestamp.now(),
    });
  }

  void updateSwitch(String docID, bool active) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(docID)
        .update({
      'switch': active,
    });
  }


  void updateSwitchAllOn(String group) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .where('group', isEqualTo: group)
        .where("kita", isEqualTo: currentUser?.email)
        .where("absenz", isEqualTo: "nein")
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) {
        doc.reference
            .update({
          'switch': true,
        });
      });
    });
        }





// Daten löschen
  void deleteChild(String docID, String group) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(docID)
        .update({
      'active': false,
      'kita': "",

    });

    FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .get()
        .then((DocumentSnapshot document) {
      int anzahlKinder = document['anzahlKinder$group'];
      int anzahlKinderUpdate = (anzahlKinder - 1);

      FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser?.email)
          .update({'anzahlKinder$group': anzahlKinderUpdate});
    });


  }

  //Absenz entfernen
  void deleteAbsenz(String docID) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(docID)
        .update({
      'absenz': "nein",
      'anmeldung': "Neprítomná / ý",
      'absenzText': "",
      'absenzBis': DateTime.now(),
      'absenzVon': DateTime.now(),
    });
  }




  //Info Felder
  Stream<QuerySnapshot> getChildrenInofs(String docID) {
    final infoStream = FirebaseFirestore.instance
        .collection("Kinder")
        .doc(docID)
        .collection("Info_Felder")
        .snapshots();

    return infoStream;
  }

  // Einwilligungen Felder
  Stream<QuerySnapshot> getChildrenEinwilligungen(String docID) {
    final infoStream = FirebaseFirestore.instance
        .collection("Kinder")
        .doc(docID)
        .collection("Einwilligungen_Felder")
        .snapshots();

    return infoStream;
  }



  /// Eltern Seite



  void updateChildEinwilligungen(String childcode, String field, String einwilligung) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(childcode)
        .collection("Einwilligungen_Felder")
        .doc(field)
        .update({
      "value": einwilligung,
    });
  }


}


