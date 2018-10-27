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

    String key;
    String username;
    String email;
    String photo;
    List <String> friends;
    List <String> groups;


    Privateuser(this.username,this.email,this.photo);

    Privateuser.fromFirebase(FirebaseUser user) {
        this.email = user.email;
        this.username = user.displayName;
        this.photo = user.photoUrl;
        this.friends = List();
        this.groups = List();
    }

    Privateuser.fromSnapShot(DataSnapshot snapshot)
        : key = snapshot.key,
            email = snapshot.value['email'],
            username= snapshot.value['username'],
            photo = snapshot.value['photourl'],
            friends = snapshot.value['friends'],
            groups = snapshot.value['groups'];
    toJson()
    {
        return{
            'username' : username,
            'photourl' : photo,
            'email' : email,
            'friends' : friends,
            'groups' : groups
        };
    }

}
