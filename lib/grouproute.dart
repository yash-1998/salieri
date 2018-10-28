import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salieri/navigationdrawer.dart';
import 'package:salieri/newtransaction.dart';
import 'package:share/share.dart';
import 'package:salieri/Dashboard.dart';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';


import 'package:salieri/groups.dart';

class GroupRoute extends StatefulWidget {

  Groups group;

  GroupRoute(this.group);

  @override
  _GroupRouteState createState() => _GroupRouteState(group);
}

class _GroupRouteState extends State<GroupRoute> {

  Groups group;
  FirebaseDatabase database =  FirebaseDatabase(app : Dashboard.app);
  List<Widget> childs;
  List<Widget> childs_transaction;

  _GroupRouteState(Groups gr){

    this.group = gr;
    childs=_getmember();
    childs.add(
      Divider(),
    );
    childs.add(
      Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: new Text("Recent Transactions",style: new TextStyle(fontWeight: FontWeight.bold,),)
      ),
    );
    childs.add(Divider(),);
    childs_transaction = _gettransaction();
    childs.addAll(childs_transaction);
  }

  double _calculate_credit()
  {
    if(group.transactions==null)
      return 0;
    double credit=0;
    for(int i=0;i<group.transactions.length;i++)
      {
        if(group.transactions[i].receiver == Dashboard.getuser().uid)
          {
            credit+=group.transactions[i].amount;
          }
      }
    return credit;
  }
  double _calculate_debit()
  {
    if(group.transactions==null)
      return 0;
    double debit=0;
    for(int i=0;i<group.transactions.length;i++)
    {
      if(group.transactions[i].sender == Dashboard.getuser().uid)
      {
        debit+=group.transactions[i].amount;
      }
    }
    return debit;
  }

  List<Widget> _gettransaction()
  {
    List<Widget> childd=new List();
    if(group.transactions == null)
      {
        childd.add(
            new Card(
              child: new ListTile(
                leading: Icon(Icons.person),
                title: Text("Oops"),
                subtitle: Text("No transaction till yet"),
              ),
              color: Colors.lightBlueAccent,
            ));

        return childd;
      }
    for(int i=-0;i<group.transactions.length;i++)
    {
      childd.add(
          new Card(
          child: new ListTile(
            leading: Icon(Icons.person),
            title: Text(group.transactions[i].sender),
            subtitle: Text(group.transactions[i].receiver),
            trailing: Text(group.transactions[i].amount.toString()),
          ),
          color: Colors.lightBlueAccent,
      ));
    }
    return childd;
  }

  List<Widget> _getmember()
  {
    List<Widget> childd=new List();
    for(int i=-0;i<group.members.length;i++)
      {
        childd.add(
            FutureBuilder(
                future : database.reference().child("Appusers").child(group.members[i]).once(),
                builder: (BuildContext context,AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    Map <dynamic,dynamic> m = snapshot.data.value;
                    return Card(
                      child: new ListTile(
                        leading: Icon(Icons.person),
                        title: Text(m["username"]),
                        subtitle: Text(m['email']),
                      ),
                      color: Colors.lightBlueAccent,
                    );
                  }
                  else{
                    return CircularProgressIndicator(
                      backgroundColor: Colors.blueAccent,
                      strokeWidth: 2.0,
                    );
                  }
                }
            )
        );
      }

    return childd;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navigationdrawer(context),
      appBar: AppBar(

          title: Text(group.name),
        elevation: 5.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              _getDynamicLink();
            }

          ),
        ]

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          ListTile(
            leading: Icon(Icons.monetization_on,color: Colors.green,),
            subtitle: Text("Total Credit in " + group.name),
            title: Text(_calculate_credit().toString(),style: new TextStyle(color: Colors.green),),
          ),
          ListTile(
            leading: Icon(Icons.attach_money,color: Colors.red,),
            subtitle: Text("Total Debit in " + group.name),
            title: Text(_calculate_debit().toString(),style: new TextStyle(color: Colors.red),),
          ),
          Divider(),
          Padding(
              padding: const EdgeInsets.only(left: 15.0),
            child: new Text("Members",style: new TextStyle(fontWeight: FontWeight.bold,),)
          ),
          Divider(),

          Flexible(
            child: ListView(
              children: childs,
            ),
          ),

        ],
      ),
      floatingActionButton: new FloatingActionButton(
          child: Icon(Icons.people_outline),
          onPressed: (){
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) => new Newtransaction()
            ));
          },
      ),
    );
  }

  void _getDynamicLink() async {
    print(group.key);
    String ll = 'https://salieri.com/groups?groupId=' + group.key;
    print(ll);
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        domain: 'salieri12345.page.link/testing',
        link: Uri.parse(ll),
    );

    final Uri link  = await parameters.buildUrl();

    Share.share(link.toString());
  }
}
