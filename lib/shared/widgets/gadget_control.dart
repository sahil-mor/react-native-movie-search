import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:smartlights/model/room.dart';
import 'package:smartlights/model_providers/current_gadget.dart';
import 'package:smartlights/model_providers/current_room.dart';
import 'package:smartlights/services/database.dart';
import 'package:smartlights/shared/widgets/loading.dart';

double valueFromSlider = 0;

Function getValue = () => valueFromSlider;

String getGadgetCategory(String category) =>
    category == 'light' ? 'LEDs' : 'Curtains';

T cast<T>(x) => x is T ? x : null;

class ControlRoom extends StatefulWidget {
  final String category;
  final int index;
  final Room room;
  ControlRoom(
    this.room,
    this.category,
    this.index,
  ) : super(key: GlobalKey<_ControlRoomState>());

  @override
  _ControlRoomState createState() => _ControlRoomState();
}

class _ControlRoomState extends State<ControlRoom> {
  StreamSubscription statusSub;
  DatabaseReference statusRef;

  StreamSubscription automaticSub;
  DatabaseReference automaticRef;

  bool dataLoadedAuto, dataLoadedRoomStatus;
  @override
  void initState() {
    dataLoadedAuto = false;
    dataLoadedRoomStatus = false;
    super.initState();
    isGadgetOn = false;

    statusRef = FirebaseDatabase.instance
        .reference()
        .child('Rooms/${widget.room.blockName}/${widget.room.name}/Status');
    statusRef.keepSynced(true);
    statusSub = statusRef.onValue.listen((event) {
      setState(() {
        roomStatus = event.snapshot.value;
        dataLoadedRoomStatus = true;
      });
    });

    automaticRef = DatabaseService.getGadgetReference(
            widget.room, widget.category, widget.index)
        .child('Automatic Status');
    automaticRef.keepSynced(true);
    automaticSub = automaticRef.onValue.listen((event) {
      setState(() {
        automaticStatus = event.snapshot.value;
        dataLoadedAuto = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    automaticSub.cancel();
    statusSub.cancel();
  }

  bool roomStatus, showLabel, automaticStatus, isGadgetOn;
  var ledValueFromDB, ledValueFromDB2;
  Color statusColor, statusFillColor;
  Icon statusIcon, iconFirst, iconSecond;
  double statusOpacity;

  @override
  Widget build(BuildContext context) {
    final currentRoomProvider = Provider.of<CurrentRoomModel>(context);

    statusColor =
        currentRoomProvider.room.isEnabled == false ? Colors.red : Colors.blue;
    statusFillColor = currentRoomProvider.room.isEnabled == false
        ? Colors.blue[800]
        : Colors.white;

    iconFirst = currentRoomProvider.gadgetCategory == 'light'
        ? Icon(
            Icons.brightness_3,
            color: Colors.grey[500],
          )
        : Icon(
            Icons.calendar_view_day,
            color: Colors.grey[500],
          );

    iconSecond = currentRoomProvider.gadgetCategory == 'light'
        ? Icon(
            Icons.wb_sunny,
            color: Colors.grey[500],
          )
        : Icon(
            Icons.open_in_new,
            color: Colors.grey[500],
          );

    statusIcon = currentRoomProvider.room.isEnabled == false
        ? Icon(Icons.do_not_disturb)
        : Icon(
            Icons.check_circle_outline,
            color: Colors.green,
          );
    statusOpacity = currentRoomProvider.room.isEnabled == false ? 0.7 : 0.0;
    print('Room STatus: $roomStatus');

    return dataLoadedAuto == false || dataLoadedRoomStatus == false
        ? Loading()
        : Container(
            decoration: BoxDecoration(
                border:
                    Border(top: BorderSide(width: 0.5, color: Colors.grey))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Container(
                            constraints: BoxConstraints.expand(),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(width: 2),
                              ),
                            ),
                            child: RaisedButton(
                              padding: EdgeInsets.zero,
                              color: currentRoomProvider.room.isEnabled == true
                                  ? Colors.green
                                  : Colors.blueGrey,
                              onPressed: () {
                                if (currentRoomProvider.room.isEnabled ==
                                    true) {
                                  for (int i = 0;
                                      i <
                                          currentRoomProvider
                                              .room.showList['LEDs'].length;
                                      i++) {
                                    DatabaseService.getGadgetReference(
                                            currentRoomProvider.room,
                                            'light',
                                            i)
                                        .child('Automatic Status')
                                        .set(true);
                                  }
                                  for (int i = 0;
                                      i <
                                          currentRoomProvider
                                              .room.showList['Curtains'].length;
                                      i++) {
                                    DatabaseService.getGadgetReference(
                                            currentRoomProvider.room,
                                            'curtain',
                                            i)
                                        .child('Automatic Status')
                                        .set(true);
                                  }
                                }
                              },
                              child: Text(
                                'Auto\nAll',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: SizedBox.expand(
                            child: RaisedButton(
                              color: statusColor,
                              elevation: 0,
                              child: Text(currentRoomProvider.room.isEnabled ==
                                      true
                                  ? 'Room ${currentRoomProvider.room.name} Enabled'
                                  : 'Room ${currentRoomProvider.room.name} Disabled'),
                              onPressed: () {
                                currentRoomProvider
                                    .toggleStatus(currentRoomProvider.room);
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            constraints: BoxConstraints.expand(),
                            decoration: BoxDecoration(
                                border: Border(left: BorderSide(width: 2))),
                            child: RaisedButton(
                              padding: EdgeInsets.zero,
                              color: currentRoomProvider.room.isEnabled == true
                                  ? Colors.red
                                  : Colors.blueGrey,
                              onPressed: () {
                                if (currentRoomProvider.room.isEnabled ==
                                    true) {
                                  for (int i = 0;
                                      i <
                                          currentRoomProvider
                                              .room.showList['LEDs'].length;
                                      i++) {
                                    DatabaseService.getGadgetReference(
                                            currentRoomProvider.room,
                                            'light',
                                            i)
                                        .child('Automatic Status')
                                        .set(false);
                                  }
                                  for (int i = 0;
                                      i <
                                          currentRoomProvider
                                              .room.showList['Curtains'].length;
                                      i++) {
                                    DatabaseService.getGadgetReference(
                                            currentRoomProvider.room,
                                            'curtain',
                                            i)
                                        .child('Automatic Status')
                                        .set(false);
                                  }
                                }
                              },
                              child: Text(
                                'Manual\nAll',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 12,
                  child: ControlArea(
                    statusOpacity: statusOpacity,
                    statusColor: statusColor,
                    widget: widget,
                    automaticStatus: automaticStatus,
                    automaticRef: automaticRef,
                    iconFirst: iconFirst,
                    showLabel: showLabel,
                    iconSecond: iconSecond,
                    room: widget.room,
                    category: widget.category,
                    index: widget.index,
                  ),
                ),
              ],
            ),
          );
  }
}

class ControlArea extends StatefulWidget {
  ControlArea({
    @required this.statusOpacity,
    @required this.statusColor,
    @required this.widget,
    @required this.automaticStatus,
    @required this.automaticRef,
    @required this.iconFirst,
    @required this.showLabel,
    @required this.iconSecond,
    @required this.room,
    this.category,
    this.index,
  });

  final double statusOpacity;
  final Color statusColor;
  final ControlRoom widget;
  final bool automaticStatus;
  final DatabaseReference automaticRef;
  final Icon iconFirst;
  final bool showLabel;
  final Icon iconSecond;
  final String category;
  final int index;
  final Room room;

  @override
  _ControlAreaState createState() => _ControlAreaState();
}

class _ControlAreaState extends State<ControlArea> {
  List<bool> toggleStatus;
  Function(double) onSliderValueChanged;
  CircleProgressIndicator circleProgressIndicator = CircleProgressIndicator();

  @override
  Widget build(BuildContext context) {
    final currentGadgetProvider = Provider.of<CurrentGadgetModel>(context);
    final currentRoomProvider = Provider.of<CurrentRoomModel>(context);

    toggleStatus = [
      widget.automaticStatus == true ? true : false,
      widget.automaticStatus == true ? false : true
    ];
    onSliderValueChanged = (double value) {
      setState(() {
        valueFromSlider = value;
      });
      return value;
    };
    return Stack(
      children: <Widget>[
        Positioned.fill(
            child: Opacity(
          opacity: widget.statusOpacity,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blueGrey, Colors.blueGrey[700]],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  tileMode: TileMode.mirror,
                  stops: [.5, 6]),
            ),
          ),
        )),
        Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: circleProgressIndicator,
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                      flex: 3,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ToggleButtons(
                              fillColor: widget.automaticStatus == true
                                  ? Colors.green[100]
                                  : Colors.blue[200],
                              isSelected: toggleStatus,
                              children: <Widget>[
                                Icon(
                                  Icons.brightness_auto,
                                  color: Colors.blueAccent,
                                ),
                                Icon(
                                  Icons.person,
                                  color: Colors.red,
                                ),
                              ],
                              onPressed:
                                  currentGadgetProvider.room.isEnabled == false
                                      ? null
                                      : (index) {
                                          switch (index) {
                                            case 0:
                                              toggleStatus[index] = true;
                                              toggleStatus[index + 1] = false;

                                              widget.automaticRef.set(true);

                                              print(
                                                  'Setting: Auto ${toggleStatus[index]}');
                                              print(
                                                  'Setting: Manual ${toggleStatus[index + 1]}');
                                              break;
                                            case 1:
                                              toggleStatus[index] = true;
                                              toggleStatus[index - 1] = false;
                                              widget.automaticRef.set(false);

                                              print(
                                                  'Setting: Auto ${toggleStatus[index - 1]}');
                                              print(
                                                  'Setting: Manual ${toggleStatus[index]}');
                                              break;
                                          }
                                        },
                            ),
                            Text('Auto / Manual')
                          ])),
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: currentGadgetProvider.category == 'light'
                        ? Transform.rotate(
                            origin: Offset(0.5, 0.5),
                            angle: 3.14 * 180 / 180,
                            child: widget.iconFirst)
                        : widget.iconFirst,
                  ),
                  Expanded(
                      flex: 8,
                      child: SliderCustom(
                          widget.showLabel,
                          onSliderValueChanged,
                          widget.widget.room,
                          widget.widget.index,
                          widget.widget.category,
                          widget.automaticStatus,
                          circleProgressIndicator)),
                  Expanded(flex: 1, child: widget.iconSecond),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                child: Text(
                    '${getGadgetCategory(currentRoomProvider.gadgetCategory).substring(0, getGadgetCategory(currentRoomProvider.gadgetCategory).length - 1)} ${widget.index + 1}'),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class SliderCustom extends StatefulWidget {
  final bool showLabel;
  final Function onSliderValueChanged;
  final Room room;
  final int index;
  final String category;
  final bool automaticStatus;
  final CircleProgressIndicator circleProgressIndicator;
  SliderCustom(this.showLabel, this.onSliderValueChanged, this.room, this.index,
      this.category, this.automaticStatus, this.circleProgressIndicator)
      : super(key: GlobalKey<_SliderCustomState>());

  @override
  _SliderCustomState createState() => _SliderCustomState(showLabel,
      onSliderValueChanged, automaticStatus, circleProgressIndicator);
}

class _SliderCustomState extends State<SliderCustom> {
  StreamSubscription valueSub;
  var ledValueFromDB2;

  @override
  void initState() {
    super.initState();

    valueRef = DatabaseService.getGadgetReference(
            widget.room, widget.category, widget.index)
        .child('Value');
    valueRef.once().then((value) => ledValueFromDB = value.value.toDouble());

    valueRef.keepSynced(true);
    valueSub = valueRef.onValue.listen((event) {
      setState(() {
        ledValueFromDB2 = event.snapshot.value.toDouble();

        circleProgressIndicator.state.reloadCircularIndicator(ledValueFromDB2);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    valueSub.cancel();
  }

  bool showLabel, roomStatus, automaticStatus;
  var ledValueFromDB;
  var showValue;
  Function onSliderValueChanged;
  DatabaseReference valueRef;
  CircleProgressIndicator circleProgressIndicator;
  _SliderCustomState(this.showLabel, this.onSliderValueChanged,
      this.automaticStatus, this.circleProgressIndicator);
  @override
  Widget build(BuildContext context) {
    final currentGadgetProvider = Provider.of<CurrentGadgetModel>(context);

    print('room $roomStatus');

    showValue = automaticStatus == true ? ledValueFromDB2 : ledValueFromDB;

    print(
        'showList: control${currentGadgetProvider.room.showList} category: ${currentGadgetProvider.category} index: ${currentGadgetProvider.index}');

    ledValueFromDB = currentGadgetProvider
        .room
        .showList[currentGadgetProvider.category == 'light'
            ? 'LEDs'
            : 'Curtains'][currentGadgetProvider.index]
        .toDouble();

    print(
        'initvalue: ${currentGadgetProvider.room.showList[currentGadgetProvider.category == 'light' ? 'LEDs' : 'Curtains'][currentGadgetProvider.index].toDouble()}');

    return showValue == null
        ? Container()
        : Slider.adaptive(
            label: showLabel == true ? showValue.round().toString() : null,
            value: showValue,
            divisions: automaticStatus == true ? 100 : 10,
            min: 0,
            max: 100,
            onChangeStart: (value) => showLabel = true,
            onChangeEnd: (value) => showLabel = false,
            onChanged: currentGadgetProvider.room.isEnabled == false ||
                    automaticStatus == true
                ? null
                : (value) {
                    valueRef.set(value.round());
                    currentGadgetProvider.room.showList[
                            getGadgetCategory(currentGadgetProvider.category)]
                        [currentGadgetProvider.index] = value.toInt();
                    setState(() {
                      if (automaticStatus == false)
                        ledValueFromDB = value;
                      else
                        ledValueFromDB2 = value;
                    });
                  });
  }
}

class CircleProgressIndicator extends StatefulWidget {
  final _CircleProgressIndicatorState state = _CircleProgressIndicatorState();
  @override
  _CircleProgressIndicatorState createState() {
    return state;
  }
}

class _CircleProgressIndicatorState extends State<CircleProgressIndicator> {
  double value = 0.0;
  void reloadCircularIndicator(double valueFromSlider) {
    setState(() {
      value = valueFromSlider;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: MediaQuery.of(context).size.width / 3,
      lineWidth: 10,
      percent: value / 100,
      center: Text(
        '${value.round()}%',
        style: TextStyle(fontSize: 20),
      ),
      startAngle: 180,
      progressColor: Colors.blue,
    );
  }
}
