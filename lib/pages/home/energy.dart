import 'dart:async';

import 'package:align_positioned/align_positioned.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlights/model_providers/switcher_model.dart';

class EnergyHome extends StatefulWidget {
  final DatabaseReference ref;
  EnergyHome(this.ref);
  @override
  _EnergyHomeState createState() => _EnergyHomeState();
}

class _EnergyHomeState extends State<EnergyHome> {
  dynamic energySaved = 'Loading..', costRecovered = 'Loading..';
  int energyFont = 27;
  StreamSubscription energySavedSub;
  DatabaseReference energySavedRef;
  @override
  void initState() {
    super.initState();
    energySavedRef = widget.ref;

    energySavedSub = energySavedRef.onValue.listen((event) {
      print('before setstate in energy');

      if (event.snapshot.value['Energy Saved'] != energySaved &&
          this.mounted == true) {
        setState(() {
          print(' value: ${event.snapshot.value}');
          energySaved = event.snapshot.value['Energy Saved'];
          energyFont = 76;
        });
      }
    });
  }

  @override
  void dispose() {
    print('in dispose of energy before');

    energySavedSub.cancel();
    print('in dispose of energy after');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<SwitcherModel>(context);

    print('in build of energy');

    return Scaffold(
      body: Container(
        color: Colors.deepOrange,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: Center(
                    child: Text('Smart Luminous System',
                        style: TextStyle(
                          shadows: <Shadow>[
                            Shadow(
                                color: Colors.black54,
                                offset: Offset(1, 1),
                                blurRadius: 10)
                          ],
                          fontSize: 25,
                          color: Colors.white,
                        )),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 12,
                        child: Chip(
                          backgroundColor: Colors.white,
                          // decoration: BoxDecoration(
                          //   shape: BoxShape.circle,
                          // ),
                          // height: 150,
                          label: SizedBox.expand(
                            child: Stack(
                              overflow: Overflow.visible,
                              alignment: Alignment.center,
                              children: <Widget>[
                                AlignPositioned(
                                  alignment: Alignment.topCenter,
                                  moveByContainerHeight: -0.1,
                                  // left: -10,
                                  // top: -12,
                                  child: Image.asset(
                                    'images/lightning(1).png',
                                    // color: Colors.deepPurple,
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    RichText(
                                      text: TextSpan(
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: energyFont.toDouble()),
                                          text: '$energySaved',
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'kWh',
                                                style: TextStyle(fontSize: 25))
                                          ]),
                                    ),
                                    Text('Energy Saved by You')
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                    ],
                  )),
              Expanded(
                  child: SizedBox(
                child: Center(
                  child: Text('',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      )),
                ),
              )),
              Expanded(child: SizedBox()),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(child: SizedBox()),
                    Expanded(
                      flex: 12,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.black87,
                        elevation: 0,
                        onPressed: () {
                          pageProvider.setPage(1);
                          // Navigator.pushReplacementNamed(context, 'dashboard');
                        },
                        child: ListTile(
                          title: Text(
                            'Go to Dashboard',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
