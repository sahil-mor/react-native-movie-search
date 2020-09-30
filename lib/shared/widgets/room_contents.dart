import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlights/shared/widgets/gadget.dart';
import 'package:smartlights/model_providers/current_room.dart';

class RoomContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentRoomProvider = Provider.of<CurrentRoomModel>(context);

    List<Widget> widgetList(List<int> itemList, String category) {
      List<Widget> list = List();

      Icon icon;

      if (category == 'LEDs') {
        icon = Icon(Icons.lightbulb_outline);
        category = 'light';
      } else if (category == 'Curtains') {
        icon = Icon(Icons.grid_on);
        category = 'curtain';
      } else {
        icon = Icon(Icons.open_in_new);
      }
      for (int i = 0; i < itemList.length; i++) {
        list.add(Gadget(
          category,
          icon,
          i,
        ));
      }

      return list;
    }

    List<Widget> columnChildren(Map<String, List<int>> showList) {
      List<Widget> list = List();

      print('showlist.values: ${showList.values}');

      List<String> category = showList.keys.toList();

      if (category.contains('LEDs') && category.contains('Curtains')) {
        category[0] = 'LEDs';
        category[1] = 'Curtains';
      }

      for (int i = 0; i < showList.length; i++) {
        if ((showList.length <= 5) || (showList.length <= 3)) {
          list.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widgetList(showList[category[i]], category[i]),
          ));
          list.add(SizedBox(
            height: 0.2 * 0.5 * MediaQuery.of(context).size.height,
          ));
        } else {
          list.add(ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: showList.length,
            itemBuilder: (context, index) {
              return widgetList(showList[category[i]], category[i])[index];
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                width: 20,
              );
            },
          ));
        }
      }

      print(list);

      return list;
    }

    print(
        'RoomCOntents: Room is: ${currentRoomProvider.room?.name} showList: ${currentRoomProvider.room?.showList}');

    return Container(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: columnChildren(currentRoomProvider.room?.showList)),
    );
  }
}
