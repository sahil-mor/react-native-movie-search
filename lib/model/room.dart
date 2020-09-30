import 'package:hive/hive.dart';

part 'room.g.dart';

@HiveType()
class Room {
  Room(
    this.name,
    this.isEnabled,
    this.luxReading,
    this.showInApp,
    this.showList,
    this.blockName,
  );

  @HiveField(5)
  bool isEnabled;

  @HiveField(6)
  bool automaticStatus;

  @HiveField(0)
  String name;

  @HiveField(1)
  String blockName;

  @HiveField(2)
  Map<String, List<int>> showList;

  @HiveField(3)
  List<String> showInApp;

  @HiveField(4)
  int luxReading;
}
