import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: "Salieri",
            home: new HomePage(),
            theme: new ThemeData(
                primarySwatch: Colors.deepPurple

            ),
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

