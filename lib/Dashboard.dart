import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



class Dashboard extends StatelessWidget {

  FirebaseUser _user;

  Dashboard(FirebaseUser user)
  {
      this._user=user;
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
                  ],
              ),
          ),
          floatingActionButton: StreamBuilder(
              stream: FirebaseAuth.instance.currentUser().asStream(),
              builder: (BuildContext context , AsyncSnapshot<FirebaseUser> snapshot)
              {
                  return FloatingActionButton(
                      elevation: 10.0,
                      onPressed: null,
                      child: CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: new Text(snapshot.data.displayName.substring(0,1)),
                      ),
                  );
              },
          ),
      );
  }
}

