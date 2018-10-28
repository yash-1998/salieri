import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:salieri/customefloating.dart';
import 'package:salieri/Dashboard.dart';
import 'package:salieri/navigationdrawer.dart';
import 'package:salieri/expense.dart';

class personal extends StatefulWidget {
  @override
  _personalState createState() => _personalState();
}
class _personalState extends State<personal> {



    double sum=0;
    String _sumvalue(){
    double val = sum;

    String val1;
    var k =  new NumberFormat.currency(locale: "en_IN", symbol: "₹");
    val1 = k.format(val);
    return val1;
  }
  String _prevmonth(){
    var curdate = new DateTime.now();
    var prevmonth = new DateTime(curdate.year,curdate.month-1,curdate.day);
    var showdate = new DateFormat.yMMMMd().format(prevmonth);
    return showdate;
  }
    List<Expense> expenses = List();
    Expense expense;
    DatabaseReference expenseref;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    @override
    void initState() {
        // TODO: implement initState
        super.initState();
        expense=new Expense("",0.0);
        final FirebaseDatabase database = FirebaseDatabase(app : Dashboard.app);
        expenseref = database.reference().child('Personal').child(Dashboard.getuser().uid);
        expenseref.onChildAdded.listen(_onEntryAdded);
        expenseref.onChildChanged.listen(_onEntryChanged);
        expenseref.onChildRemoved.listen(_onEntryRemoved);
    }

    _onEntryRemoved(Event event){
        setState(() {
            for(int i=0;i < expenses.length;i++)
            {
                print(expenses[i].reason);
                print(expenses[i].amount);
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
            sum+=event.snapshot.value["amount"];
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
                title: new Text("Personal Expenses"),
                elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
            ),
            resizeToAvoidBottomPadding: false,
            body: Column(
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
                            _sumvalue(),
                            style: TextStyle(
                              fontFamily: "Impact",
                              color: Colors.green,
                              fontSize: 48.0,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  "Total Expenditure",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontSize: 18.0,
                                  ),

                              ),
                              //Date and Time
                              Text("Since "+_prevmonth(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                Flexible(
                    child: FirebaseAnimatedList(query: expenseref,
                        itemBuilder: (BuildContext context,DataSnapshot snapshot,
                            Animation<double> animation,int index)
                        {
                            return Card(
                              child: new ListTile(
                                  leading: Icon(Icons.attach_money),
                                  title: Text(expenses[index].reason),
                                  subtitle: Text(expenses[index].amount.toString()),
                              ),
                              color: Colors.cyan,
                            );
                        }),
                ),
        ],
            ),
            drawer: navigationdrawer(context),
        );
    }
}



