import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:salieri/main.dart';
import 'package:salieri/googleapi.dart';

class Dashboard extends StatelessWidget {

  static FirebaseUser _user;

  Dashboard(FirebaseUser user)
  {
      _user=user;
  }

  static FirebaseUser getuser()
  {
      return _user;
  }
  @override
  Widget build(BuildContext context) {

      return Scaffold(
          appBar: new AppBar(
              title: new Text("Dashboard"),
              elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
          ),
          drawer: new Drawer(
              child: new ListView(
                  children: <Widget>[
                      new UserAccountsDrawerHeader(
                          accountName: new Text(_user.displayName),
                          accountEmail: new Text(_user.email),
                          currentAccountPicture: new CircleAvatar(
                              backgroundImage: new NetworkImage(_user.photoUrl),
                          ),
                      ),
                      new ListTile(
                          title: new Text("Friend List"),
                          leading: new Icon(Icons.assignment_ind),
                          onTap: null

                      ),
                      new ListTile(
                          title: new Text("Group List"),
                          leading: new Icon(Icons.group),
                          onTap: null,
                      ),
                      new Divider(),

                      new ListTile(
                          title: Text("SignOut"),
                          onTap: (){

                              googleapii.signout();
                              Navigator.pushReplacementNamed(context,'/login');
                              },
                          
                      ),

                  ],
              ),
          ),

          floatingActionButton: new Row(


              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                  FloatingActionButton(
                      heroTag: null,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      child: new Icon(Icons.group_add),
                      onPressed: () {
                          Navigator.pushNamed(context, '/addnewgroup');
                      },
                  ),
                  Padding(padding: const EdgeInsets.all(8.0)),
                  FloatingActionButton(
                      heroTag: null,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      child: new Icon(Icons.person_add),
                      onPressed: () {
                          Navigator.pushNamed(context, '/addnewfriend');
                      },
                  ),

              ],
          )
         
      );
  }
}

