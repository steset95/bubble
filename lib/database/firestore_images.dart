import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart';




class Storage {
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
  try {

    await storage.ref('images/$formattedDate/$docID/$fileName').putFile(file);
  } on firebase_core.FirebaseException catch (e) {
    print(e);
  }
}


  Future<void> uploadFileMultiple(

      String filePath,
      String fileName,
      String docID,
      ) async {
    File file = File(filePath);
    String currentDate = DateTime.now().toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    try {

      await storage.ref('images/$formattedDate/$docID/$fileName').putFile(file);
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

    ListResult result =
    await FirebaseStorage.instance.ref('/images/$formattedDate/$docID').listAll();
    await Future.wait(
        result.items.map((e) async => await e.delete().then((_) => print('Successfully deleted' ))));

  }

  Future<void> deleteImage(String path) async {

    String currentDate = DateTime.now().toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren


    await FirebaseStorage.instance.refFromURL(path).delete();


  }









}
