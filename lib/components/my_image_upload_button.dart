


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bubble/database/firestore_images.dart';
import 'package:hugeicons/hugeicons.dart';
import '../helper/helper_functions.dart';


class ImageUpload extends StatefulWidget {
  final String docID;

  const ImageUpload({
    super.key,
    required this.docID
  });


  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

/*

Für Upload:  ImageUpload(),

 */

final currentUser = FirebaseAuth.instance.currentUser;


class _ImageUploadState extends State<ImageUpload> {




  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Expanded(
      child:
        GestureDetector(
            onTap: () async {

              final results = await FilePicker.platform.pickFiles(
                allowMultiple: true,
                type: FileType.media,
                //allowedExtensions: ['png', 'jpg'],
              );
              if (results == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Žiadne obrázky vybrané…...")
                ),
                );
                return null;
              }


              final List<String?> filePaths = results.paths!;
              for (String? path in filePaths) {
                final fileName = path?.split('/').last;
                final docID = widget.docID;

              storage.uploadFile(path!, fileName!, docID);

              }
              Navigator.pop(context);
              displayMessageToUser("Obrázky sa nahrávajú…...", context);

            },

          child: Container(
            decoration: BoxDecoration(
              color: Colors.teal.shade600,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedCamera01,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Fotky",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
    );
  }
}
