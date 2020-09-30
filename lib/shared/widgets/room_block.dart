import 'package:align_positioned/align_positioned.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:smartlights/shared/widgets/gadget_control.dart';
import 'package:smartlights/shared/widgets/room_contents.dart';
import 'package:smartlights/shared/widgets/room_grid_layout.dart';
import 'package:smartlights/model_providers/current_gadget.dart';
import 'package:smartlights/model_providers/current_room.dart';
import 'package:smartlights/model_providers/favorite.dart';
import 'package:smartlights/model_providers/switcher_model.dart';
import 'package:smartlights/services/authenticate.dart';
import 'package:smartlights/services/database.dart';
import 'package:smartlights/shared/widgets/block_selector.dart';

Widget selectedArea;
bool firstOpened = true;
bool firstDataFetched = true;

class RoomBlockArea extends StatelessWidget {
  final _auth = AuthService();

  final String bottomText = 'Select a room to view its gadgets';

  //REVIEW: Open favorites by default - Ask later

  final PanelController _panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    print('in RoomBlock');

    final currentRoomProvider = Provider.of<CurrentRoomModel>(context);
    final pageProvider = Provider.of<SwitcherModel>(context);
    final favoriteRoomsProvider = Provider.of<FavoriteRoomsProvider>(context);

    favoriteRoomsProvider.setList();

    currentRoomProvider.panelController = _panelController;

    if (currentRoomProvider.isBlockButtonPressed == true) {
      selectedArea = BlockSelector();
    } else if (currentRoomProvider.isFavoriteButtonSelected == true) {
      selectedArea = RoomGridLayout(
        toShowFavorites: true,
      );
    } else if (currentRoomProvider.isBlockSelected) {
      selectedArea = RoomGridLayout(
        toShowFavorites: false,
      );
    } else if (currentRoomProvider.isGadgetSelected == true) {
      selectedArea = ChangeNotifierProvider<CurrentGadgetModel>(
        create: (BuildContext context) {
          return CurrentGadgetModel(
              room: currentRoomProvider.room,
              category: currentRoomProvider.gadgetCategory,
              index: currentRoomProvider.gadgetIndex,
              tag: currentRoomProvider.gadgetTag);
        },
        child: ControlRoom(
            currentRoomProvider.room,
            currentRoomProvider.gadgetCategory,
            currentRoomProvider.gadgetIndex),
      );
    }

