import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlights/shared/widgets/room_grid_tile.dart';
import 'package:smartlights/model_providers/current_room.dart';
import 'package:smartlights/model_providers/data.dart';
import 'package:smartlights/model_providers/favorite.dart';

class RoomGridLayout extends StatelessWidget {
  final bool toShowFavorites;

  RoomGridLayout({this.toShowFavorites});

  final List<RoomGridTile> favoriteRooms = List();
  final List<RoomGridTile> blockRooms = List();
  @override
  Widget build(BuildContext context) {
    // print('roomsList: ${widget.roomsList}');

    final blocksMapProvider = Provider.of<BlockDataModel>(context);
    final currentRoomProvider = Provider.of<CurrentRoomModel>(context);
    final favoriteRoomsProvider = Provider.of<FavoriteRoomsProvider>(context);
    favoriteRooms.clear();

    favoriteRoomsProvider
        .getList()
        .forEach((roomName, room) => favoriteRooms.add(RoomGridTile(room)));

    if (blocksMapProvider.blocksMap[currentRoomProvider.block] != null) {
      blockRooms.clear();
      blocksMapProvider.blocksMap[currentRoomProvider.block]
          .forEach((roomName, room) => blockRooms.add(RoomGridTile(room)));
    }

    return Container(
      child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(
              'Select a Room from ${currentRoomProvider.lastButtonSelected == 'block' ? currentRoomProvider.block : 'Bookmarks'}'),
        ),
        Expanded(
            flex: 8,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Wrap(
                        direction: Axis.horizontal,
                        spacing: 15,
                        runSpacing: 15,
                        children: toShowFavorites == true
                            ? favoriteRooms
                            : blockRooms),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            )),
      ]),
    );
  }
}
