import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:smartlights/shared/widgets/room_block.dart';
import 'package:smartlights/model_providers/current_room.dart';
import 'package:smartlights/model_providers/favorite.dart';
import 'package:smartlights/model_providers/switcher_model.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<SwitcherModel>(context);
    return Scaffold(
        backgroundColor: Color(0XFFfefefe),
        body: MultiProvider(
          child: SafeArea(child: RoomBlockArea()),
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<CurrentRoomModel>(
              create: (BuildContext context) {
                return CurrentRoomModel();
              },
            ),
            ChangeNotifierProvider<FavoriteRoomsProvider>(
              create: (BuildContext context) {
                return FavoriteRoomsProvider();
              },
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          backgroundColor: Color(0xffe8e9ed),
          elevation: 20,
          selectedItemColor: Colors.yellow[800],
          unselectedItemColor: Colors.grey.shade300,
          onTap: (value) {
            if (value == 1) {
              pageProvider.setPage(2);
              // Navigator.pop(context);
              // Navigator.pushNamed(context, 'profile');
            }
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.deepOrange,
              ),
              title: Text(
                'Home',
                style: TextStyle(color: Colors.deepOrange),
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person, color: Colors.grey[400]),
                title: Text(
                  'Profile',
                  style: TextStyle(color: Colors.grey[500]),
                )),
          ],
        ));
  }
}
