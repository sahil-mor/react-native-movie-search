import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:smartlights/model/room.dart';
import 'package:smartlights/services/database.dart';

class CurrentRoomModel with ChangeNotifier {
  bool isFavoriteButtonSelected = false;
  String block;
  Room room;
  bool isGadgetSelected = false;
  bool isBlockButtonPressed = true;
  String gadgetCategory;
  int gadgetIndex;
  String gadgetTag;
  bool isEnabled = false;
  PanelController panelController;
  bool isBlockSelected = false;
  String lastButtonSelected;

  // void loadSavedRoom() {
  //   var box = Hive.box('appDB');
  //   if (room != null) {
  //     print('loading');
  //     // isBlockButtonPressed = true;
  //     room = box.get('room');
  //     isGadgetSelected = true;
  //     gadgetCategory = box.get('category');
  //     gadgetIndex = box.get('index');
  //     gadgetTag = box.get('tag');
  //   }
  // }

  void showFavorites() {
    lastButtonSelected = 'favorite';
    isFavoriteButtonSelected = true;
    isBlockButtonPressed = false;
    isBlockSelected = false;
    notifyListeners();
  }

  void selectBlock(String blockName) {
    lastButtonSelected = 'block';
    // startEnabledStatusStreamForBlock();
    print('Block Selected: $blockName');
    isBlockSelected = true;
    isFavoriteButtonSelected = false;
    block = blockName;
  }

  void setAutoAll() {}

  void toggleStatus(Room room) {
    room.isEnabled = !room.isEnabled;
    // await Future.delayed(Duration(milliseconds: 1000));

    notifyListeners();

    //add db lines maybe -done

    DatabaseReference statusRef =
        DatabaseService.getStatusRef(room.blockName, room.name);
    statusRef.set(room.isEnabled);

    if (room.isEnabled == false) {
      for (int i = 0; i < room.showList['LEDs'].length; i++) {
        DatabaseService.getGadgetReference(room, 'light', i)
            .child('Automatic Status')
            .set(false);
      }
      for (int i = 0; i < room.showList['Curtains'].length; i++) {
        DatabaseService.getGadgetReference(room, 'curtain', i)
            .child('Automatic Status')
            .set(false);
      }
      for (int i = 0; i < room.showList['LEDs'].length; i++) {
        DatabaseService.getGadgetReference(room, 'light', i)
            .child('Value')
            .set(0);
      }
      for (int i = 0; i < room.showList['Curtains'].length; i++) {
        DatabaseService.getGadgetReference(room, 'curtain', i)
            .child('Value')
            .set(0);
      }
    } else {
      for (int i = 0; i < room.showList['LEDs'].length; i++) {
        DatabaseService.getGadgetReference(room, 'light', i)
            .child('Automatic Status')
            .set(true);
      }
      for (int i = 0; i < room.showList['Curtains'].length; i++) {
        DatabaseService.getGadgetReference(room, 'curtain', i)
            .child('Automatic Status')
            .set(true);
      }
    }
  }

  void setCurrentRoom(Room room) {
    print('Current Room set: ${room.name}');
    this.room = room;
    isBlockButtonPressed = false;
    isFavoriteButtonSelected = false;
    isBlockSelected = false;
    notifyListeners();

    panelController.open();
    saveRoom(room);
  }

  Future saveRoom(Room room) async {
    var box = Hive.box('appDB');
    if (room != null)
      box.put('room', room);
    else
      box.put('room', null);

    // await box.close();
  }

  void selectGadget(String category, String tag, int index) {
    gadgetCategory = category;
    gadgetIndex = index;
    gadgetTag = tag;
    isGadgetSelected = true;
    isBlockButtonPressed = false;

    lastButtonSelected = '';

    saveGadget(category, tag, index);

    if (panelController.isPanelOpen) panelController.close();
    notifyListeners();
  }

  void saveGadget(String category, String tag, int index) async {
    var box = Hive.box('appDB');
    box.put('category', category);
    box.put('index', index);
    box.put('tag', tag);

    // await box.close();
  }

  ///Hi
  void closeRoom() {
    this.room = null;
    this.gadgetCategory = null;
    this.gadgetIndex = null;
    saveGadget(null, null, null);
    saveRoom(null);
    if (isGadgetSelected == true)
      isBlockButtonPressed = true;
    else if (lastButtonSelected == 'block')
      isBlockSelected = true;
    else if (lastButtonSelected == 'favorite') isFavoriteButtonSelected = true;
    // else if (isBlockSelected == false) isFavoriteButtonSelected = true;
    this.isGadgetSelected = false;

    notifyListeners();
  }

  void showBlocks() {
    isBlockButtonPressed = true;
    isFavoriteButtonSelected = false;
    notifyListeners();
  }

  void closeBlocks() {
    isBlockButtonPressed = false;
    notifyListeners();
  }
}
