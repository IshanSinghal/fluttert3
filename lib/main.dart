import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttert3/screens/terminal.dart';
import 'package:fluttert3/screens/home.dart';
import 'package:fluttert3/screens/login.dart';
import 'package:fluttert3/screens/reg.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "home",
      routes: {
        "home": (context) => MyHome(),
        "reg": (context) => MyReg(),
        "login": (context) => MyLogin(),
        "terminal": (context) => MyTerminal(),
      },
    ),
  );
}
