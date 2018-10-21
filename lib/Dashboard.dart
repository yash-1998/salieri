import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return Scaffold(

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

