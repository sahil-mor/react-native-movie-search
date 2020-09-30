// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoomAdapter extends TypeAdapter<Room> {
  @override
  Room read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Room(
      fields[0] as String,
      fields[5] as bool,
      fields[4] as int,
      (fields[3] as List)?.cast<String>(),
      (fields[2] as Map)?.map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as List)?.cast<int>())),
      fields[1] as String,
    )..automaticStatus = fields[6] as bool;
  }

  @override
  void write(BinaryWriter writer, Room obj) {
    writer
      ..writeByte(7)
      ..writeByte(5)
      ..write(obj.isEnabled)
      ..writeByte(6)
      ..write(obj.automaticStatus)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.blockName)
      ..writeByte(2)
      ..write(obj.showList)
      ..writeByte(3)
      ..write(obj.showInApp)
      ..writeByte(4)
      ..write(obj.luxReading);
  }

  @override
  int get typeId => 0;
}
