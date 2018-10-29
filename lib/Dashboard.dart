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
import "package:intl/intl.dart";

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



        Groups groups = await database.reference().child("Groups").child(m['id']).once().then(
                (DataSnapshot snap) {
                if(snap.value != null)
                    return Groups.fromSnapshot(snap);
                else
                    return null;
            }
        );

        if(groups != null)
            if(groups.members.contains(Dashboard.getuser().uid))
                Navigator.push(context, MaterialPageRoute(builder: (_) => GroupRoute(groups)));
            else {
                List <String> temp = List();
                for(int i=0;i<groups.members.length;i++)
                    temp.add(groups.members[i]);
                temp.add(Dashboard.getuser().uid);
                groups.members = temp;
                database.reference().child("Groups").child(groups.key).child("members").set(temp);
                List <dynamic> list,list1=List();
                database.reference().child("Privateusers").child(Dashboard.getuser().uid).child("Groupslist").once().then(
                        (snap){
                        list = snap.value;
                        if(list == null)
                            list = new List();
                        for(int i=0;i<list.length;i++)
                            list1.add(list[i]);
                        list1.add(groups.key);
                        database.reference().child("Privateusers").child(Dashboard.getuser().uid).child("Groupslist").set(list1);
                    }
                );
                Navigator.push(context, MaterialPageRoute(builder: (_) => GroupRoute(groups)));
            }

        else
            showDialog(
                context: context ,
                builder: (_) {
                    return AlertDialog(
                        title: Text("Oops!"),
                        content: Text("Group does not exists"),
                    );
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
    String _sumcredit(){
        double val = 1000.000;

        String val1;
        var k =  new NumberFormat.currency(locale: "en_IN", symbol: "₹");
        val1 = k.format(val);
        return val1;
    }
    String _sumdebit(){
      double val = 56284.0;

      String val1;
      var k =  new NumberFormat.currency(locale: "en_IN", symbol: "₹");
      val1 = k.format(val);
      return val1;
    }

    @override
    Widget build(BuildContext context) {

        return Scaffold(
             appBar: new AppBar(
                  title: new Text("Dashboard"),
                  elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
              ),
          resizeToAvoidBottomPadding: false,
          body: Column(
                  children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                          ),
                          child: Column(
                              children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                      ),
                                      child: Card(
                                          color: Colors.white,
                                          child: Column(
                                              children: <Widget>[
                                                  ListTile(
                                                      title: Text(
                                                          _sumdebit(),
                                                          style: TextStyle(
                                                              fontFamily: "Impact",
                                                              color: Colors.redAccent,
                                                              fontSize: 48.0,
                                                          ),
                                                      ),
                                                      subtitle: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: <Widget>[
                                                              Text(
                                                                  "Total Debit",
                                                                  textAlign: TextAlign.left,
                                                                  style: TextStyle(
                                                                      fontStyle: FontStyle.italic,
                                                                      fontSize: 18.0,
                                                                  ),

                                                              ),
                                                              //Date and Time

                                                          ],
                                                      ),
                                                  )
                                              ],
                                          ),
                                      ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Card(
                                      color: Colors.white,
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            title: Text(
                                              _sumcredit(),
                                              style: TextStyle(
                                                fontFamily: "Impact",
                                                color: Colors.blueAccent,
                                                fontSize: 48.0,
                                              ),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "Total Credit",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 18.0,
                                                  ),

                                                ),
                                                //Date and Time

                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                          ),
                      ),
                  ],
              ),
              drawer: navigationdrawer(context,0),
              floatingActionButton: new FancyFab()
      );
    }
}