/*
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bubble/database/firestore_images.dart';


class ImageViewer extends StatefulWidget {
  final String childcode;
  final String fileName;

  const ImageViewer({
    super.key,
    required this.childcode,
    required this.fileName,

  });


  @override
  State<ImageViewer> createState() => _ImageViewerState();

}



class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    String currentDate = DateTime.now().toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    final childcode = widget.childcode;
    final Storage storage = Storage();
    final fileName = widget.fileName;
    return
      Row(
      children: [
        FutureBuilder(
            future: storage.downloadURL('$formattedDate/$childcode/$fileName'),
            builder: (BuildContext context,
                AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData){

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 100,
                    height: 100,
                    child: Image.network(
                      snapshot.data!,
                      fit: BoxFit.cover,
                    ),
                  ),
                );

              }
              if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return Container();
            }
        ),
      ],
    );
  }
}*/
