import 'package:salieri/Dashboard.dart';
import 'package:flutter/material.dart';


class addnewfriend extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            title: new Text(Dashboard.getuser().displayName),
        ),  
    );
  }
}
