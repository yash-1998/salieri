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
        return Scaffold(
            appBar: new AppBar(
                title: new Text("Your Groups"),
                elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
            ),
            resizeToAvoidBottomPadding: false,
            body: Container(
                    child :
                    FutureBuilder(
                        future: database.reference().child("Privateusers").child(Dashboard.getuser().uid).child("Groupslist").once(),
                        builder:  (BuildContext context, AsyncSnapshot snapshot){

                            if(snapshot.hasData){

                                print(snapshot.data.value.runtimeType);
                                List <dynamic> values =snapshot.data.value;

                                for(int i=0;i<values.length;i++)
                                    print(values[i]);
                                List <Widget> childs = new List();
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
                                                        return ListTile(
                                                            title: Text(m["name"]),
                                                          //  subtitle: m["key"],
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
                    )




//                    Flexible(
//                        child: FirebaseAnimatedList(query: reference2,
//                            itemBuilder: (BuildContext context,DataSnapshot snapshot,
//                                Animation<double> animation,int index)
//                            {
//                                return Card(
//                                    child: new ListTile(
//                                        leading: Icon(Icons.attach_money),
//                                        title: Text(groups[index].name),
//                                        subtitle: Text(groups[index].key),
//                                    ),
//                                );
//                            }),
//                    ),
                ,
            ),
            drawer: navigationdrawer(context),
        );
    }
}


