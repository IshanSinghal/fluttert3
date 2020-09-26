import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:json_serializable/json_serializable.dart';
// import 'dart:convert';

class MyTerminal extends StatefulWidget {
  @override
  _MyTerminalState createState() => _MyTerminalState();
}

class _MyTerminalState extends State<MyTerminal> {
  var msgtextcontroller = TextEditingController();

  var fs = FirebaseFirestore.instance;
  var authc = FirebaseAuth.instance;

  String cmd, ans;
  String getans = "Output window";
  String newvalue;

  mydata() async {
    var url = 'http://192.168.1.9/cgi-bin/ft3.py?x=$cmd';
    var r = await http.get(url);
    var data = r.body;
    // print(data);
    ans = data;
  }

  getansdisplay() async {
    // var firebaseUser = authc.currentUser;
    await fs.collection("commands").doc(newvalue).get().then((value) {
      var data = value.data;
      print((data()['ans']));
      setState(() {
        getans = data()['ans'];
      });
    });

    // await fs.collection("commands").doc(newvalue.id).get().then((value) {
    //   print(value.data);
    //   print("yes");
    //   // setState(() {
    //   //   getans = value.data['ans'];
    //   // });
    // });
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var signInUser = authc.currentUser.email;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Terminal'),
        ),
        body: SingleChildScrollView(
          // alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    // padding: EdgeInsets.only(),
                    width: deviceWidth * 0.70,
                    child: TextField(
                      controller: msgtextcontroller,
                      decoration: InputDecoration(
                          hintText: 'Enter command',
                          border: new UnderlineInputBorder(
                              borderSide: new BorderSide(
                            color: Colors.black,
                          ))),
                      onChanged: (value) {
                        cmd = value;
                      },
                    ),
                  ),
                  Container(
                    width: deviceWidth * 0.20,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid),
                      ),
                      child: Text('SEND'),
                      onPressed: () async {
                        msgtextcontroller.clear();
                        await mydata();
                        await fs.collection("commands").add({
                          "cmd": cmd,
                          "ans": ans,
                          "sender": signInUser,
                        }).then((value) {
                          // ignore: deprecated_member_use
                          print(value.id);
                          print(cmd);
                          print(ans);
                          newvalue = value.id;
                          getansdisplay();
                        });
                        print(signInUser);
                        // var document = fs.collection("commands").doc(newvalue);
                        // document.get() => then((document) {
                        //   print(document("ans"));
                        // });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(10),
                child: Text(getans ?? "Output..."),
              ),
              // ListView(
              //   child: Container(
              //     width: deviceWidth * 0.90,
              //     child: Text(getans ?? "Output..."),
              //   ),
              // ),
            ],
          ),
        ));
/*    return Scaffold(
      appBar: AppBar(
        title: Text('terminal'),
      ),
      body: Container(
        width: deviceWidth * 0.20,
        child: FlatButton(
          child: Text('SEND'),
          onPressed: mydata,
        ),
      ),
    ); */
  }
}
