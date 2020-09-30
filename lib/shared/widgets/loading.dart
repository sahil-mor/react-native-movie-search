import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[300],
      child: Center(
        child: SpinKitFadingCircle(
          color: Colors.deepOrange,
          size: 150.0,
        ),
      ),
    );
  }
}
