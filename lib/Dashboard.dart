import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:salieri/customefloating.dart';
import 'package:salieri/groups.dart';
import 'package:salieri/privateuser.dart';
import 'personal.dart';
import 'package:salieri/navigationdrawer.dart';
import 'package:salieri/expense.dart';
import 'package:salieri/Appuser.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:salieri/grouproute.dart';

class Dashboard extends StatefulWidget {

    static FirebaseUser _user;
    static FirebaseApp app;
    DatabaseReference reference;

    Dashboard(FirebaseUser user,FirebaseApp fapp)
    {
        _user=user;
        app=fapp;
        Appuser appuser = Appuser.fromFirebase(_user);
        final FirebaseDatabase database = FirebaseDatabase(app : app);
        database.reference().child("Appusers").child(user.uid).set(appuser.toJson());
        
    }
    static FirebaseUser getuser() {
        return _user;
    }
    static FirebaseApp getapp() {
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
  FirebaseDatabase database;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    expense=new Expense("",0.0);
    database = FirebaseDatabase(app : Dashboard.app);
    expenseref = database.reference().child('Personal').child(Dashboard._user.uid);
    expenseref.onChildAdded.listen(_onEntryAdded);
    expenseref.onChildChanged.listen(_onEntryChanged);
    expenseref.onChildRemoved.listen(_onEntryRemoved);


    _retrieveDynamicLink();

  }

  void _retrieveDynamicLink() async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.retrieveDynamicLink();
    final Uri uri = data?.link;

    print(uri.toString());
    if(uri == null)
      return;

    Map <String , String > m = uri.queryParameters;

    //m['id'] has group key
  }


  Future<Groups> _getGroup(String key) {
    Groups group;
    database.reference().child("Groups").child(key).once().then(
        (DataSnapshot snap) {
          return Groups.fromSnapshot(snap);
        }
    );
  }

  _onEntryRemoved(Event event){
      setState(() {
        for(int i=0;i<expenses.length;i++)
        {
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
