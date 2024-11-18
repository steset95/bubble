import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;




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
    await storage.ref('images/profile/$childcode/Profilbild').putFile(file);
}

  // Files Anzeige Funktion (nicht als Bild, einfach Liste des Files) - not in use

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results = await storage.ref('images').listAll();

    for (var ref in results.items) {
    }
    return results;
  }
  // Bilder anzeigen

  Future<String> downloadURL(String imageName) async {
    String downloadURL = await storage.ref('images/$imageName').getDownloadURL();

    return downloadURL;


  }
}
