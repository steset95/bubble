import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class FirestoreDatabaseChild {


  // get Collection of children
  final CollectionReference children = FirebaseFirestore.instance.collection("Kinder");


  final currentUser = FirebaseAuth.instance.currentUser;


  DateTime absenzBis = DateTime.now().subtract(const Duration(days:1));

  /// Kita Seite


  void addChild(String child, String group) async {
    FirebaseFirestore.instance
        .collection("Kinder")
        .add({
      'child': child,
      'group': '1',
      'anmeldung': "Abgemeldet",
      'absenzText': "",
      'absenz': "nein",
      "absenzBis": absenzBis,
      'timeStamp': Timestamp.now(),
      'kita': currentUser?.email,
      'abholzeit': "",
      'geschlecht': "keine Angabe",
      'geburtstag': "",
      'personen': "",
      'alergien': "",
      'krankheiten': "",
      'medikamente': "",
      'impfungen': "",
      'kinderarzt': "",
      'krankenkasse': "",
      'bemerkungen': "",
      'eltern': "",
      'fotosSocialMedia': "nicht erlaubt",
      'fotosApp': "nicht erlaubt",
      'nagellack': "nicht erlaubt",
      'schminken': "nicht erlaubt",
      'fieber': "nicht erlaubt",
      'sonnencreme': "nicht erlaubt",
      'fremdkoerper': "nicht erlaubt",
      'homoeopathie': "nicht erlaubt",
      'shownotification': "0",
      'registrierungen': 0,
      'switch': true,


    });
      }




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
  void deleteChild(String docID) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(docID)
        .delete();
  }

  //Absenz entfernen
  void deleteAbsenz(String docID) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(docID)
        .update({
      'absenz': "nein",
      'anmeldung': "Abgemeldet",
      'absenzText': "",
      'absenzBis': DateTime.now(),
    });
  }




  /// Eltern Seite

  void updateChildEinwilligungen(String childcode, String field, String einwilligung) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(childcode)
        .update({
      field: einwilligung,
    });


    Stream<QuerySnapshot> getChildrenStreamEltern() {
      final postStream = FirebaseFirestore.instance
          .collection("Kinder")
          .where("eltern", isEqualTo: currentUser?.email)
          .snapshots();
      return postStream;
    }


  }
}


