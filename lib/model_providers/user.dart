import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:smartlights/services/database.dart';

class Teacher with ChangeNotifier {
  int _energySaved;
  String _name, _email, _userID, _department;

  fetchDetails() async {
    var value = await DatabaseService.getTeacherReference(
            userID: userID, keepSynced: false)
        .once();

    _name = value.value['Name'];
    _department = value.value['Department'];

    var box = await Hive.openBox('teacher');

    box.put('name', _name);
    box.put('department', _department);
  }

  set userID(String userID) {
    this._userID = userID;
  }

  set email(String email) {
    this._email = email;
  }

  set name(String name) => this._name = name;

  set department(String value) => this._department = value;

  String get userID {
    return _userID;
  }

  String get name {
    return _name;
  }

  int get energySaved {
    return _energySaved;
  }

  String get department => _department;

  String get email => _email;
}
