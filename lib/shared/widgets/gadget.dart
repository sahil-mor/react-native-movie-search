import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlights/model_providers/current_room.dart';
import 'package:smartlights/model_providers/data.dart';

class Gadget extends StatelessWidget {
  final String type;
  final Icon displayIcon;
  final int index;

  Gadget(this.type, this.displayIcon, this.index);

  @override
  Widget build(BuildContext context) {
    final currentRoomProvider = Provider.of<CurrentRoomModel>(context);

    final blocksMapProvider = Provider.of<BlockDataModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Material(
          elevation: 2,
          shape: CircleBorder(
              side: BorderSide(
            width: 0,
          )),
          color: Colors.white,
          child: Center(
            child: Ink(
              decoration: ShapeDecoration(
                color: Colors.yellow[800],
                shape: CircleBorder(),
              ),
              child: Transform.scale(
                scale: 0.75,
                child: IconButton(
                  tooltip:
                      '${type == 'light' ? 'Light ${index + 1}' : 'Curtain ${index + 1}'}',
                  padding: EdgeInsets.all(0),
                  icon: displayIcon,
                  iconSize: 30,
                  color: Colors.white,
                  onPressed: () {
                    print('%%%%%%%%%%%%%%%%%%%%%%% $type  $index');
                    currentRoomProvider.selectGadget(type, 'tag', index);
                    blocksMapProvider.cancelEnabledStatusStreamForBlock();
                  },
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          '${type == 'light' ? 'Light' : 'Curtain'} ${index + 1}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
