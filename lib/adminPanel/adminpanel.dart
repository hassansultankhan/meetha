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

  String imageUrl = '';
  bool cameraButtonPressed = false;
  bool test = false;
  // GlobalKey<TextField> key = GlobalKey();
  bool loadingStatus = false;
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('Details');

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    loadingStatus = false;
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
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
                    style:
                        TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
                TextField(
                  // key: key,
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'TITLE'),
                ),
                TextField(
                  controller: vendorController,
                  decoration: const InputDecoration(labelText: 'VENDOR'),
                ),
                TextField(
                  controller: vendorLocationController,
                  decoration:
                      const InputDecoration(labelText: 'VENDOR LOCATION'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'PRICE'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: sizeController,
                  decoration: const InputDecoration(labelText: 'SIZE'),
                ),
                const SizedBox(
                  height: 10,
                ),
                
                  IconButton(
                      icon: 
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      
                      const Icon(

                        Icons.camera_alt,
                        size: 30),


                        Spacer(),
                         test?
                         Container(
                        child: const SizedBox(
                          height: 30, width: 30,
                          
                          child:  CircularProgressIndicator(),
                        ),
                      )
                      :
                      Container() 
                      ]
                      ),
                        

                      onPressed: () async{ 
                        setState(() {
                          test = true;
                        });
                        setState(() {
                          
                        });
                        await _ImageLoad();
                        setState(() {
                          test = false;
                        });
                  
                      }
                      
                      // async { await  _ImageLoad()
                      //       .then((_camerabuttonpressed) => _camerabuttonpressed
                      //           ? const SizedBox(
                      //               child: CircularProgressIndicator(
                      //                           strokeWidth: 7,
                      //                         ))
                      //                       : null);
                                
                               
                      // }
                    
    
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: loadingStatus ? () => submitData() : null,
                  child: const Text("Add product"),
                ),
              ],
            ),
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
  Future<bool> _ImageLoad() async {

    
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    // to remove focus from text field
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    print('$file?.path');
    setState(() {
      cameraButtonPressed = true;
    });

    if (file == null) {
      setState(() {
        loadingStatus = false;
      });
      return loadingStatus;
    } 
    else {
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
          print("working1");
          
          setState(() {
            cameraButtonPressed = false;
            loadingStatus = true;
           
            print("working2");
          });
          }
          return cameraButtonPressed;
          }


      catch (error) {
        print('problem with fetching imageUrl');
        return false;
      }
    }
  }

  submitData() async {
    if (imageUrl.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please add a Picture')));
      return;
    }
    // if (key.currentState!.validate()){

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
}
