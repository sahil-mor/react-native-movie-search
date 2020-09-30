import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:smartlights/model/room.dart';

class DatabaseService {
  static Future<int> getBlockCount() async {
    DataSnapshot snap = await FirebaseDatabase.instance
        .reference()
        .child('Total/Blocks')
        .once();

    return snap.value;
  }

  static DatabaseReference getStatusRef(String block, String room) {
    return FirebaseDatabase.instance
        .reference()
        .child('Rooms/$block/$room/Status');
  }

  static Future<int> getRoomCount(String block) async {
    DataSnapshot snap = await FirebaseDatabase.instance
        .reference()
        .child('Total/Block $block')
        .once();

    return snap.value;
  }

  static DatabaseReference getTeacherReference({String userID, keepSynced}) {
    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child('Teachers/$userID');
    ref.keepSynced(keepSynced);

    return ref;
  }

//not related to DB (this class)
  static String getGadgetCategory(String category) =>
      category == 'light' ? 'LEDs' : 'Curtains';

  static DatabaseReference getGadgetReference(
          Room room, String category, int index) =>
      FirebaseDatabase.instance.reference().child(
          'Rooms/${room.blockName}/${room.name}/${getGadgetCategory(category)}/${getGadgetCategory(category).substring(0, getGadgetCategory(category).length - 1) + ' ' + (index + 1).toString()}');

  getData() {}
}
