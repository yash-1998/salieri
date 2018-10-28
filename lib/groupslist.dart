import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:salieri/Dashboard.dart';
import 'package:salieri/navigationdrawer.dart';
import 'package:salieri/privateuser.dart';
import 'package:salieri/groups.dart';
import 'package:salieri/groups.dart';
import 'package:salieri/grouproute.dart';

class Groupslist extends StatefulWidget {
    @override
    _GroupslistState createState() => _GroupslistState();
}

class _GroupslistState extends State<Groupslist> {

    Privateuser pvuser;
    List <Groups> groups = new List();
    DatabaseReference reference;
    DatabaseReference reference2;
    FirebaseDatabase database =  FirebaseDatabase(app : Dashboard.app);

    @override
    Widget build(BuildContext context) {

        TextEditingController myController = new TextEditingController();
        return Scaffold(
            appBar: new AppBar(
                title: new Text("Your Groups"),
                elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
            ),
            resizeToAvoidBottomPadding: false,
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.group_add),
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
                                  Groups group = new Groups(myController.text, Dashboard.getuser().uid,key);
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

            ),
            body: Container(
                    child :
                    FutureBuilder(
                        future: database.reference().child("Privateusers").child(Dashboard.getuser().uid).child("Groupslist").once(),
                        builder:  (BuildContext context, AsyncSnapshot snapshot){

                            if(snapshot.hasData){

                                List <dynamic> values =snapshot.data.value;

                                List <Widget> childs = new List();

                                if(values == null) {
                                  return Container (
                                    child: ListTile(
                                      leading: Icon(Icons.thumb_down),
                                      title: Text("No Groups to show"),
                                    ),
                                  );
                                }

                                print("Reached here");

                                childs.add(
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                        ),
                                    )
                                );
                                for(int i=0;i<values.length;i++)
                                    childs.add(
                                        FutureBuilder(
                                            future : database.reference().child("Groups").child(values[i]).once(),
                                            builder: (BuildContext context,AsyncSnapshot snapshot){
                                                    if(snapshot.hasData){
                                                        Map <dynamic,dynamic> m = snapshot.data.value;
                                                        return Card(
                                                            child: new ListTile(
                                                                    leading: Icon(Icons.attach_money),
                                                                    title: Text(m["name"]),
                                                            ),
                                                            color: Colors.lightBlueAccent,

                                                        );
                                                    }
                                                    else{
                                                        return CircularProgressIndicator();
                                                    }
                                            }
                                        )
                                    );

                                return Column(
                                    children : childs
                                );
                            }
                            else{
                                return CircularProgressIndicator();
                            }

                        }
                    ),
            ),
            drawer: navigationdrawer(context),
        );
    }
}


