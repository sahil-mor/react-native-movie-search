import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlights/shared/widgets/block_tile.dart';
import 'package:smartlights/model_providers/current_room.dart';
import 'package:smartlights/model_providers/data.dart';
import 'package:smartlights/model_providers/favorite.dart';
import 'package:smartlights/shared/shapes/shapes.dart';
import 'package:smartlights/model/room.dart';

class RoomGridTile extends StatelessWidget {
  final Room room;

  RoomGridTile(this.room);

  final Color bgColor = Colors.white;

  void saveFavorite(String roomName) async {
    print('Trying to save $roomName to SharedPrefs');
    // SharedPreferences.getInstance().then((value) {
    //   List<String> favorites = value.getStringList('favoriteRooms');
    //   if (favorites.indexOf(roomName) == -1) {
    //     print('Added $roomName to SharedPrefs');

    //     favorites.add(roomName);

    //     value.setStringList('favoriteRooms', favorites);
    //   }
    // });
  }

  void removeFavorite(String roomName) async {
    print('Trying to remove $roomName from SharedPrefs');

    // SharedPreferences.getInstance().then((value) {
    //   List<String> favorites = value.getStringList('favoriteRooms');
    //   if (favorites.indexOf(roomName) != -1) {
    //     print('Removed $roomName from SharedPrefs');

    //     favorites.remove(roomName);

    //     value.setStringList('favoriteRooms', favorites);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final currentRoomProvider = Provider.of<CurrentRoomModel>(context);
    final blocksMapProvider = Provider.of<BlockDataModel>(context);
    final favoritesListProvider = Provider.of<FavoriteRoomsProvider>(context);
    favoritesListProvider.setList();
    print(favoritesListProvider.getList());
    //TODO: Add field to Room class

    print(
        'RoomGridTile: ${room?.name} ${room?.showList} Status: ${room.isEnabled}');
    return RoomSelectorBlock(
      child: RaisedButton(
        padding: EdgeInsets.zero,
        elevation: 5,
        shape: Shapes.blockShape,
        onPressed: () {
          currentRoomProvider.setCurrentRoom(room);
          print('Room: ${currentRoomProvider.room.name}');
        },
        color: Color(0xffe8e9ed),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 10, top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.lightbulb_outline,
                          size: (MediaQuery.of(context).size.width * 1 / 3) / 4,
                        ),
                        Icon(
                          Icons.map,
                          size: (MediaQuery.of(context).size.width * 1 / 3) / 4,
                        ),
                      ],
                    ),
                    Text(
                      room.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      'Lights, Curtains',
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                    blocksMapProvider.showSwitch == false
                        ? Text('...Loading')
                        : Transform.scale(
                            alignment: Alignment.centerLeft,
                            scale: 0.65,
                            child: CustomSwitch(
                              activeColor: Colors.yellow[800],
                              value: room.isEnabled,
                              onChanged: (bool value) {
                                currentRoomProvider.toggleStatus(room);
                              },
                            ),
                          )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                height: 21,
                width: 22,
                child: FlatButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      //TODO: Optimize by adding pproperty isFavorite to Room class
                      if (!favoritesListProvider
                          .getList()
                          .containsKey(room.name))
                        favoritesListProvider.addRoom(room);
                      else
                        favoritesListProvider.removeRoom(room);
                    },
                    child: Icon(
                      Icons.bookmark,
                      color: !favoritesListProvider
                                  .getList()
                                  .containsKey(room.name) ==
                              true
                          ? Colors.black
                          : Colors.red,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
