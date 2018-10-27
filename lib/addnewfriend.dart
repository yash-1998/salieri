import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:salieri/customefloating.dart';
import 'package:salieri/Dashboard.dart';
import 'package:salieri/navigationdrawer.dart';
import 'package:salieri/expense.dart';

class addnewfriend extends StatefulWidget {
  @override
  _addnewfriendState createState() => _addnewfriendState();
}

class _addnewfriendState extends State<addnewfriend> {



    @override
      Widget build(BuildContext context) {
        return Scaffold(
            appBar: new AppBar(
                title: new Text("Add new Friends"),
            ),
            body: new Column(
                children: <Widget>[
                    Flexible(
                        flex: 0,
                        child: Center(
                            child: Form(
                                child: Flex(
                                    direction: Axis.vertical,
                                    children: <Widget>[
                                        ListTile(
                                            leading: Icon(Icons.search),
                                            title: TextFormField()

                                        ),
                                        IconButton(
                                            icon: Icon(Icons.send),
                                            onPressed: () {
                                                showlist();
                                            },
                                        )
                                    ]
                                )
                            )
                        )
                    ),
                    Flexible(
                        child: FirebaseAnimatedList(query: expenseref,
                            itemBuilder: (BuildContext context,DataSnapshot snapshot,
                                Animation<double> animation,int index)
                            {
                                return new ListTile(
                                    leading: Icon(Icons.message),
                                    title: Text(expenses[index].reason),
                                    subtitle: Text(expenses[index].amount),
                                );
                            }),
                    ),
                ]
            )
        );
    }
}
