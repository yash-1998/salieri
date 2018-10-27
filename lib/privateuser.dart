import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:salieri/customefloating.dart';
import 'personal.dart';
import 'package:salieri/navigationdrawer.dart';
import 'package:salieri/expense.dart';
import 'package:salieri/Appuser.dart';

class Privateuser {

    List <String> groupslist ;

    Privateuser(){
        groupslist = new List();

        groupslist.add("-LPr6zruv8jSR1TIZUb-");
        groupslist.add("-LPr7INrBzz1l-hzsEWT");
    }
    Privateuser.fromSnapShot(DataSnapshot snapshot)
        :   groupslist = snapshot.value['Groupslist'];
    toJson()
    {
        return{
            'Groupslist' : groupslist
        };
    }
}