import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart';




class StorageProfile {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;









// Upload Funktion

Future<void> uploadFileProfile(

String filePath,
String fileName,
String childcode,
) async {
  File file = File(filePath);
  try {
    await storage.ref('images/profile/$childcode/Profilbild').putFile(file);
  } on firebase_core.FirebaseException catch (e) {
    print(e);
  }
}

  // Files Anzeige Funktion (nicht als Bild, einfach Liste des Files) - not in use

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results = await storage.ref('images').listAll();

    results.items.forEach((firebase_storage.Reference ref) {
      print('XXXXX: $results');
    });
    return results;
  }
  // Bilder anzeigen

  Future<String> downloadURL(String imageName) async {
    String downloadURL = await storage.ref('images/$imageName').getDownloadURL();

    return downloadURL;


  }
}
