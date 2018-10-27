import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
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
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Personal Expenses"),
//        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,

      ),

      body: Column(
//        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
              Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                          _sumvalue(),
                          style: TextStyle(
                              fontFamily: "Impact",
                              color: Colors.green,
                              fontSize: 48.0,
                          ),
                      ),
                      subtitle: Column(
                        children: <Widget>[
                          Text("Total Expendture"),
                          //Date and Time
                          Text("Since "+_prevmonth())
                        ],
                      ),


                    )
                  ],
                ),
              )

        ],
      ),
    );
  }

  String _sumvalue(){
    int val = 2000;

    String val1;
    val1 = val.toString();
    return val1;
  }
  String _prevmonth(){
    var curdate = new DateTime.now();
    var prevmonth = new DateTime(curdate.year,curdate.month-1,curdate.day);
    var showdate = new DateFormat.yMMMMd().format(prevmonth);
    return showdate;
  }
}



