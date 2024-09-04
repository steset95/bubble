

/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bubble/database/firestore_images_profile.dart';

import '../helper/helper_functions.dart';


class ImageUploadProfile extends StatefulWidget {
  final String childcode;

  const ImageUploadProfile({
    super.key,
    required this.childcode,

  });


  @override
  State<ImageUploadProfile> createState() => _ImageUploadProfileState();
}

/*

Für Upload:  ImageUpload(),

 */

final currentUser = FirebaseAuth.instance.currentUser;

class _ImageUploadProfileState extends State<ImageUploadProfile> {




  @override
  Widget build(BuildContext context) {
    final StorageProfile storage = StorageProfile();
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            final results = await FilePicker.platform.pickFiles(
              allowMultiple: false,
              type: FileType.custom,
              allowedExtensions: ['png', 'jpg'],
            );
            if (results == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Kein Bild ausgewählt")
                ),
              );
              return null;
            }
            final path = results.files.single.path!;
            final fileName = results.files.single.name;

            storage
                .uploadFileProfile(path, fileName, widget.childcode)
                .then((value) => print('Erledigt'));
            return
              displayMessageToUser("Bild wird hochgeladen...", context);
          },

          icon: Icon(
            Icons.photo,
            color: Theme.of(context).colorScheme.inversePrimary,
            size: 20.0,
          ),
        ),

      ],
    );
  }
}
*/