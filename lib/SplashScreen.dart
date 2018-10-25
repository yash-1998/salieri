import 'dart:async' show Future, Timer;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salieri/Dashboard.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _iconanimation;

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;

  @override
  void initState(){
    super.initState();
    _controller = new AnimationController(vsync: this,duration: new Duration(milliseconds: 1500));
    _iconanimation = new CurvedAnimation(parent: _controller, curve: Curves.bounceOut);
    _iconanimation.addListener(() => this.setState((){}));
    _controller.forward();

    _checkUser();


  }

  Future <FirebaseUser> _getUser() {

      return _auth.currentUser();
  }


  Future<void> _checkUser() async {
      FirebaseUser user = await _getUser();
      if(user == null) {
          Timer(Duration(seconds: 3),(){ Navigator.of(context).pushReplacementNamed('/login'); });
      }
      else {
          Timer(Duration(seconds: 3),() async {
            FirebaseApp app = await FirebaseApp.configure(
              name: 'db2',
              options: const FirebaseOptions(
                googleAppID: '1:284798494309:android:db15646f83ba1036',
                apiKey: 'AIzaSyAL3SaqALbDiEecdq-z5BiUYfWMVPYMxnw',
                databaseURL: 'https://salieri-3e280.firebaseio.com/',
              ),
            );
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) => new Dashboard(user,app))); });
      }
  }


  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.blueAccent),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: _iconanimation.value*50,
                        child: Icon(
                          Icons.attach_money,
                          color: Colors.blueAccent,
                          size: _iconanimation.value*50,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        "\$alieri",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellowAccent),),
                    Padding(padding: EdgeInsets.only(top: 20.0),),
                    Text("Online Expense Manager",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.normal ,color: Colors.white),),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
