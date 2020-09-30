import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlights/shared/widgets/block_tile.dart';
import 'package:smartlights/model_providers/current_room.dart';
import 'package:smartlights/model_providers/data.dart';
import 'package:smartlights/shared/shapes/shapes.dart';

class BlockSelector extends StatelessWidget {
  final List<String> blocks = List();

  @override
  Widget build(BuildContext context) {
    print('in blockSelector');
    final blocksMapProvider =
        Provider.of<BlockDataModel>(context, listen: false);

    final currentRoomProvider = Provider.of<CurrentRoomModel>(context);

    blocksMapProvider.loadData();

    blocksMapProvider.blocksMap.forEach((key, value) {
      blocks.add(key);
    });

    String blockName;

    List<Widget> list = List();

    for (var element in blocksMapProvider.blocksMap.keys) {
      blockName = element[element.length - 1];

      list.add(
        RoomSelectorBlock(
          child: RaisedButton(
            padding: EdgeInsets.zero,
            elevation: 5,
            shape: Shapes.blockShape,
            onPressed: () {
              currentRoomProvider.selectBlock(element);
              currentRoomProvider.closeBlocks();
              print('calling');
              blocksMapProvider.startEnabledStatusStreamForBlock(element);
            },
            color: Color(0xffe8e9ed),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 10, top: 10),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Icon(
                        Icons.account_balance,
                        size: (MediaQuery.of(context).size.width * 1 / 3) / 4,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        blockName.toUpperCase() + ' Block',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    // list.add(Expanded(flex: 1, child: SizedBox()));
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Wrap(
              spacing: 15,
              runSpacing: 15,
              direction: Axis.horizontal,
              children: list,
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
