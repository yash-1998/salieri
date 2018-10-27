import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salieri/Appuser.dart';
import 'package:salieri/Dashboard.dart';

class addnewfriend extends StatefulWidget {

    String email;
    addnewfriend(this.email);
    @override
    _addnewfriendState createState() => _addnewfriendState(email);
}

class _addnewfriendState extends State<addnewfriend> {

    String email,name="",photourl="";
    Appuser appuser;
    String uid;
    _addnewfriendState(this.email);

    void addfriend(String f2key){
        String f1key=Dashboard.getuser().uid;
        final FirebaseDatabase database = FirebaseDatabase(app : Dashboard.app);


    }
    @override
    Widget build(BuildContext context) {
        return new FutureBuilder(
            future: FirebaseDatabase.instance.reference().child("Appusers").orderByChild("email").equalTo(email).once(),
            builder:  (BuildContext context, AsyncSnapshot snapshot) {
                if(snapshot.hasData) {

                    Map<dynamic, dynamic> values=snapshot.data.value;
                    if(values==null){
                        Navigator.of(context).pop({"result" : false});
                        return Scaffold();
                    }
                    else {

                        values.forEach((key, values) {
                            uid=key;
                            name = values['username'];
                            photourl = values['photourl'];
                            print(photourl);
                        });

                        return Scaffold(
                            appBar: new AppBar(
                                title: Text("Add New Friend"),
                                elevation: 5.0,
                            ),
                            body: new Column(
                                children: <Widget>[
                                    Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                            new Container(
                                                child: new Image.network(
                                                    photourl,
                                                    height: 60.0,
                                                    fit: BoxFit.cover,
                                                ),
                                            ),
                                            new ListTile(
                                                leading: Text("Name : "),
                                                title: new Text(name),
                                            ),
                                            new ListTile(
                                                leading: Text("Email : "),
                                                title: new Text(email),
                                            ),
                                            new Padding(
                                                padding: const EdgeInsets.all(
                                                    10.0)),
                                            new RaisedButton(
                                                child: new Text("Add Friend"),
                                                onPressed: () {
                                                    //addfriend();
                                                },
                                            )
                                        ]
                                    ),
                                ],
                            ),
                        );
                    }
                }
                else
                    return CircularProgressIndicator();
            }
        );
    }
}
