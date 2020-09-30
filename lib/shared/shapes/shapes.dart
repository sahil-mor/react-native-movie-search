import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Shapes {
  static RoundedRectangleBorder blockShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)));
  static RoundedRectangleBorder roomSelectorTileSHape =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));

  static CircleBorder blockSelectorIconShape = CircleBorder();

  static CircleBorder gadgetCircleShape = CircleBorder(
      side:
          BorderSide(width: 1, color: Colors.black, style: BorderStyle.solid));

  static RoundedRectangleBorder loginButton = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)));
}
