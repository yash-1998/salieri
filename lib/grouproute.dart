import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:salieri/groups.dart';

class GroupRoute extends StatefulWidget {

  Groups group;

  GroupRoute(this.group);

  @override
  _GroupRouteState createState() => _GroupRouteState(group);
}

class _GroupRouteState extends State<GroupRoute> {

  Groups group;
  _GroupRouteState(this.group);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
        elevation: 5.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              _getDynamicLink();
            }

          ),
        ]

      ),
    );
  }

  void _getDynamicLink() async {

    String ll = 'https://salieri.com/group/?id=' + group.key;
    print(ll);
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        domain: 'salieri12345.page.link/',
        link: Uri.parse(ll),
        androidParameters: AndroidParameters(
        packageName: 'com.example.salieri',
      )
    );

    final Uri link  = await parameters.buildUrl();

    Share.share('Welcome to $link');
  }
}
