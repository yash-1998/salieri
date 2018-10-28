import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:salieri/customefloating.dart';
import 'package:salieri/privateuser.dart';
import 'package:salieri/transactions.dart';
import 'personal.dart';
import 'package:salieri/navigationdrawer.dart';
import 'package:salieri/expense.dart';
import 'package:salieri/Appuser.dart';

class Groups{

    String key;
    String name;
    List <String> members = new List();
    List <Transaction> transactions = new List();


    Groups(String name , String uid , String key) {
      this.key = key;
      this.name = name;
      this.members.add(uid);
    }

    Groups.fromSnapshot(DataSnapshot snapshot):
            key = snapshot.key,
            name = snapshot.value['name'],
            members = snapshot.value['members'],
            transactions = snapshot.value['transactions'];
    toJson()
    {
        return {
            'name' : name,
            'members' : members,
            'transactions' : transactions,
        };
    }

}