// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteTypeAdapter extends TypeAdapter<NoteType> {
  @override
  final int typeId = 2;

  @override
  NoteType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NoteType.normal;
      case 1:
        return NoteType.reminder;
      case 2:
        return NoteType.task;
      case 3:
        return NoteType.idea;
      default:
        return NoteType.normal;
    }
  }

  @override
  void write(BinaryWriter writer, NoteType obj) {
    switch (obj) {
      case NoteType.normal:
        writer.writeByte(0);
        break;
      case NoteType.reminder:
        writer.writeByte(1);
        break;
      case NoteType.task:
        writer.writeByte(2);
        break;
      case NoteType.idea:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
