import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:smartlights/model/room.dart';
import 'package:smartlights/model_providers/switcher_model.dart';
import 'package:smartlights/pages/home/Home.dart';
import 'package:smartlights/pages/home/energy.dart';
import 'package:smartlights/pages/home/profile.dart';
import 'package:smartlights/shared/widgets/loading.dart';

///Determines which page out of [EnergyHome],
///[Home] or [ProfilePage] to display.
///Loads the page as a child of [Switcher].
class Switcher extends StatefulWidget {
  final teacherRef;
  Switcher(this.teacherRef);

  @override
  _SwitcherState createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {
  bool dataLoaded = false;
  StreamSubscription roomsSub;
  List<String> blocks = List();
  DatabaseReference roomsReference;

  Map<String, Room> rooms, bookmarkedRooms;

  Map<String, Map<String, Room>> blocksMap = Map();

  @override
  void initState() {
    super.initState();

    print('######################### creating panelcontroller');

    print('Hi1');

    roomsReference = FirebaseDatabase.instance.reference().child('Rooms');

    roomsReference.keepSynced(true);

    roomsSub = roomsReference.onValue.listen((event) {
      var map = event.snapshot.value;
      bookmarkedRooms = Map();
      blocks = List();
      print('map is $map');

      map.forEach(
        (block, roomsMap) {
          blocks.add(block);
          rooms = Map();

          print('roomsMap: $roomsMap');

          roomsMap.forEach((room, roomData) {
            Map<String, Map<dynamic, dynamic>> showListDynamicMap = Map();
            Map<dynamic, dynamic> showInAppList = Map();
            showInAppList.addAll(roomData['Show in App']);
            print('showInAppList: $showInAppList');

            T cast<T>(x) => x is T ? x : null;

            List<String> showInAppList2 = List();
            List list = showInAppList.keys.toList();
            Map<String, List<int>> showList2 = Map();

            for (int category = 0;
                category < showInAppList.length;
                category++) {
              showInAppList2.add(cast<String>(list[category]));
              showListDynamicMap.addAll({showInAppList2[category]: Map()});
              showList2.addAll({showInAppList2[category]: List<int>()});

              showListDynamicMap[showInAppList2[category]]
                  .addAll(roomData[showInAppList2[category]]);

              for (int j = 0;
                  j <
                      cast<int>(
                          showListDynamicMap[showInAppList2[category]].length);
                  j++) {
                showList2[showInAppList2[category]].add(cast<int>(
                    showListDynamicMap[showInAppList2[category]][
                        showInAppList2[category].substring(
                                0, showInAppList2[category].length - 1) +
                            ' ' +
                            (j + 1).toString()]['Value']));
              }
            }
            Room newRoom = Room(
              room,
              roomData['Status'],
              cast<int>(roomData['Class Lux']),
              showInAppList2,
              showList2,
              roomData['Block'],
            );

            rooms.addAll({room: newRoom});

            blocksMap.addAll({block: rooms});
          });

          return true;
        },
      );
      Hive.box('appDB').put('blocksMap', blocksMap);

      if (dataLoaded != true)
        setState(() {
          dataLoaded = true;
        });
    });
    print(blocks);
  }

  @override
  void dispose() {
    super.dispose();

    roomsSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final valueProvider = Provider.of<SwitcherModel>(context);

    Widget page;
    switch (valueProvider.pageId) {
      case 0:
        page = EnergyHome(widget.teacherRef);
        break;
      case 1:
        page = dataLoaded == false ? Loading() : Home();
        break;
      case 2:
        page = ProfilePage(widget.teacherRef);
        break;
    }
    return page;
  }
}
