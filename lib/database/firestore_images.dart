import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart';




class Storage {

  final currentUser = FirebaseAuth.instance.currentUser;

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;



// Upload Funktion

Future<void> uploadFile(

String filePath,
String fileName,
String docID,
) async {
  File file = File(filePath);
  String currentDate = DateTime.now().toString(); // Aktuelles Datum als String
  String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren

  String? kita = currentUser?.email;

  try {

    await storage.ref('images/$kita/$formattedDate/$fileName').putFile(file);

    FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .collection("Images")
        .doc(formattedDate)
        .collection(docID)
        .doc(fileName)
        .set({
      'path': '/$kita/$formattedDate/$fileName',
    });


  } on firebase_core.FirebaseException catch (e) {
    print(e);
  }
}


  // Files Anzeige Funktion (nicht als Bild, einfach Liste des Files) - not in use

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results = await storage.ref('images').listAll();

    results.items.forEach((firebase_storage.Reference ref) {
      print('File gefunden: $ref');
    });
    return results;
  }
   // Bilder anzeigen

  Future<String> downloadURL(String imageName) async {

    String downloadURL = await storage.ref('images/$imageName').getDownloadURL();

    return downloadURL;
}


  Future<void> deleteImages(String docID) async {

    String currentDate = DateTime.now().toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren

    FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .collection("Images")
        .doc(formattedDate)
        .collection(docID)
        .get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }

  Future<void> deleteImage(String path, String docID) async {

    String currentDate = DateTime.now().toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren

    FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .collection("Images")
        .doc(formattedDate)
        .collection(docID)
        .where("path", isEqualTo: path )
        .get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });

  }



  Stream<QuerySnapshot> getImagesPath(String docID, String kitamail, String date) {
    final imagesStream = FirebaseFirestore.instance
        .collection("Users")
        .doc(kitamail)
        .collection("Images")
        .doc(date)
        .collection(docID)
        .snapshots();

    return imagesStream;
  }






}
