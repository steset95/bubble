
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../components/my_progressindicator.dart';
import '../../helper/notification_controller.dart';
import '../../database/firestore_images.dart';



class ImagesPageEltern extends StatefulWidget {
  final String childcode;
  final String date;


  ImagesPageEltern({
    super.key,
    required this.childcode,
    required this.date,
  });



  @override
  State<ImagesPageEltern> createState() => _ImagesPageElternState();
}

class _ImagesPageElternState extends State<ImagesPageEltern> {

  /// Notification
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => NotificationController().notificationCheck());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  /// Notification


  Future<List<String>> getImagePath(String childcode, String date) async {
    ListResult result =
    await FirebaseStorage.instance.ref('/images/$date/$childcode').listAll();
    return await Future.wait(
      result.items.map((e) async => await e.getDownloadURL()),
    );
  }



  Widget buildGallery(String childcode, String date) {
    final mediaQuery = MediaQuery.of(context);
    return FutureBuilder(
      future: getImagePath(childcode, date),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(

            child: ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const PageScrollPhysics(),
              itemCount: snapshot.data!.length,
              shrinkWrap: true,

              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
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
                              child: InteractiveViewer(
                                child: CachedNetworkImage(
                                    imageUrl: snapshot.data![index],
                                    placeholder: (context, url) => ProgressWithIcon(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                    fit: BoxFit.scaleDown
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  color: Colors.white,
                                  height: 80,
                                  child: IconButton(
                                    onPressed:  () => Navigator.pop(context),
                                    icon: const Icon(Icons.close,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child:
                  CachedNetworkImage(
                    imageUrl: snapshot.data![index],
                      placeholder: (context, url) => ProgressWithIcon(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text("Obrázky",
          ),
        ),
      body: SingleChildScrollView(
        child:
        Column(
          children: [
            buildGallery(widget.childcode, widget.date)
          ],
        ),
        )
    );
    }
    }






