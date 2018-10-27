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

class personal extends StatefulWidget {

  @override
  _personalState createState() => _personalState();
}

class _personalState extends State<personal> {

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
        expenseref = database.reference().child('Personal').child(Dashboard.getuser().uid);
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
                title: new Text("Personal Expenses"),
                elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
            ),
            resizeToAvoidBottomPadding: false,
            body: Column(
                children: <Widget>[
                    Flexible(
                        flex: 0,
                        child: Center(
                            child: Form(
                                key: formKey,
                                child: Flex(
                                    direction: Axis.vertical,
                                    children: <Widget>[
                                        ListTile(
                                            leading: Icon(Icons.info),
                                            title: TextFormField(
                                                initialValue: "",
                                                onSaved: (val) => this.expense.reason=val,
                                                validator: (val){
                                                    if(val==""){
                                                        return "Empty reason";
                                                    }
                                                },
                                            ),
                                        ),
                                        ListTile(
                                            leading: Icon(Icons.info),
                                            title: TextFormField(
                                                initialValue: "",
                                                onSaved: (val) =>  this.expense.amount=val,
                                                validator: (val){
                                                    if(val==""){
                                                        return "Empty Amount";
                                                    }
                                                },
                                            ),
                                        ),
                                        IconButton(
                                            icon: Icon(Icons.send),
                                            onPressed: () {
                                                if(formKey.currentState.validate()) {
                                                    handlesubmit();
                                                }
                                            },
                                        )
                                    ],
                                ),
                            ),
                        ),
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
                ],
            ),
            drawer: navigationdrawer(context),
        //    floatingActionButton: new FancyFab()
        );
    }
}


