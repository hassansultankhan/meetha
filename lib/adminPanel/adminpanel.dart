import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meetha/productClass.dart';

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

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('Details');

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
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
                ElevatedButton(
                    onPressed: () async {
                      final String title = titleController.text;
                      final String vendor = vendorController.text;
                      final String vendorLocation = vendorController.text;
                      final double? price =
                          double.tryParse(priceController.text);
                      if (price != null) {
                        await _products.add({
                          "title": title,
                          "vendor": vendor,
                          "vendorLocation": vendorLocationController,
                          "price": priceController,
                          "size": sizeController,
                        });

                        titleController.text = "";
                        vendorController.text = "";
                        vendorLocationController.text = "";
                        priceController.text = "";
                        sizeController.text = "";

                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text("Add product")),
              ],
            ),
          );
        });
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      titleController.text = documentSnapshot['title'];
      vendorController.text = documentSnapshot['vendor'];
      vendorLocationController.text = documentSnapshot['vendorLocation'];
      priceController.text = documentSnapshot['price'].toString();
      sizeController.text = documentSnapshot['size'].toString();
    }

    await showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
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
                      final double? size = double.tryParse(sizeController.text);
                      if (price != null) {
                        await _products.doc(documentSnapshot!.id).update({
                          "title": title,
                          "vendor": vendor,
                          "vendorlocation": vendorLocation,
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
          );
        });
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
                          Text(documentSnapshot['name']),
                          Text(documentSnapshot['vendor']),
                          Text(documentSnapshot['vendorLocation']),
                          Text(documentSnapshot['price']),
                          Text(documentSnapshot['size']),
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
}
