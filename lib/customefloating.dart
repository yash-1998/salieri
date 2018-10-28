import 'package:flutter/material.dart';
import 'addnewfriend.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salieri/Appuser.dart';
import 'package:salieri/Dashboard.dart';
import 'package:salieri/expense.dart';
import 'groups.dart';
import 'package:salieri/grouproute.dart';


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

        TextEditingController myController = new TextEditingController();
        return Container(
            child: FloatingActionButton(
                onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                        return AlertDialog(
                          title: new Text("Create New Group"),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                TextField(
                                  controller: myController,
                                  decoration: new InputDecoration(
                                    hintText: "Marauders",
                                    icon: new Icon(Icons.group),
                                    labelText: "Group Name",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            new FlatButton(
                              child: Text("Add",style: new TextStyle(color: Colors.black87),),
                              onPressed: () async {
                                if(myController.text!="" ) {
                                  DatabaseReference reference = FirebaseDatabase(app: Dashboard.getapp()).reference();
                                  String key = reference.child("Groups").push().key;
                                  Groups group = new Groups(myController.text, Dashboard.getuser().uid);
                                  reference.child("Groups").child(key).set(group.toJson());
                                  List <dynamic> list,list1=List();
                                  reference.child("Privateusers").child(Dashboard.getuser().uid).child("Groupslist").once().then((snap){
                                    list = snap.value;
                                    if(list == null)
                                      list = new List();
                                    for(int i=0;i<list.length;i++)
                                      list1.add(list[i]);
                                    list1.add(key);
                                    reference.child("Privateusers").child(Dashboard.getuser().uid).child("Groupslist").set(list1);
                                    Navigator.of(context).pushReplacement(
                                        new MaterialPageRoute(builder: (BuildContext context) {
                                          return GroupRoute(group);
                                        })
                                    );
                                  });

                                }
                                else
                                {
                                  Scaffold.of(context).showSnackBar(
                                      new SnackBar(
                                        content: new Text("Fields empty"),
                                      )
                                  );
                                }
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      }
                    );
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
                        title: new Text("Add New Friend"),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              TextField(
                                controller: myController,
                                decoration: new InputDecoration(
                                  hintText: "abc.123@uvw.xyz",
                                  icon: new Icon(Icons.email),
                                  labelText: "Email",
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          new FlatButton(
                            child: Text("Add",style: new TextStyle(color: Colors.black87),),
                            onPressed: () async {
                              if(myController.text!="" ) {
                                Map <dynamic , dynamic > m = await Navigator.of(context).push(
                                  new MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return addnewfriend(myController.text);
                                    }
                                  )
                                );

                                if(m["result"] == false) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text("User not found"),
                                      )
                                  );
                                }
                              }
                              else
                              {
                                Scaffold.of(context).showSnackBar(
                                    new SnackBar(
                                      content: new Text("Fields empty"),
                                    )
                                );
                              }
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );

                    }
                  );
                }
            )
        );
    }

    _onEntryAdded(Event event){
        setState(() {
            Expense.fromSnapShot(event.snapshot);
        });
    }

    Widget inbox() {
        final myController = TextEditingController();
        final myController2 = TextEditingController();
        DatabaseReference expenseref;
        final FirebaseDatabase database = FirebaseDatabase(app : Dashboard.app);
        expenseref = database.reference().child('Personal').child(Dashboard.getuser().uid);
        expenseref.onChildAdded.listen(_onEntryAdded);
        return Container(
            child: FloatingActionButton(
                heroTag: null,
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                child: new Icon(Icons.attach_money),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_){
                      return AlertDialog(
                        title: new Text("Add New Expense"),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              TextField(
                                controller: myController,
                                decoration: new InputDecoration(
                                  hintText: "Party with friends",
                                  icon: new Icon(Icons.add_comment),
                                  labelText: "Reason",
                                ),
                              ),
                              TextField(
                                keyboardType: TextInputType.number,
                                controller: myController2,
                                decoration: new InputDecoration(
                                  hintText: "200.35",
                                  icon: new Icon(Icons.money_off),
                                  labelText: "Amount",
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          new FlatButton(
                            child: Text("Add",style: new TextStyle(color: Colors.black87),),
                            onPressed: (){
                              if(myController.text!="" && myController2.text!="")
                              {
                                Expense ex = new Expense(myController.text,myController2.text);
                                expenseref.push().set(ex.toJson());
                              }
                              else
                              {
                                Scaffold.of(context).showSnackBar(
                                  new SnackBar(
                                    content: new Text("Fields empty"),
                                  )
                                );
                              }
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    },
                  );
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