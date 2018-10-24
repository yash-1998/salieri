import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:salieri/googleapi.dart';
import 'package:salieri/main.dart';
import 'package:salieri/Dashboard.dart';
import 'package:salieri/button.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class Login extends StatelessWidget {

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = new GoogleSignIn();
    FacebookLogin fblogin = new FacebookLogin();

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
        return Scaffold(
            appBar: new AppBar(
                title: new Text("Login Page"),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        MaterialButton(
                            child: button('Google', 'images/google.png'),
                            onPressed: () async {
                                bool b = await _loginUser();
                                if(b==true){
                                    print("b is true");
                                    FirebaseUser user = await _getUser();
                                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                                        builder: (BuildContext context) => new Dashboard(user)
                                    ));
                                }
                                else{
                                    print("b is false");
                                    Scaffold.of(context).showSnackBar(SnackBar(content: Text("Wrong Email")));
                                }
                            },
                            color: Colors.white,
                        ),
                        Padding(padding: EdgeInsets.all(20.0)),
                        MaterialButton(
                            child: button('Facebook', 'images/facebook.png', Colors.white),
                            onPressed: () {
                                fblogin.logInWithReadPermissions(['email','public_profile'])
                                .then((result){
                                    switch(result.status)
                                    {
                                        case FacebookLoginStatus.loggedIn:
                                            FirebaseAuth.instance.signInWithFacebook
                                                (accessToken: result.accessToken.token)
                                                .then((user) {
                                                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                                                    builder: (BuildContext context) => new Dashboard(user)
                                                ));
                                            }).catchError((e) { print(e);});
                                            break;
                                        case FacebookLoginStatus.cancelledByUser:
                                            break;
                                        case FacebookLoginStatus.error:
                                            break;
                                    }
                                    
                                });

                            },
                            color: Color.fromRGBO(58, 89, 152, 1.0),
                        ),
                    ],
                ),
            ),
        );
    }
}

