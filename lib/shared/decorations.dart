import 'package:flutter/material.dart';

const textFormDecoration = InputDecoration(
  fillColor: Colors.white,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black12, width: 2)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueAccent, width: 2)),
  errorBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2)),
  focusedErrorBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2)),
);

var homeRoomAreaDecor = BoxDecoration(
  border: Border(
    top: BorderSide(
      width: 1,
      color: Colors.grey.shade300,
    ),
  ),
);
