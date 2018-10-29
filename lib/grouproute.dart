import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:intl/intl.dart';
import 'package:salieri/Appuser.dart';
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
  List<Widget> childs_members;
  TextEditingController t1=new TextEditingController();
  TextEditingController t2=new TextEditingController();
  List<Appuser> appusers ;
  Map <String,String> mapp = new Map();
  _GroupRouteState(Groups gr){

    appusers = new List();
    this.group = gr;

    childs_members = _getmember();
    childs = _getquerytransactions();

    childs.add(
      Divider()
    );
    childs.add(
      Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: new Text("Members",style: new TextStyle(fontWeight: FontWeight.bold,),)
      )
    );
    childs.add(Divider());
    childs.addAll(childs_members);


  }

  double credit=0;
  double debit=0;


  List<Widget> _getquerytransactions(){

    List<Widget> childd=new List();

    print(group.key);
    childd.add(FutureBuilder(

              future : database.reference().child("Groups").child(group.key).child("Transactions").once(),
              builder: (BuildContext context,AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  Map <dynamic,dynamic> m = snapshot.data.value;
                  if(m == null)
                      m = new Map();
                  print(" M iinfo  ");
                 // print(m.length);
                  print(m.runtimeType);

                  List<Widget> arr = new List();
                  m.forEach((k,v) {
                    if(v["sender"] == Dashboard.getuser().uid.toString()) {

                        credit+=v["amount"];
                        print("added new");
                    }
                    if(v["receiver"] == Dashboard.getuser().uid)
                      debit+=v["amount"];
                   arr.add(Card(
                          child: new ListTile(
                            leading: Icon(Icons.person),
                            title: Text( "Sender:" + mapp[v["sender"]] + "\nReceiver:" + mapp[v["receiver"]],style: new TextStyle(color: Colors.black),),
                            subtitle: Text(v["reason"]),
                            trailing: Text("₹" + v["amount"].toString(),style: new TextStyle(color: Colors.purpleAccent),),
                          ),
                          color: Colors.cyan,
                        ));
                  });

                  arr.insert(0, ListTile(
                                  leading: Icon(Icons.monetization_on,color: Colors.green,),
                                  subtitle: Text("Total Credit in " + group.name),
                                  title: Text(credit.toString(),style: new TextStyle(color: Colors.green),),
                                )
                  );
                  arr.insert(1, ListTile(
                                  leading: Icon(Icons.attach_money,color: Colors.red,),
                                  subtitle: Text("Total Debit in " + group.name),
                                  title: Text(debit.toString(),style: new TextStyle(color: Colors.red),),
                                )
                  );
                  arr.insert(2, Divider());
                  arr.insert(3, Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: new Text("Recent Transactions",style: new TextStyle(fontWeight: FontWeight.bold,),)
                                )
                  );
                  arr.insert(4, Divider());
                  return new Column(children : arr);
                }
                else{
                  print("hjelo");
                  return CircularProgressIndicator(
                    backgroundColor: Colors.blueAccent,
                    strokeWidth: 2.0,
                  );
                }
              }
          )
    );
        print("hello");
        print(childd.length);
        return childd;
  }
  List<Widget> _getmember(){

    List<Widget> childd=new List();
    for(int i=-0;i<group.members.length;i++)
      {
        childd.add(
            FutureBuilder(
                future : database.reference().child("Appusers").child(group.members[i]).once(),
                builder: (BuildContext context,AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    Map <dynamic,dynamic> m = snapshot.data.value;
                    appusers.add(Appuser.fromSnapShot(snapshot.data));
                    mapp[appusers[i].key] = appusers[i].username;
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
      //drawer: navigationdrawer(context),
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
                builder: (BuildContext context) => new Newtransaction(group,appusers)
            ));
          },
      ),
    );
  }

  void _getDynamicLink() async {

    String ll = 'https://salieri.com/group/?id=' + group.key;
    //print(ll);
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        domain: 'salieri12345.page.link/',
        link: Uri.parse(ll),
        androidParameters: AndroidParameters(
        packageName: 'com.example.salieri',
      )
    );

    final Uri link  = await parameters.buildUrl();

    Share.share(Dashboard.getuser().displayName + " invited you to join " + group.name + " on Salieri\n" +
                    link.toString()
            );
  }
}
