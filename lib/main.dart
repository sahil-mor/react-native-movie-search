import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/single_child_widget.dart';
import 'package:smartlights/model/room.dart';
import 'package:smartlights/model_providers/user.dart';
import 'package:smartlights/pages/splash/SplashScreen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartlights/pages/wrapper.dart';
import 'package:smartlights/services/authenticate.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  Box box;
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(RoomAdapter());
  try {
    box = await Hive.openBox('appDB');

    // Hive.openBox('settings');
  } catch (e) {
    print(e);
    // var box = Hive.box('appDB');
  }

  if (box != null && box.get('favoriteRooms') == null) {
    box.put('favoriteRooms', Map<String, Room>());
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => SplashScreen(),
          'wrapper': (context) => Wrapper(),
          // 'energy': (context) => EnergyHome(),
          // 'dashboard': (context) => Home(),
          // 'profile': (context) => ProfilePage(),
        },
      ),
      providers: <SingleChildWidget>[
        StreamProvider<FirebaseUser>.value(
          value: AuthService().user,
        ),
        ChangeNotifierProvider<Teacher>(
          create: (BuildContext context) {
            return Teacher();
          },
        )
      ],
    );
  }
}
