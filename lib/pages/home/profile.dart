import 'dart:async';

import 'package:align_positioned/align_positioned.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlights/model_providers/switcher_model.dart';
import 'package:smartlights/model_providers/user.dart';

import 'Home.dart';

class ProfilePage extends StatefulWidget {
  final DatabaseReference energyRef;
  ProfilePage(this.energyRef);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int bottomIndex = 1;
  StreamSubscription energySub;
  int energySaved;

  @override
  void initState() {
    super.initState();

    DatabaseReference energyRef = widget.energyRef;

    energySub = energyRef.onValue.listen((event) {
      if (energySaved != event.snapshot.value['Energy Saved'])
        setState(() {
          energySaved = event.snapshot.value['Energy Saved'];
        });
    });
  }

  @override
  void dispose() {
    energySub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teacherProvider = Provider.of<Teacher>(context, listen: false);
    final pageProvider = Provider.of<SwitcherModel>(context);

    return bottomIndex == 0
        ? Home()
        : Scaffold(
            body: Stack(children: <Widget>[
              Image.asset(
                'images/new.jpg',
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              Opacity(
                opacity: 0.5,
                child: Container(
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xff182ac2), Color(0xff98a2b3)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        tileMode: TileMode.mirror,
                        stops: [.5, 6]),
                  ),
                ),
              ),
              SafeArea(
                  child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Colors.black38,
                    ),
                    // height: 200,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Stack(
                        children: <Widget>[
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 50,
                                child: Icon(
                                  Icons.person,
                                  size: 40,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                '${teacherProvider.name}',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                '${teacherProvider.email}',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                '${teacherProvider.department}',
                                style: TextStyle(color: Colors.white),
                              ),
                              ListTile(
                                leading: Image.asset('images/lightning(1).png'),
                                title: Text(
                                  'Energy Saved',
                                  style: TextStyle(color: Colors.white),
                                ),
                                trailing: Text(
                                  '$energySaved kWh',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  AlignPositioned(
                    dy: -40,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Colors.black38,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            '“Energy saved is energy produced. Energy saved today is asset for future..”',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 17,
                              // backgroundColor: Colors.orange,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '\n- NCERT',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                // backgroundColor: Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
            ]),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: bottomIndex,
              onTap: (value) {
                // setState(() {
                //   bottomIndex = value;
                // });
                if (value == 0) {
                  // Navigator.pop(context);
                  pageProvider.setPage(1);
                  // Navigator.pushNamed(context, 'dashboard');
                }
              },
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text('Home'),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), title: Text('Profile')),
              ],
            ));
  }
}
