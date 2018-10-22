import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:salieri/googleapi.dart';
import 'package:salieri/main.dart';
import 'package:salieri/Dashboard.dart';


class Login extends StatelessWidget {

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = new GoogleSignIn();

    Future<bool> _loginUser() async
    {
        final googleapi = await googleapii.signinwithgoogle();
        if(googleapi != null)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    Future <FirebaseUser> _getUser() {

        return _auth.currentUser();
    }

  @override
  Widget build(BuildContext context) {
      return new Scaffold(
          appBar: new AppBar(
              title: new Text("Login Page"),
          ),
          body: new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                      new RaisedButton(
                          onPressed: () async {
                                          bool b = await _loginUser();
                                          if(b==true){
                                          print("b is true");
                                          FirebaseUser user = await _getUser();
//                                          Navigator.of(context).pop();
//                                          Navigator.of(context).push(new MaterialPageRoute(
//                                              builder: (BuildContext context) =>
//                                              new Dashboard(user)));
                                          Navigator.of(context).pushReplacement(new MaterialPageRoute(
                                              builder: (BuildContext context) => new Dashboard(user)
                                          ));
                                      }
                                      else{
                                          print("b is false");
                                          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Wrong Email")));
                                      }
                                    },
                          child: new Text("Google Sign in"),
                          color: Colors.greenAccent,
                      ),
                  ],
              ),
          ),
      );
  }
}

