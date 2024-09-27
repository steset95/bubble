
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hugeicons/hugeicons.dart';
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

  final currentUser = FirebaseAuth.instance.currentUser;
  final Storage storage = Storage();


  Widget buildGallery(String docID) {

    String? kitamail = currentUser?.email;

    String currentDate = DateTime.now().toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10);

    return StreamBuilder(
      stream: storage.getImagesPath(docID, kitamail!, formattedDate),
      builder: (context, snapshot){

        final images = snapshot.data?.docs;

        if (snapshot.connectionState == ConnectionState.waiting)
          {
          return const CircularProgressIndicator();
        }
        else if (snapshot.hasData == false && snapshot.connectionState != ConnectionState.waiting)
        {
          return Text("...");
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
            itemCount: images?.length,
            itemBuilder: (context, index) {

              final path = images?[index];
              String image = path?['path'];

                return GestureDetector(
                  onTap:  () {
                    showGeneralDialog(
                      context: context,
                      barrierColor: Colors.white, // Background color
                      //barrierDismissible: false,
                      transitionDuration: Duration(milliseconds: 400),
                      pageBuilder: (context, __, ___) {
                        return Column(
                          children:
                          [
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
                              child: FutureBuilder(future: storage.downloadURL(image),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    if (snapshot.data != null)
                                      return
                                        CachedNetworkImage(
                                          imageUrl: snapshot.data!,
                                          fit: BoxFit.scaleDown,
                                          placeholder: (context, url) => ProgressWithIcon(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        );
                                    else
                                      return Text("");
                                  }
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
                                        storage.deleteImage(image, docID);
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
                  child: FutureBuilder(future: storage.downloadURL(image),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.data != null)
                          return
                            CachedNetworkImage(
                              imageUrl: snapshot.data!,
                              fit: BoxFit.fitHeight,
                              placeholder: (context, url) => ProgressWithIcon(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            );
                        else
                          return Text("");
                      }
                  ),
                );
      }
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
              const HugeIcon(
                icon: HugeIcons.strokeRoundedDelete02,
                color: Colors.black,
                size: 20,
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






