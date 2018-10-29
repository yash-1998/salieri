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

class Appuser {
    String key;
    String username;
    String email;
    String photo;
    int temp;
    Appuser(this.username,this.email,this.photo);


    Appuser.fromFirebase(FirebaseUser user) {
        this.email = user.email;
        this.username = user.displayName;
        this.photo = user.photoUrl;

    }

    Appuser.fromSnapShot(DataSnapshot snapshot)
        : key = snapshot.key,
            email = snapshot.value['email'],
            username= snapshot.value['username'],
            photo = snapshot.value['photourl'];

    toJson()
    {
        return{
            'username' : username,
            'photourl' : photo,
            'email' : email,

        };
    }

}
