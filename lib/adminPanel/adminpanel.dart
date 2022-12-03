import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class adminPanel extends StatefulWidget {
  const adminPanel({Key? key}) : super(key: key);

  @override
  State<adminPanel> createState() => _adminPanelState();
}

class _adminPanelState extends State<adminPanel> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController vendorController = TextEditingController();
  final TextEditingController vendorLocationController =
      TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();

  // String imageUrl = '';
  String imageUrl =
      "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBwgHBhUIBwgWFhUWFR0ZFxUYFxkaHhUWFx0WGRoaFhUZHSggJB8nIBUVJTEnJikrLi8uGB8zODMsNygtLisBCgoKDQ0NFQwNFS0dFRkrKysrKysrLSsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrK//AABEIAOEA4QMBIgACEQEDEQH/xAAbAAEBAAIDAQAAAAAAAAAAAAAABAIFAQMGB//EADgQAQACAQIBBwoEBgMAAAAAAAABAgMEEQUSITFBUWFxExQiMlJygZGxwTRCodEGMzVTYoIVIyT/xAAVAQEBAAAAAAAAAAAAAAAAAAAAAf/EABURAQEAAAAAAAAAAAAAAAAAAAAR/9oADAMBAAIRAxEAPwD7iAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADV6rV+X1XmuLJyY32m/bPs1ntBTn1+HFfydYm1vZrz/AD7GHluIZPU01a+9b9lGm0+LT05GGm338ZdwIfKcRpz2w0nwtMfVzTiOOL8jU45pP+XRPhZbswyY6ZKci9d4nqkGUTvG8OWtmL8MtvEzOKemOunfv2NjWYtG8SDkAAAAAAAAAAAAAAAAAAAAAEvEc1sWn2x+taeTXxkrocPmnm0xzdvXv279rr1H/ZxPHSeqJt8ej7rQQ6fPk0+XzbVz7l/ajsnvXvP/AMRZcnnEYotzcmJ2795/ZFh1WqyW5M6uax2zM7CV61jTJS8b0tE+DzOXLq64/K4tbNojp2mYmPGJdmhzTj4hTHh1M2rb1ubaN+vm+Ec4V6K9a3rNbRzSj4dM4cltHefV56+7PR8lqLP6HFMdo/NW0T8I3FXAAAAAAAAAAAAAAAAAAAAAAhz+hxXHaeutq/f7LYScTx2tgjLjj0qTyo+HTHyUYctM2KMuOeaY3gGg/iL8bHuR9ZSabkZdNbTTeImZi0TPRO28bb/F6TVaDT6q0WzU3mO/Z0/8Nov7c/ORI0Mb6Wl6ZOm1YiNpiY6Ymd5g4X/UaeLfTwbRTH8ufnKXR6XBotXGPPTn39C/VPdMdoRukOp9LieKsdUWn9NlsztHOh0P/o1N9X1erXwjpn4yKvgAAAAAAAAAAAAAAAAAAAAACWtmLcOyzatZnFad5iPyT1z4Nk4mNwY48lMlIvjtvE9cM0N9ByLcvR5ZpPXHTWf9Tl8Rx+thpbvi236SC51anDjz4Zx5Y5vp37pvLcQtzRpax3zbf6OPMsuf8bqN49ivNHx65BLhtqdXE6SuTekTtOSPzV7I723x0rjpFKRtEFKVx15NK7RHVDIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH/9k=";
  bool imageReady = false;
  bool cameraButtonPressed = false;

  bool loadingStatus = false;
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('Details');

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter ModalSheetSetState) {
              return Padding(
                padding: EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: MediaQuery.of(ctx).viewInsets.bottom),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Add new product",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: Colors.green)),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'TITLE',
                        labelStyle: textStylesBase.textfieldA,
                      ),
                    ),
                    TextField(
                      controller: vendorController,
                      decoration: const InputDecoration(
                          labelText: 'VENDOR',
                          labelStyle: textStylesBase.textfieldA),
                    ),
                    TextField(
                      controller: vendorLocationController,
                      decoration: const InputDecoration(
                          labelText: 'VENDOR LOCATION',
                          labelStyle: textStylesBase.textfieldA),
                    ),
                    TextField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: priceController,
                      decoration: const InputDecoration(
                          labelText: 'PRICE',
                          labelStyle: textStylesBase.textfieldA),
                    ),
                    TextField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: sizeController,
                      decoration: const InputDecoration(
                          labelText: 'SIZE',
                          labelStyle: textStylesBase.textfieldA),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      height: 50,
                      width: 50,
                      child: cameraButtonPressed
                          ? const CircularProgressIndicator(
                              strokeWidth: 6,
                            )
                          : IconButton(
                              icon: const Icon(Icons.camera_alt, size: 30),
                              onPressed: () async {
                                ModalSheetSetState(() {
                                  cameraButtonPressed = true;
                                });
                                await _ImageLoad();
                                ModalSheetSetState(() {
                                  cameraButtonPressed = false;
                                  loadingStatus = true;
                                });
                              },
                            ),
                    ),

                    const SizedBox(
                      height: 20,
                      child: Text("picture should be of 1x1 in dimension and "),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Container(
                      child: LayoutBuilder(builder: (context, constraints) {
                        if (imageReady = true) {
                          return imageDisplay();
                        } else {
                          return Text("data");
                        }
                        // ModalSheetSetState(){
                        // // imageReady=true;
                        // // return Image.network(imageUrl,
                        // //     fit: BoxFit.cover,
                        // //     height: 150,
                        // //     width: 150,
                        // //   );
                        // }
                      }),
                    ),

                    //   //  imageReady
                    //   //     ? const Text("image not loaded yet")
                    //   //     : Image.network(
                    //   //         imageUrl,
                    //   //         fit: BoxFit.cover,
                    //   //       ),
                    //   // height: 150,
                    //   // width: 150,
                    // ),
                    const SizedBox(
                      height: 10,
                    ),

                    ElevatedButton(
                      onPressed: loadingStatus ? () => submitData() : null,
                      child: const Text("Add product"),
                    ),
                  ],
                ),
              );
            },
          );
        });
    //showmodalbottomsheet end
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      titleController.text = documentSnapshot['title'];
      vendorController.text = documentSnapshot['vendor'];
      vendorLocationController.text = documentSnapshot['vendor Location'];
      priceController.text = documentSnapshot['price'].toString();
      sizeController.text = documentSnapshot['size'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.top + 20),
            child: Container(
              height: 650,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    autofocus: true,
                    controller: titleController,
                    decoration: const InputDecoration(labelText: "Title"),
                  ),
                  TextField(
                    controller: vendorController,
                    decoration: const InputDecoration(labelText: "Vendor"),
                  ),
                  TextField(
                    controller: vendorLocationController,
                    decoration:
                        const InputDecoration(labelText: "Vendor Location"),
                  ),
                  TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: priceController,
                    decoration: const InputDecoration(labelText: "Price"),
                  ),
                  TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: sizeController,
                    decoration: const InputDecoration(labelText: "Size"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final String title = titleController.text;
                        final String vendor = vendorController.text;
                        final String vendorLocation =
                            vendorLocationController.text;
                        final double? price =
                            double.tryParse(priceController.text);
                        final double? size =
                            double.tryParse(sizeController.text);
                        if (price != null) {
                          await _products.doc(documentSnapshot!.id).update({
                            "title": title,
                            "vendor": vendor,
                            "vendor Location": vendorLocation,
                            "price": price,
                            "size": size,
                          });
                          titleController.text = "";
                          vendorController.text = "";
                          vendorLocationController.text = "";
                          priceController.text = "";
                          sizeController.text = "";
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text("Update"))
                ],
              ),
            ),
          );
        });
    //  showmodalbottomsheet end
  }

  Future<void> _delete(String productid) async {
    await _products.doc(productid).delete();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("product delelted")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meetha Admin'),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: _products.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(documentSnapshot['title']),
                          Text(documentSnapshot['vendor']),
                          Text(documentSnapshot['vendor Location']),
                          Text(documentSnapshot['price'].toString()),
                          Text(documentSnapshot['size'].toString()),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _update(documentSnapshot);
                                  },
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    _delete(documentSnapshot.id);
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),
                          const SizedBox(
                            height: 2,
                          )
                        ],
                      ),
                    );
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        child: const Icon(Icons.add),
      ),
    );
  }

