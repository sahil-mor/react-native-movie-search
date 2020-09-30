import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:smartlights/model/room.dart';
import 'package:smartlights/services/database.dart';

class BlockDataModel with ChangeNotifier {
  Map<String, Map<String, Room>> blocksMap;

  List<StreamSubscription> streamSubscriptionList = List();

  bool showSwitch = false;

  void startEnabledStatusStreamForBlock(String block) {
    int doneCOunt = 0;
    // print('length: ${blocksMap[block]} Block: $block');
    int totalCount = blocksMap[block].length;
    blocksMap[block].forEach((roomName, room) async {
      var snapshot =
          await DatabaseService.getStatusRef(block, room.name).once();

      room.isEnabled = snapshot.value;
      doneCOunt += 1;
      print('Room $block: ${room.name} done');
      if (doneCOunt == totalCount) {
        showSwitch = true;
        notifyListeners();
      }
    });

    //notify when data loaded
    //show ...Loading with animation/circular progress indicator instead of switch till then
    // notifyListeners();
  }

  void cancelEnabledStatusStreamForBlock() {
    print('####################Cancelling');
    // streamSubscriptionList.forEach((element) {
    //   element.cancel();
    // });

    streamSubscriptionList.clear();

    showSwitch = false;
    notifyListeners();
  }

  loadData() {
    var box = Hive.box('appDB');
    blocksMap = box.get('blocksMap');
    print('Data Loaded: $blocksMap');
    // notifyListeners();
  }

  saveData() async {
    var box = Hive.box('appDB');
    await box.put('blocksMap', blocksMap);
  }
}
