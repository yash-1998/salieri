import 'package:flutter/material.dart';
import 'addnewfriend.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salieri/Appuser.dart';
import 'package:salieri/Dashboard.dart';
class FancyFab extends StatefulWidget {
    final Function() onPressed;
    final String tooltip;
    final IconData icon;

    FancyFab({this.onPressed, this.tooltip, this.icon});

    @override
    _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
    bool isOpened = false;
    AnimationController _animationController;
    Animation<Color> _buttonColor;
    Animation<double> _animateIcon;
    Animation<double> _translateButton;
    Curve _curve = Curves.easeOut;
    double _fabHeight = 56.0;

    @override
    initState() {
        _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
            ..addListener(() {
                setState(() {});
            });
        _animateIcon =
            Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
        _buttonColor = ColorTween(
            begin: Colors.blue,
            end: Colors.red,
        ).animate(CurvedAnimation(
            parent: _animationController,
            curve: Interval(
                0.00,
                1.00,
                curve: Curves.linear,
            ),
        ));
        _translateButton = Tween<double>(
            begin: _fabHeight,
            end: -14.0,
        ).animate(CurvedAnimation(
            parent: _animationController,
            curve: Interval(
                0.0,
                0.75,
                curve: _curve,
            ),
        ));
        super.initState();
    }

    @override
    dispose() {
        _animationController.dispose();
        super.dispose();
    }

    animate() {
        if (!isOpened) {
            _animationController.forward();
        } else {
            _animationController.reverse();
        }
        isOpened = !isOpened;
    }

    Widget add() {
        return Container(
            child: FloatingActionButton(
                onPressed: () {
                    Navigator.pushNamed(context, '/addnewgroup');
                },
                heroTag: null,
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                child: new Icon(Icons.group_add),
                tooltip: 'Add Group',
            ),
        );
    }

    Widget image() {

        final myController = TextEditingController();
        return Container(
            child: FloatingActionButton(
                tooltip: 'Add Friend',
                heroTag: null,
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                child: new Icon(Icons.person_add),
                onPressed: () {

                    showDialog(
                        context: context ,
                        builder: (_) {
                            return AlertDialog(
                                title: Text("Search User by Email"),
                                content: SingleChildScrollView(
                                    child: ListBody(
                                        children: <Widget>[
                                            TextField(
                                                controller: myController,
                                            ),
                                        ],
                                    ),
                                ),
                                actions: <Widget>[
                                    new FlatButton(
                                        child: Text("Search" ,
                                                     style: new TextStyle(color: Colors.black87),),
                                        onPressed: () async {
                                            Map result = await Navigator.pushReplacement(
                                                context, new MaterialPageRoute(
                                                builder: (
                                                    BuildContext context) =>
                                                    addnewfriend(myController.text)
                                            ));
                                            if(result["result"] == false) {
                                                Scaffold.of(context).showSnackBar(new SnackBar(
                                                    content: new Text("User Not Found"),
                                                ));
                                            }
                                        })
                                 ]
                            );

                        },
                    );
                }
            )
        );
    }

    Widget inbox() {
        return Container(
            child: FloatingActionButton(
                heroTag: null,
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                child: new Icon(Icons.attach_money),
                onPressed: () {
                },
            ),
        );
    }

    Widget toggle() {
        return Container(
            child: FloatingActionButton(
                backgroundColor: _buttonColor.value,
                onPressed: animate,
                tooltip: 'Toggle',
                child: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: _animateIcon,
                ),
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                Transform(
                    transform: Matrix4.translationValues(
                        0.0,
                        _translateButton.value * 3.0,
                        0.0,
                    ),
                    child: add(),
                ),
                Transform(
                    transform: Matrix4.translationValues(
                        0.0,
                        _translateButton.value * 2.0,
                        0.0,
                    ),
                    child: image(),
                ),
                Transform(
                    transform: Matrix4.translationValues(
                        0.0,
                        _translateButton.value,
                        0.0,
                    ),
                    child: inbox(),
                ),
                toggle(),
            ],
        );
    }
}