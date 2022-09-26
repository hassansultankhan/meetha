// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:meetha/ProdCat1.dart';
import 'package:meetha/ProdCat2.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var screens = [
    ProdCat1(),
    ProdCat2(),
  ];
  int SelectedCat = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ho jae meehta!"),
        centerTitle: true,
        actions: [],
        backgroundColor: (Color.fromARGB(255, 211, 164, 21)),
      ),
      body: screens[SelectedCat],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xfffece20),
        selectedItemColor: Colors.brown[800],
        unselectedItemColor: Colors.brown,
        selectedFontSize: 20,
        currentIndex: SelectedCat,
        onTap: (int i) => BottomClick(i, context),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.food_bank), label: "Andrasay"),
          BottomNavigationBarItem(
              icon: Icon(Icons.food_bank), label: "Falooda noodles"),
        ],
      ),
    );
  }

  BottomClick(int index, BuildContext context) {
    setState(() {
      SelectedCat = index;
    });
  }
}
