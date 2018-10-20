import 'package:flutter/material.dart';
import 'package:salieri/SplashScreen.dart/';
import 'package:salieri/Login.dart';
import 'package:salieri/Dashboard.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: "Salieri",
            home: new HomePage(),
            theme: new ThemeData(
                primarySwatch: Colors.teal,
                brightness: Brightness.light,
            ),
            initialRoute: '/splash',
            routes: {
                '/splash' : (context) => SplashScreen(),
                '/login' : (context) => Login(),
                '/dashboard' : (context) => Dashboard(),
            },
        );
    }
}

class HomePage extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Sign In"),
                elevation : 5.00,
            ),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                    RaisedButton(
                        onPressed: null ,
                        child: Text ("Sign In With Google"),
                        color: Colors.blueAccent,
                    )
                ],
            )
        );
    }
}

