import 'package:flutter/material.dart';
import 'package:salieri/SplashScreen.dart';
import 'package:salieri/Login.dart';
import 'package:salieri/Dashboard.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: "Salieri",
            home: SplashScreen(),
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