//function to load image on storage
  // Future<bool>
  _ImageLoad() async {
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    // to remove focus from text field
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    print('$file?.path');
    // setState(() {
    //   cameraButtonPressed = true;
    // });

    if (file == null) {
      setState(() {
        loadingStatus = false;
      });
      // return loadingStatus;
    } else {
      // String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      //not used

      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDir = referenceRoot.child('images');
      Reference referenceImage2Upload =
          referenceDir.child('${titleController.text}');

      try {
        await referenceImage2Upload.putFile(File(file.path));
        imageUrl = await referenceImage2Upload.getDownloadURL();
        if (imageUrl != null) {
          setState(() {
            cameraButtonPressed = false;
            loadingStatus = true;
            imageReady = true;
            print("$imageUrl");
          });
        }
        // return ;
        setState(() {
          loadingStatus = false;
        });
      } catch (error) {
        print('problem with fetching imageUrl');
        setState(() {
          loadingStatus = false;
        });
        // return false;
      }
    }
  }

  submitData() async {
    if (imageUrl.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please add a Picture')));
      return;
    }

    final String title = titleController.text;
    final String vendor = vendorController.text;
    final String vendorLocation = vendorController.text;
    final double? price = double.tryParse(priceController.text);
    final double? size = double.tryParse(sizeController.text);

    if (price != null && imageUrl != null) {
      await _products.add({
        "title": title,
        "vendor": vendor,
        "vendor Location": vendorLocation,
        "price": price,
        "size": size,
        "imageUrl": imageUrl,
      });

      titleController.text = "";
      vendorController.text = "";
      vendorLocationController.text = "";
      priceController.text = "";
      sizeController.text = "";
      imageUrl = "";

      Navigator.of(context).pop();
    }
  }

  imageDisplay() {
    if (imageReady = true) {
      Container(
        height: 150,
        width: 150,
        // child: Image.network(imageUrl, fit: BoxFit.scaleDown,),
      );
    }
  }
}

class textStylesBase {
  static const textfieldA =
      TextStyle(color: Colors.green, fontStyle: FontStyle.italic);
}
