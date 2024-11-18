


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../components/my_progressindicator.dart';
import '../../database/firestore_images.dart';



class ImagesPageEltern extends StatefulWidget {
  final String childcode;
  final String date;
  final String kitamail;


  const ImagesPageEltern({
    super.key,
    required this.childcode,
    required this.date,
    required this.kitamail,
  });



  @override
  State<ImagesPageEltern> createState() => _ImagesPageElternState();
}

class _ImagesPageElternState extends State<ImagesPageEltern> {



  final Storage storage = Storage();

  Widget buildGallery(String childcode, String date, String kitamail) {
    return StreamBuilder(
      stream: storage.getImagesPath(childcode, kitamail, date),
      builder: (context, snapshot){

        final images = snapshot.data?.docs;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const PageScrollPhysics(),
            itemCount: images?.length,
            shrinkWrap: true,

            itemBuilder: (context, index)
                {

                  final path = images?[index];
                  String image = path?['path'];


                return Padding(
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
                              child: FutureBuilder(future: storage.downloadURL(image),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    if (snapshot.data != null) {
                                      return
                                        CachedNetworkImage(
                                          imageUrl: snapshot.data!,
                                          fit: BoxFit.scaleDown,
                                          placeholder: (context, url) => ProgressWithIcon(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        );
                                    } else {
                                      return Text("");
                                    }
                                  }
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
                FutureBuilder(future: storage.downloadURL(image),
                    builder: (BuildContext context,
                        AsyncSnapshot<String> snapshot) {
                      if (snapshot.data != null) {
                        return
                          CachedNetworkImage(
                            imageUrl: snapshot.data!,
                            fit: BoxFit.fitWidth,
                            placeholder: (context, url) => ProgressWithIcon(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          );
                      } else {
                        return Text("");
                      }
                    }
                ),
              ),
            );
                }
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
            buildGallery(widget.childcode, widget.date, widget.kitamail)
          ],
        ),
        )
    );
    }
    }






