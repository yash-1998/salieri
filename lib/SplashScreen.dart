import 'dart:async' show Future, Timer;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _iconanimation;

  @override
  void initState(){
    super.initState();
    _controller = new AnimationController(vsync: this,duration: new Duration(milliseconds: 1500));
    _iconanimation = new CurvedAnimation(parent: _controller, curve: Curves.bounceOut);
    _iconanimation.addListener(() => this.setState((){}));
    _controller.forward();

    Future <FirebaseUser> x  = FirebaseAuth.instance.currentUser();
    if(x == null)
      Timer(Duration(seconds: 5),(){ Navigator.pop(context); Navigator.pushNamed(context, '/login'); });
    else
      Timer(Duration(seconds: 5),() { Navigator.pop(context); Navigator.pushNamed(context, '/dashboard'); });
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
