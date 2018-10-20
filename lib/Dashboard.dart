import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  @override

  FirebaseUser user;
  void _getUser() async {
    user = await FirebaseAuth.instance.currentUser();
  }
  Widget build(BuildContext context) {
    _getUser();
    return Container(
      child: Text(user.displayName),
    );
  }
}
