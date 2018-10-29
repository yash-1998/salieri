import 'package:flutter/material.dart';
import 'package:salieri/googleapi.dart';
import 'package:salieri/groupslist.dart';
import 'personal.dart';
import 'package:salieri/Dashboard.dart';

Widget navigationdrawer(BuildContext context,int x){
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
                        title: new Text("Dashboard" , style: new TextStyle(color: x==0 ? Colors.blue : Colors.black),),
                        leading: new Icon(Icons.dashboard),
                        onTap: (){
                            Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new Dashboard(Dashboard.getuser(),Dashboard.getapp())));
                        },
                    ),
                    new ListTile(
                        title: new Text("Group List" ,style: new TextStyle(color: x==1 ? Colors.blue : Colors.black),),
                        leading: new Icon(Icons.group),
                        onTap: (){
                            Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new Groupslist()));
                        },
                    ),
                    new ListTile(
                        title: new Text("Personal Expenses" ,style: new TextStyle(color: x==2 ? Colors.blue : Colors.black),),
                        leading: new Icon(Icons.attach_money),
                        onTap: (){
                            Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new personal()));
                        }
                    ),
                    new Divider(),
                    new ListTile(
                        leading: Icon(Icons.settings),
                        title: Text("Settings"),
                        onTap: (){

                        },
                    ),
                    new ListTile(
                    leading: new Icon(Icons.subdirectory_arrow_left),
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