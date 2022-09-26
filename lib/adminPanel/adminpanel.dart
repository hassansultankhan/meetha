import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
