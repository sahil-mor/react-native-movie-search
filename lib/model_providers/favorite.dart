import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:smartlights/model/room.dart';

class FavoriteRoomsProvider with ChangeNotifier {
  Map list = Map();

  Map getList() {
    return list;
  }

  void setList() {
    var box = Hive.box('appDB');

    list = box.get('favoriteRooms');
  }

  void addRoom(Room room) async {
    list.addAll({room.name: room});

    var box = Hive.box('appDB');

    await box.put('favoriteRooms', list);
    notifyListeners();
  }

  void removeRoom(Room room) async {
    list.remove(room.name);

    var box = Hive.box('appDB');

    box.put('favoriteRooms', list);
    notifyListeners();
  }
}
