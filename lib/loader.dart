import 'package:flutter/material.dart';
class loader extends StatefulWidget {
  @override
  _loaderState createState() => _loaderState();
}

class _loaderState extends State<loader> with SingleTickerProviderStateMixin {
    AnimationController animator;
    Animation<double> radius;
    Animation<double> radius_in;
    Animation<double> radius_out;

    @override
    Widget build(BuildContext context) {
        return Container(
        );
    }
}
