import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
class personal extends StatefulWidget {
  static FirebaseApp _app;
  static FirebaseUser _user;

  personal(FirebaseApp app,FirebaseUser user){
    _user = user;
    _app = app;
  }

  @override
  _personalState createState() => _personalState();
}

class _personalState extends State<personal> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black38,
          width: 2.0,

        ),
          boxShadow: [new BoxShadow(
            color: Colors.black,
            blurRadius: 20.0,
          ),]
      ),
      child: new Text('HELLO WOLRDD'),
    );
  }
}



