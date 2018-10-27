import 'package:flutter/material.dart';
import 'package:salieri/googleapi.dart';
import 'personal.dart';
import 'package:salieri/Dashboard.dart';

Widget navigationdrawer(BuildContext context){
    return  Drawer(
                child: new ListView(
                children: <Widget>[
                    new UserAccountsDrawerHeader(
                        accountName: new Text(Dashboard.getuser().displayName),
                        accountEmail: new Text(Dashboard.getuser().email != null ? Dashboard.getuser().email : " "),
                        currentAccountPicture: new CircleAvatar(
                            backgroundImage: new NetworkImage(Dashboard.getuser().photoUrl),
                            ),
                        ),
                    new ListTile(
                        title: new Text("Friend List"),
                        leading: new Icon(Icons.assignment_ind),
                        onTap: null
                    ),
                    new ListTile(
                        title: new Text("Group List"),
                        leading: new Icon(Icons.group),
                        onTap: null,
                    ),
                    new ListTile(
                        title: new Text("Personal Expenses"),
                        leading: new Icon(Icons.attach_money),
                        onTap: (){
                            Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new personal()));
                        }
                    ),
                    new Divider(),
                    new ListTile(
                    title: Text("SignOut"),
                    onTap: (){
                        googleapii.signout();
                        Navigator.pushReplacementNamed(context,'/login');
                    },
                ),
            ],
        ),
    );
}