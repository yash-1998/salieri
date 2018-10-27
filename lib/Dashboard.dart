import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:salieri/customefloating.dart';
import 'package:salieri/privateuser.dart';
import 'personal.dart';
import 'package:salieri/navigationdrawer.dart';
import 'package:salieri/expense.dart';
import 'package:salieri/Appuser.dart';

class Dashboard extends StatefulWidget {

    static FirebaseUser _user;
    static FirebaseApp app;
    DatabaseReference reference;
    DatabaseReference reference2;

    Dashboard(FirebaseUser user,FirebaseApp fapp)
    {
        _user=user;
        app=fapp;
        Appuser appuser = Appuser.fromFirebase(_user);
        Privateuser privateuser = Privateuser.fromFirebase(_user);
        final FirebaseDatabase database = FirebaseDatabase(app : app);
        reference = database.reference().child("Appusers").child(user.uid);
        reference.set(appuser.toJson());
        reference = database.reference().child("Privateusers").child(user.uid);
        reference.set(appuser.toJson());
    }
    static FirebaseUser getuser()
    {
        return _user;
    }
    static FirebaseApp getapp()
    {
        return app;
    }

    @override
    _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List<Expense> expenses = List();
  Expense expense;
  DatabaseReference expenseref;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    expense=new Expense("","");
    final FirebaseDatabase database = FirebaseDatabase(app : Dashboard.app);
    expenseref = database.reference().child('Personal').child(Dashboard._user.uid);
    expenseref.onChildAdded.listen(_onEntryAdded);
    expenseref.onChildChanged.listen(_onEntryChanged);
    expenseref.onChildRemoved.listen(_onEntryRemoved);
  }

  _onEntryRemoved(Event event){
      setState(() {
        for(int i=0;i<expenses.length;i++)
        {
            print("$i " + expenses[i].amount);
            if(expenses[i].key == event.snapshot.key)
            {
                expenses.removeAt(i);
                break;
            }
        }
   });
  }
  _onEntryAdded(Event event){
      setState(() {
          expenses.add(Expense.fromSnapShot(event.snapshot));
      });
  }
  _onEntryChanged(Event event){
      var old = expenses.singleWhere((entry){
          return entry.key == event.snapshot.key;
      });
      setState(() {
          expenses[expenses.indexOf(old)] = Expense.fromSnapShot(event.snapshot);
      });
  }
  void handlesubmit(){
      final FormState form = formKey.currentState;
      if(form.validate()){
          form.save();
          form.reset();
          print(expense.reason);
          print(expense.amount);
          expenseref.push().set(expense.toJson());
      }
  }

  @override
  Widget build(BuildContext context) {

      return Scaffold(
              appBar: new AppBar(
                  title: new Text("Dashboard"),
                  elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
              ),
              body: new Column(
                  children: <Widget>[

                  ],
              ),
              drawer: navigationdrawer(context),
              floatingActionButton: new FancyFab()
      );
  }
}
