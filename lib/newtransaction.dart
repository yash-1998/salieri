import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:salieri/customefloating.dart';
import 'package:salieri/privateuser.dart';
import 'package:salieri/transactions.dart';
import 'personal.dart';
import 'package:salieri/navigationdrawer.dart';
import 'package:salieri/expense.dart';
import 'package:salieri/Appuser.dart';

class Newtransaction extends StatefulWidget {
  @override
  _NewtransactionState createState() => _NewtransactionState();
}

class _NewtransactionState extends State<Newtransaction> {
  @override


  TextEditingController myController = new TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            title: Text("Make new Transaction"),
            elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
        ),
        drawer: navigationdrawer(context),
        body: new Container(
            color: Colors.white,
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    new Text("Choose Who Paid (Sender)"),
                    Padding(padding: new EdgeInsets.all(16.0),),
                    new DropdownButton(items: null, onChanged: null)
                ],
            ),
        ),
    );
  }
}
