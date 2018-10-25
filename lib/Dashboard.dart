import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:salieri/googleapi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:salieri/customefloating.dart';

class Dashboard extends StatefulWidget {

    static FirebaseUser _user;
    static FirebaseApp app;
    Dashboard(FirebaseUser user,FirebaseApp app)
    {
        _user=user;
        app=app;
    }

    static FirebaseUser getuser()
    {
        return _user;
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
    expense = Expense("","");
    final FirebaseDatabase database = FirebaseDatabase(app : Dashboard.app);
    expenseref = database.reference().child('Personal').child('UserID');
    expenseref.onChildAdded.listen(_onEntryAdded);
    expenseref.onChildChanged.listen(_onEntryChanged);
    expenseref.onChildRemoved.listen(_onEntryRemoved);
  }

  _onEntryRemoved(Event event){
      print(event.snapshot.key);
      print("removed");
      setState(() {
        print("before");
        for(int i=0;i<expenses.length;i++)
        {
            print("$i " + expenses[i].amount);
            if(expenses[i].key == event.snapshot.key)
            {
                expenses.removeAt(i);
   //             break;
            }
        }

        print("after");
        for(int i=0;i<expenses.length;i++)
            {
                print("$i " + expenses[i].amount);
            }
      });
  }
  _onEntryAdded(Event event){

      print(" added " + event.toString());
      setState(() {

          expenses.add(Expense.fromSnapShot(event.snapshot));
      });
  }
  _onEntryChanged(Event event){
      print(" changed " + event.toString());
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
          //expense.amount=form.
          form.reset();
          print(expense.reason);
          print(expense.amount);
          expenseref.push().set(expense.toJson());
      }
  }

  @override
  Widget build(BuildContext context) {

      return Dashboard._user==null ?
           Center(
               child: CircularProgressIndicator(),
           )
          :Scaffold(
              appBar: new AppBar(
                  title: new Text("Dashboard"),
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

              drawer: new Drawer(
              child: new ListView(
                  children: <Widget>[
                      new UserAccountsDrawerHeader(
                          accountName: new Text(Dashboard._user.displayName),
                          accountEmail: new Text(Dashboard._user.email != null ? Dashboard._user.email : " "),
                          currentAccountPicture: new CircleAvatar(
                              backgroundImage: new NetworkImage(Dashboard._user.photoUrl),
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
                          onTap: null

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
          ),

          floatingActionButton: new FancyFab()
      /*    new Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                  FloatingActionButton(
                      heroTag: null,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      child: new Icon(Icons.group_add),
                      onPressed: () {
                          Navigator.pushNamed(context, '/addnewgroup');
                      },
                  ),
                  Padding(padding: const EdgeInsets.all(8.0)),
                  FloatingActionButton(
                      heroTag: null,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      child: new Icon(Icons.person_add),
                      onPressed: () {
                          Navigator.pushNamed(context, '/addnewfriend');
                      },
                  ),
                  Padding(padding: const EdgeInsets.all(8.0)),
                  FloatingActionButton(
                      heroTag: null,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      child: new Icon(Icons.attach_money),
                      onPressed: () {

                      },
                  ),

              ],
          )*/

      );
  }
}

class Expense
{
    String key;
    String reason;
    String amount;
    Expense(this.reason,this.amount);

    Expense.fromSnapShot(DataSnapshot snapshot)
        : key = snapshot.key,
          reason = snapshot.value['reason'],
          amount = snapshot.value['amount'];
    toJson()
    {
        return{
            'reason' : reason,
            'amount' : amount,
        };

    }
}