    SlidingUpPanel slidingPanel = SlidingUpPanel(
      backdropEnabled: true,
      backdropOpacity: 0.5,
      boxShadow: <BoxShadow>[
        BoxShadow(
            color: Colors.white,
            blurRadius: 3,
            spreadRadius: 0.1,
            offset: Offset(0, -2))
      ],
      parallaxEnabled: true,
      parallaxOffset: 0.1,
      border: Border.all(width: 1, color: Colors.white),
      controller: _panelController,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      onPanelClosed: () {
        if (currentRoomProvider.isGadgetSelected == false) {
          currentRoomProvider.closeRoom();
        }
      },
      onPanelOpened: () {},
      minHeight: 0.06 * MediaQuery.of(context).size.height,
      isDraggable: currentRoomProvider.room == null ? false : true,
      maxHeight: currentRoomProvider.room == null
          ? 50
          : 0.5 * MediaQuery.of(context).size.height,
      panel: Container(
        decoration: BoxDecoration(
            color: Color(0xffe8e9ed),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        // height: 200,
        // duration: Duration(seconds: 2),
        child: Stack(
          children: <Widget>[
            Column(
              // shrinkWrap: true,
              // controller: scrollController,
              children: <Widget>[
                SizedBox(height: 5),
                Divider(
                  thickness: 5,
                  indent: MediaQuery.of(context).size.width * 1.75 / 5,
                  endIndent: MediaQuery.of(context).size.width * 1.75 / 5,
                ),
                currentRoomProvider.room == null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(currentRoomProvider.isGadgetSelected == false
                              ? currentRoomProvider.room == null
                                  ? 'Select a room to view its gadgets'
                                  : 'Select a Gadget'
                              : 'Select a Gadget'),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(bottomText),
                          SizedBox(
                            height:
                                0.05 * 0.5 * MediaQuery.of(context).size.height,
                          ),
                          RoomContents(
                              // currentRoomProvider.room,
                              // currentRoomProvider.room.showList,
                              ),
                        ],
                      ),
              ],
            ),
            currentRoomProvider.room == null
                ? SizedBox()
                : AlignPositioned(
                    // dy: currentRoomProvider.isGadgetSelected == false ? 0 : 0,
                    alignment: Alignment.topRight,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: FlatButton(
                            shape: CircleBorder(),
                            onPressed: () {
                              FirebaseDatabase.instance
                                  .reference()
                                  .child(
                                      'Rooms/${currentRoomProvider.room.blockName}/${currentRoomProvider.room.name}/Status')
                                  .set(true);
                              for (int i = 0;
                                  i <
                                      currentRoomProvider
                                          .room.showList['LEDs'].length;
                                  i++) {
                                DatabaseService.getGadgetReference(
                                        currentRoomProvider.room, 'light', i)
                                    .child('Automatic Status')
                                    .set(true);
                              }
                              for (int i = 0;
                                  i <
                                      currentRoomProvider
                                          .room.showList['Curtains'].length;
                                  i++) {
                                DatabaseService.getGadgetReference(
                                        currentRoomProvider.room, 'curtain', i)
                                    .child('Automatic Status')
                                    .set(true);
                              }
                            },
                            child: Icon(Icons.autorenew),
                          ),
                        ),
                        Text('Auto All'),
                      ],
                    ),
                  )
          ],
        ),
      ),
      body: Stack(children: <Widget>[
        Positioned.fill(
            child: Container(
          color: Color(0xffe8e9ed),
        )),
        Column(
          children: <Widget>[
            SizedBox(
              height: 2,
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            // color: Colors.white,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey[600],
                                offset: Offset(4, 3),
                                blurRadius: 4,
                                // spreadRadius: 1,
                              ),
                              BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-1, -1),
                                  blurRadius: 5,
                                  spreadRadius: 2)
                            ],
                            border: Border.all(width: 1, color: Colors.white),
                            shape: BoxShape.circle),
                        height: 32,
                        width: 32,
                        child: RaisedButton(
                          highlightElevation: 10,
                          highlightColor: Colors.blueGrey[50],
                          color: Colors.blueGrey[50],
                          elevation: 5,
                          padding: EdgeInsets.zero,
                          shape: CircleBorder(),
                          onPressed: () {
                            pageProvider.setPage(0);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            size: 18,
                            color: Colors.blueGrey[300],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Welcome Dashboard',
                        style: TextStyle(
                            fontSize: 22.5, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () async {
                      FirebaseUser user = await _auth.signOut();
                      if (user == null) {
                        Navigator.pushReplacementNamed(context, 'wrapper');
                        print('logged out');
                      } else {
                        print('logged out failed');

                        // setState(() {
                        // logOutPressed = true;
                        // });
                      }
                    },
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 50,
                  ),
                  int.parse(DateFormat('HH').format(DateTime.now())) >= 19
                      ? Icon(
                          Icons.brightness_2,
                          color: Colors.blue[800],
                        )
                      : Icon(
                          Icons.wb_sunny,
                          color: Colors.yellow[800],
                        ),
                  SizedBox(
                    width: 9,
                  ),
                  Text(
                    '${DateFormat('MMMM dd').format(DateTime.now()).toUpperCase()}',
                    style: TextStyle(
                        color: Colors.grey[500], fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ActionChip(
                      pressElevation: 5,
                      backgroundColor: Colors.grey[100],
                      padding: EdgeInsets.all(5),
                      // avatar: Icon(Icons.favorite),
                      elevation: 0,
                      onPressed: () {
                        currentRoomProvider.showFavorites();
                      },
                      label: Container(
                        height: 30,
                        child: Center(
                          child: Text(
                            'Bookmarked Rooms',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                              color: currentRoomProvider
                                          .isFavoriteButtonSelected ==
                                      true
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      replacement: SizedBox(),
                      visible: currentRoomProvider.isGadgetSelected == false
                          ? currentRoomProvider.room == null ? false : false
                          : true,
                      child: ActionChip(
                        backgroundColor: Colors.grey[100],
                        onPressed:
                            currentRoomProvider.isBlockButtonPressed == true
                                ? () {
                                    print('Close Blocks');
                                    currentRoomProvider.closeBlocks();
                                  }
                                : () {
                                    print('Close Room');

                                    // blocksMapProvider
                                    //     .cancelEnabledStatusStreamForBlock();

                                    currentRoomProvider.closeRoom();
                                  },
                        label: Container(
                          height: 30,
                          child: Center(
                            child: Text(
                              currentRoomProvider.isBlockButtonPressed == true
                                  ? 'Show Current Room'
                                  : 'Close Room',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ActionChip(
                      shadowColor: Colors.grey[200],
                      backgroundColor: Colors.grey[100],
                      pressElevation: 5,

                      elevation: 0,
                      onPressed: () {
                        currentRoomProvider.showBlocks();
                      },

                      // decoration: BoxDecoration(),
                      padding: EdgeInsets.all(0),
                      label: Container(
                        height: 40,
                        width: 60,
                        child: Center(
                          child: Text(
                            'Blocks',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                              color: currentRoomProvider.isBlockButtonPressed ==
                                      true
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            Expanded(flex: 8, child: HomeContentMiddle()),
            Expanded(
              flex: 3,
              child: SizedBox(),
            )
          ],
        ),
        // bottomScrollSheet,
      ]),
    );

    return slidingPanel;
  }
}

class HomeContentMiddle extends StatefulWidget {
  @override
  _HomeContentMiddleState createState() => _HomeContentMiddleState();
}

class _HomeContentMiddleState extends State<HomeContentMiddle> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: Container(
            // decoration: BoxDecoration(border: Border.all(width: 1)),
            // margin: EdgeInsets.zero,
            // height: 300,
            // decoration: homeRoomAreaDecor,
            width: double.infinity,
            child: selectedArea,
          ),
        ),
      ],
    );
  }
}
