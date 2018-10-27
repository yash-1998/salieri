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
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                                Container(
//                                                    color: Colors.grey,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(vertical:30.0),
                                                  child: Container(
                                                      height:100.0,
                                                      width: 100.0,
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              spreadRadius: 1.0,
                                                              blurRadius: 2.0,
                                                              offset: Offset(1.0, 1.0)
                                                            )
                                                          ],
//                                                          border: Border.all(
//                                                              color: Colors.white,
//                                                              width: 1.25,
//                                                          ),
                                                          shape: BoxShape.circle,
                                                          image: DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image:NetworkImage(
                                                                  photourl),
                                                          ),
                                                      ),
                                                  ),
                                                ),
                                                Card(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical:10.0),
                                                    child: new ListTile(

                                                        title: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: <Widget>[
                                                            Text(
                                                                "Name",
                                                                textAlign: TextAlign.left,
                                                                style: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontSize: 12.0,

                                                                ),
                                                            ),
                                                            new Text(
                                                                name,
                                                                textAlign: TextAlign.left,
                                                                style: TextStyle(
                                                                  fontSize: 32.0,
                                                                  fontFamily:"Roboto",
                                                                ),
                                                            ),

                                                          ],
                                                        ),
                                                    ),
                                                  ),
                                                ),

                                                Card(
                                                  child: new ListTile(

                                                    title: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical:15.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,

                                                        children: <Widget>[
                                                          Text(
                                                            "Mail",
                                                            textAlign: TextAlign.left,
                                                            style: TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 12.0,

                                                            ),
                                                          ),
                                                          new Text(
                                                            email,
                                                            textAlign: TextAlign.left,
                                                            style: TextStyle(
                                                              fontSize: 18.0,
                                                              fontFamily:"Roboto",
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                new Padding(
                                                    padding: const EdgeInsets.all(
                                                        10.0)),
                                                Row(
                                                  children: <Widget>[

                                                    Expanded(
                                                      child: RaisedButton(
                                                          child: Text(
                                                            "Add Friend",
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                          onPressed: null,
                                                          color: Colors.white,


                                                      ),
                                                    ),
                                                  ],
                                                )
                                            ]
                                        ),
                                      ),
                                    ),
                                ],
                            ),
                        );
                    }
                }
                else
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                          backgroundColor: Colors.red,
                          strokeWidth: 2.0,
                        )
                      ],
                    );
            }
        );
    }
}
