import 'package:firebase_database/firebase_database.dart';
import 'package:smartlights/model/room.dart';
import 'package:smartlights/services/database.dart';

class Teacher {
  static Teacher teacher;
  // static DatabaseService db;
  static void createTeacher({email, userID}) {
    teacher = Teacher(userID: userID, bookmarkedRooms: List<Room>());

    DatabaseReference ref =
        DatabaseService.getTeacherReference(userID: userID, keepSynced: true);
    ref.onValue.listen(
      (event) {
        teacher.energySaved = event.snapshot.value['Energy Saved'];
        teacher.name = event.snapshot.value['Name'];
        teacher.department = event.snapshot.value['Department'];
        teacher.email = event.snapshot.value['Email'];
      },
      onDone: () => print('Updated:'),
    );
  }

  String name, email, userID, department;
  int energySaved;
  List<Room> bookmarkedRooms;

  Teacher(
      {this.name,
      this.email,
      this.userID,
      this.energySaved,
      this.bookmarkedRooms,
      this.department}) {
    // db = DatabaseService();
  }
}
