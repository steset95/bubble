


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:socialmediaapp/database/firestore_images.dart';
import '../helper/helper_functions.dart';
import 'my_child_select_switch.dart';


class ImageUploadMultiple extends StatefulWidget {
  final String group;

  const ImageUploadMultiple({
    super.key,
    required this.group
  });


  @override
  State<ImageUploadMultiple> createState() => _ImageUploadMultipleState();
}

/*

Für Upload:  ImageUpload(),

 */

final currentUser = FirebaseAuth.instance.currentUser;


class _ImageUploadMultipleState extends State<ImageUploadMultiple> {




  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final Storage storage = Storage();
    return Expanded(
      child:
        GestureDetector(

            onTap: () async {

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(
                          Radius.circular(10.0))),
                  title: Text("Kinder",
                    style: TextStyle(color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Container(
                      width: mediaQuery.size.width * 1,
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("Kinder")
                              .where("kita", isEqualTo: currentUser?.email)
                              .where("group", isEqualTo: widget.group)
                              .where("absenz", isEqualTo: "nein")
                              .snapshots(),
                          builder: (context, snapshot){
                            // wenn Daten vorhanden _> gib alle Daten aus
                            if (snapshot.hasData) {
                              List childrenList = snapshot.data!.docs;
                              //als Liste wiedergeben
                              return ListView.builder(
                                padding: EdgeInsets.only(bottom:15),
                                itemCount: childrenList.length,
                                itemBuilder: (context, index) {
                                  // individuelle Einträge abholen
                                  DocumentSnapshot document = childrenList[index];
                                  String docID = document.id;

                                  // Eintrag von jedem Dokument abholen
                                  Map<String, dynamic> data =
                                  document.data() as Map<String, dynamic>;
                                  String childText = data['child'];
                                  String anmeldungText = data['anmeldung'];
                                  bool active = data['switch'];

                                  bool istAngemeldet = anmeldungText == "Abgemeldet";

                                  var color = istAngemeldet ? Colors.grey : Colors.black;

                                  // als List Tile wiedergeben
                                  return Container(
                                    margin: EdgeInsets.only( right: 10, top: 10),

                                    child:
                                    ChildSelectSwitch(
                                      sectionName: childText,
                                      color: color,
                                      childcode: docID,
                                      active: active,
                                    ),


                                  );
                                },
                              );
                            }
                            else {
                              return const Text("");
                            }
                          }
                      ),
                    ),

                  ),

                  actions: [
                    // cancel Button
                    TextButton(
                      onPressed: () {
                        // Textfeld schliessen
                        Navigator.pop(context);
                      },
                      child: Text("Abbrechen"),
                    ),

                    // save Button
                    TextButton(
                      onPressed: () async {



                        final results = await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                          type: FileType.media,
                          // allowedExtensions: ['png', 'jpg'],
                        );
                        if (results == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("No Image selected")
                            ),
                          );
                          return null;
                        }


                        final List<String?> filePaths = results.paths!;
                        for (String? path in filePaths) {
                          final fileName = path?.split('/').last;

                          FirebaseFirestore.instance
                              .collection("Kinder")
                              .where('group', isEqualTo: widget.group)
                              .where("kita", isEqualTo: currentUser?.email)
                              .where("absenz", isEqualTo: "nein")
                              .where("switch", isEqualTo: true)
                              .get()
                              .then((snapshot) {
                            snapshot.docs.forEach((doc) {

                              FirebaseFirestore.instance
                                  .collection("Kinder")
                                  .doc(doc.reference.id)
                                  .get()
                                  .then((DocumentSnapshot document) {

                                String documentID = document.id;

                                storage.uploadFile(path!, fileName!, documentID);

                              });
                            });
                          });


                        }
                        Navigator.pop(context);
                        displayMessageToUser("Bilder werden hochgeladen...", context);



                      },
                      child: Text("Weiter"),
                    ),
                  ],
                ),
              );



            },

          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
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
                Icon(Icons.photo_camera_outlined,
                color: Theme.of(context).colorScheme.inversePrimary,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Bilder",
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
