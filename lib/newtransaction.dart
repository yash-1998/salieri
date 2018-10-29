import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:salieri/Dashboard.dart';
import 'package:salieri/customefloating.dart';
import 'package:salieri/groups.dart';
import 'package:intl/intl.dart';
import 'package:salieri/privateuser.dart';
import 'package:salieri/transactions.dart';
import 'personal.dart';
import 'package:salieri/navigationdrawer.dart';
import 'package:salieri/expense.dart';
import 'package:salieri/Appuser.dart';
import 'package:salieri/grouproute.dart';

class Newtransaction extends StatefulWidget {

    Groups group;
    List<Appuser> appusers;
    Newtransaction(this.group,this.appusers);
  @override
  _NewtransactionState createState() => _NewtransactionState(group,appusers);
}

class _NewtransactionState extends State<Newtransaction> {

    FirebaseDatabase database =  FirebaseDatabase(app : Dashboard.app);
    @override
    void initState() {
        _dropDownMenuItems = getDropDownMenuItems();
        super.initState();
    }

  Groups group;
  List<Appuser> appusers;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _sender,_receiver;


  _NewtransactionState(Groups gr,List<Appuser> appusers ){
      this.group=gr;
      this.appusers=appusers;
      this._dropDownMenuItems = getDropDownMenuItems();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
      List<DropdownMenuItem<String>> items = new List();

      for (int i=0;i<appusers.length;i++) {
          print("kejdnkejd");
          items.add(new DropdownMenuItem(
              value: appusers[i].key,
              child: new Text(appusers[i].username)
          ));
      }
      return items;
  }

  void changedDropDownItem(String selectedCity) {
      setState(() {
          _sender = selectedCity;
      });
  }

  void changedDropDownItem2(String selectedCity) {
      setState(() {
          _receiver = selectedCity;
      });
  }


  TextEditingController myController = new TextEditingController();
  TextEditingController myController2 = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            title: Text("Make new Transaction"),
            elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
        ),
        resizeToAvoidBottomPadding: false,
        drawer: navigationdrawer(context),
        body: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                    Padding(padding: new EdgeInsets.only(top : 10.0),),
                    new Text("Choose Who Paid (Sender)"),
                    Padding(padding: new EdgeInsets.all(10.0),),
                    new DropdownButton(value:_sender,items: _dropDownMenuItems, onChanged: changedDropDownItem),
                    Padding(padding: new EdgeInsets.all(10.0),),
                    new Text("Choose for Whom Paid (Receiver)"),
                    Padding(padding: new EdgeInsets.all(10.0),),
                    new DropdownButton(value:_receiver,items: _dropDownMenuItems, onChanged: changedDropDownItem2),
                    new TextField(
                        keyboardType: TextInputType.number,
                        controller: myController,
                        decoration: new InputDecoration(
                            hintText: "23156",
                            icon: new Icon(Icons.monetization_on),
                            labelText: "Amount",

                        ),
                    ),
                    Padding(padding: new EdgeInsets.all(10.0),),
                    new TextField(
                        controller: myController2,
                        decoration: new InputDecoration(
                            hintText: "Hangout",
                            icon: new Icon(Icons.rate_review),
                            labelText: "Reason",

                        ),
                    ),
                    Padding(padding: new EdgeInsets.all(16.0),),
                    RaisedButton(
                        child: Text("Add Transaction",style: new TextStyle(color: Colors.black87),),
                        onPressed: (){
                            print(_sender);
                            print(_receiver);
                            print(myController.text);
                            print(myController2.text);
                            var timestamp = new DateTime.now();
                            print(timestamp);
                            if(_sender==null || _receiver==null || myController.text=="" || myController2.text=="")
                            {
                                Scaffold.of(context).showSnackBar(
                                    new SnackBar(
                                        content: new Text("Fields are not filled properly"),
                                    )
                                );
                            }
                            else{
                                List <Transaction> transactions = new List();

                                Transaction transaction =new Transaction(_sender, _receiver, double.parse(myController.text.toString()), myController2.text);
                                database.reference().child("Groups").child(group.key).child("Transactions").push().set(transaction.toJson());
                                print("Transaction entered");
                                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                                   builder: (BuildContext context)=>new GroupRoute(group)
                                ));
                            }
                        },
                    ),
                ],
        ),
    );
  }
}
