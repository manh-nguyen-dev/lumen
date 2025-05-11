// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitModelAdapter extends TypeAdapter<HabitModel> {
  @override
  final int typeId = 3;

  @override
  HabitModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitModel(
      id: fields[0] as String?,
      title: fields[1] as String,
      icon: fields[2] as String,
      color: fields[3] as int,
      description: fields[4] as String?,
      frequent: fields[5] as Frequent,
      dailyReminder: fields[6] as TimeOfDay?,
      repeatOn: (fields[7] as List?)?.cast<int>(),
      startDate: fields[8] as DateTime?,
      endDate: fields[9] as DateTime?,
      completedDates: fields[10] is List ? List<String>.from(fields[10]) : <String>[],
    );
  }

  @override
  void write(BinaryWriter writer, HabitModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.color)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.frequent)
      ..writeByte(6)
      ..write(obj.dailyReminder)
      ..writeByte(7)
      ..write(obj.repeatOn)
      ..writeByte(8)
      ..write(obj.startDate)
      ..writeByte(9)
      ..write(obj.endDate)
      ..writeByte(10)
      ..write(obj.completedDates);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
