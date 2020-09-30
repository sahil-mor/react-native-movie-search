import 'package:flutter/material.dart';

String blockSelected2;

class RoomSelectorBlock extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;
  RoomSelectorBlock({this.child, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // border: Border.all(width: 1, color: Colors.black),
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.blueGrey[300],
              offset: Offset(3, 5),
              blurRadius: 10,
              spreadRadius: 1),
          BoxShadow(
            color: Colors.white,
            offset: Offset(-4, -1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      padding: EdgeInsets.zero,
      height: MediaQuery.of(context).size.width * 1 / 3,
      width: MediaQuery.of(context).size.width * 1 / 2 - 22.5,
      margin: margin,
      child: child,
    );
  }
}
