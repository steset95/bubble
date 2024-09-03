
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../components/my_progressindicator.dart';
import '../../helper/notification_controller.dart';
import '../../database/firestore_images.dart';
import '../../helper/helper_functions.dart';



class ImagesPageKita extends StatefulWidget {
  final String docID;

  ImagesPageKita({
    super.key,
    required this.docID
  });



  @override
  State<ImagesPageKita> createState() => _ImagesPageKitaState();
}

class _ImagesPageKitaState extends State<ImagesPageKita> {


  Future<List<String>> getImagePath(String docID, ) async {
    String currentDate = DateTime.now().toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    ListResult result =
    await FirebaseStorage.instance.ref('/images/$formattedDate/$docID').listAll();
    return await Future.wait(
      result.items.map((e) async => await e.getDownloadURL()),
    );
  }

  Widget buildGallery(String docID) {

    final Storage storage = Storage();
    return FutureBuilder(
      future: getImagePath(docID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {

          return const CircularProgressIndicator();
        }
        return Container(
          child:
            GridView.builder(
            physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
        ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) =>
                GestureDetector(
                  onTap:  () {
                    showGeneralDialog(
                      context: context,
                      barrierColor: Colors.white, // Background color
                      //barrierDismissible: false,
                      transitionDuration: Duration(milliseconds: 400),
                      pageBuilder: (context, __, ___) {
                        return Column(
                          children: <Widget>[
                            Row(
                              children: [
                                Container(
                                  color: Colors.white,
                                  height: 80,
                                )
                              ],
                            ),
                            Expanded(
                              flex: 5,
                              child: CachedNetworkImage(
                                  imageUrl: snapshot.data![index],
                                  placeholder: (context, url) => ProgressWithIcon(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                  fit: BoxFit.scaleDown,
                                
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              height: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    child: const Text("Zrušiť",
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  const SizedBox(width: 50),
                                  TextButton(
                                      child: const Text("Vymazať",
                                      ),
                                      onPressed: () {
                                        storage.deleteImage(snapshot.data![index]);
                                        setState(() {});
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        return displayMessageToUser("Fotka bude vymazaná......", context);
                                      }
                                  ),

                                ],
                              ),
                            ),
                          ],
                        );

                      },
                    );
                  },
                  child: CachedNetworkImage(
                                imageUrl: snapshot.data![index],
                                fit: BoxFit.fitHeight,
                                placeholder: (context, url) => ProgressWithIcon(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                ),
          ),
        );
      },
    );
  }





  void openDeleteDialog({String? docID}) {
    final Storage storage = Storage();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Potvrdiť vymazanie?"
        ),
        actions: [
          TextButton(
            onPressed: () async {
              storage.deleteImages(widget.docID);
              setState(() {});
              Navigator.pop(context);
              Navigator.pop(context);
              return displayMessageToUser("Fotky budú vymazané......", context);

            },
            child: Text("Vymazať"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Zrušiť"),
          )
        ],
      ),
    );
  }




  Widget showButtons () {
    return
      GestureDetector(
        onTap: openDeleteDialog,
        child: Container(
          child: Row(
            children: [
              Text("Vymazať fotky"),
              const SizedBox(width: 10),
              Icon(Icons.delete_outline,
              color: Colors.black,
              ),
              const SizedBox(width: 15),
            ],
          ),
        ),
      );
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text("Fotky dnes",
          ),
          actions: [
            showButtons(),
          ],
        ),
      body: SingleChildScrollView(

        child:
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              buildGallery(widget.docID),
            ],
          ),
        )


        )
    );
    }
    }






