import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartlights/model_providers/data.dart';
import 'package:smartlights/model_providers/switcher_model.dart';
import 'package:smartlights/model_providers/user.dart';
import 'package:smartlights/pages/authenticate/login.dart';
import 'package:smartlights/pages/new.dart';
import 'package:smartlights/services/database.dart';
import 'package:smartlights/shared/widgets/loading.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool dataLoaded = false;

  loadTeacherdata() async {
    print(dataLoaded);
    var box = await Hive.openBox('teacher');

    final teacherProvider = Provider.of<Teacher>(context, listen: false);
    teacherProvider.userID = box.get('userID');
    teacherProvider.email = box.get('email');
    teacherProvider.name = box.get('name');
    teacherProvider.department = box.get('department');
    print('In wrapper function');
    await box.close();

    setState(() {
      dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<Teacher>(context);
    print('in wrapper');
    final user = Provider.of<FirebaseUser>(context);

    if (user == null) {
      return LoginPage();
    } else {
      dataLoaded == false ? loadTeacherdata() : print('teacher data loaded');
      return dataLoaded == false
          ? Loading()
          : MultiProvider(
              child: Switcher(DatabaseService.getTeacherReference(
                  userID: userProvider.userID, keepSynced: false)),
              providers: [
                  ChangeNotifierProvider<SwitcherModel>(
                    create: (BuildContext context) {
                      return SwitcherModel();
                    },
                  ),
                  ChangeNotifierProvider<BlockDataModel>(
                    create: (BuildContext context) => BlockDataModel(),
                  )
                ]);
    }
  }
}
