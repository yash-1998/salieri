import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Salieri",
      theme: new ThemeData.dark(),
      home: new LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signin() async
  {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gsa = await googleSignInAccount.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: gsa.idToken,
        accessToken: gsa.accessToken
    );
    print("User name = ${user.displayName}" );
  }

  void _signout()
  {
    googleSignIn.signOut();
    print("User Signed out");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
          child: Text("Sign-In with Google"),
          onPressed:() { _signin();Navigator.pop(context);Navigator.pushNamed(context, '/dashboard');},
      ),
    );
  }
}

