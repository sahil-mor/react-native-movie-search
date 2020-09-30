import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:smartlights/model/room.dart';
import 'package:smartlights/services/database.dart';

class CurrentGadgetModel with ChangeNotifier {
  int value;
  int index;
  String category;
  String tag;
  Room room;
  bool isRoomEnabled;
  bool automaticstatus;

  StreamSubscription valueSub;

  CurrentGadgetModel({this.room, this.category, this.index, this.tag}) {
    this.isRoomEnabled = this.room.isEnabled;
  }

  void toggleStatus() {
    isRoomEnabled = !isRoomEnabled;
    notifyListeners();
  }

  void subscribe() {
    valueSub = DatabaseService.getGadgetReference(room, category, index)
        .onValue
        .listen((event) {
      value = event.snapshot.value;
    });
  }

  void unsubscribe() {
    valueSub.cancel();
  }
}
