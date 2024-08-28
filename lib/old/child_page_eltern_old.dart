/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/database/firestore_child.dart';
import 'package:socialmediaapp/pages/eltern_pages/images_page_eltern_old.dart';
import '../../components/my_image_upload_button_profile.dart';
import '../../components/my_image_viewer.dart';
import '../../components/my_image_viewer_profile.dart';
import '../../database/firestore_images.dart';
import 'einwilligungen_kind_page_eltern.dart';
import 'infos_kind_page_eltern.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class ChildPageEltern extends StatefulWidget {

  ChildPageEltern({super.key});

  @override
  State<ChildPageEltern> createState() => _ChildPageElternState();
}



class _ChildPageElternState extends State<ChildPageEltern> {

  // Verweis auf FirestoreDatabaseChild

  final FirestoreDatabaseChild firestoreDatabaseChild = FirestoreDatabaseChild();

 // Text Controller für Abfrage des Inhalts im Textfeld

  final TextEditingController textController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;




  Future<void> listImages(String childcode) async {
    String currentDate = DateTime.now().toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    firebase_storage.ListResult result =
    await firebase_storage.FirebaseStorage.instance.ref('/images/$formattedDate/$childcode').listAll();
    result.items.forEach((firebase_storage.Reference ref) {
      String bilderName = ref.name;
      print('Found file: $ref');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey,
          title: const Text(
            "Aktivierungsschlüssel",
            style: TextStyle(color: Colors.white),
          ),
          content: Row(
            children: [
              Container(
                height: 200,
                width: 200,
                child: ImageViewer(childcode: childcode, fileName: bilderName),
              ),
            ],
          ),
          actions: [
            // Cancel Button
            TextButton(
              child: const Text("Schliessen",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    });
  }





    /// Code hinzufügen

  void addChildCode(String childcode) {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .update({
      "childcode" : childcode,
    });
  }

  /// Eltern Mail in Kind hinzufügen

  void addElternMail(String childcode) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(childcode)
        .update({
      "eltern" : currentUser?.email,
    });
  }


  /// Kita Mail in User hinzufügen

  void getKitaEmail(String childID) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(childID)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        String kita = document["kita"];
        FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser?.email)
            .update({
          "kitamail" : kita,
      });
            }
    });
  }


  /// Kind hinzufügen Altert Dialog

  void openChildBoxCode({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // Text Eingabe
        content: TextField(
          //Abfrage Inhalt Textfeld - oben definiert
          controller: textController,
        ),
        actions: [
          // Speicher Button
          ElevatedButton(
            onPressed: () {
                addChildCode(textController.text);
                addElternMail(textController.text);
              // Textfeld leeren nach Eingabe
              textController.clear();
              //Box schliessen
              Navigator.pop(context);
            },
            child: Text("Add"),
          )
        ],
      ),
    );
  }




/// Start Widget


  @override
  Widget build(BuildContext context)  {
    String currentDate = DateTime.now().toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        title: Text("Kind"),
      ),

      /// Neus Kind Button
      floatingActionButton: FloatingActionButton(
      onPressed: openChildBoxCode,
        child: const Icon(Icons.add),
      ),

      body:
      StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
        .doc(currentUser?.email)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final userData = snapshot.data?.data() as Map<String, dynamic>;
        final childcode = userData["childcode"];
        if (snapshot.hasData) {
          return Column(
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  ///Einwilligungen Kind

                  Container(
                    width: 60,
                    height: 60,
                    color: Colors.red,
                    child:  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              EinwilligungenKindPageEltern(
                                  childcode: childcode)),
                        );
                      },
                      child: Container(
                          color: Colors.red,
                          height: 80,
                          width: 100,
                          child: const Text("Erlaubnis Kind")
                      ),
                    ),
                  ),



                  /// Profilbild
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .primary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      children: [
                        ImageViewerProfile(childcode: childcode),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ImageUploadProfile(childcode: childcode),
                          ],
                        ),
                      ],
                    ),

                  ),

                  /// Infos Kind

                  Container(
                    width: 60,
                    height: 60,
                    color: Colors.red,
                    child:  GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        ImagesPageEltern(
                                            childcode: childcode)),
                                  );
                                },
                                child: Container(
                                    color: Colors.red,
                                    height: 80,
                                    width: 100,
                                    child: const Text("Infos Kind")
                                ),
                              ),
                  ),

                ],
              ),


              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [


                  Container(
                    color: Colors.green,
                    height: 300,
                    width: 300,

                    /// Kind Raport nach childcode anzeigen

                    // childcode abholen und prüfen ob leer
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Users")
                            .doc(currentUser?.email)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final userData = snapshot.data?.data() as Map<
                                String,
                                dynamic>;
                            if (userData["childcode"] != "") {
                              getKitaEmail(userData["childcode"]);

                              // Raport anzeigen
                              return StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("Kinder")
                                      .doc(userData["childcode"])
                                      .collection(formattedDate)
                                      .orderBy('TimeStamp', descending: true)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    List<Row> raportWidgets = [];
                                    if (snapshot.hasData) {
                                      final raports = snapshot.data?.docs
                                          .reversed.toList();
                                      for (var raport in raports!) {
                                        final raportWidget = Row(

                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,

                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                  6.0),
                                              child: Row(
                                                children: [
                                                  Text(raport['RaportTitle']),
                                                  Text(raport['RaportText']),
                                                ],
                                              ),

                                            ),
                                          ],
                                        );
                                        raportWidgets.add(raportWidget);
                                      }
                                    }
                                    return
                                      ListView(
                                        children: raportWidgets,
                                      );
                                  }
                              );
                            }
                            else
                              Text("Bitte Kind hinzufügen1");
                          }
                          return Text("Bitte Kind hinzufügen2");
                        }
                    ),
                  ),

                  TextButton(
                    onPressed: () {

                      listImages(childcode);
                    },
                    child: Text("Uložiť"),
                  ),

                ],
              ),
              const SizedBox(height: 50),
              Container(


              ),
              Container(
                  width: 200,
                  height: 200,
                  color: Colors.red,

              ),

            ],
          );
        }
      }
      return Text("Bitte Kind hinzufügen3");
    }
      )
      );

                }
            }
*/