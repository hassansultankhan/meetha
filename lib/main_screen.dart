import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    
    screens
    return Scaffold(

      appBar: AppBar(
        title: Text("ho jae meehta!"),
        centerTitle: true,
        actions: [],
        backgroundColor: (Color.fromARGB(255, 211, 164, 21)),
      ),

      body: screens[],

      
    );
  }
}