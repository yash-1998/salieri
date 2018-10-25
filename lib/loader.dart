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
      width: 150.0,
      height: 150.0,
      child: Center(
        child: Stack(
          children: <Widget>[
            Dot(
              radius: 30.0,
              color: Colors.black38,
            )
          ],
        ),
      ),
    );
  }
}

class Dot{
  final double radius;
  final double color;
  Dot({this.radius,this.color})

  return Container(
      width: this.radius,
      height: this.radius,
      decoration: BoxDecoration(
        color: this.color,
        shape: BoxShape.circle
      ),
  )
}
