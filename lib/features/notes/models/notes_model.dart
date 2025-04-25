import 'package:hive/hive.dart';

import '../../../core/constants/enums.dart';

part 'notes_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject{
  @HiveField(0)
  final int id;

  @HiveField(1)
  String content;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  bool isPinned;

  @HiveField(4)
  NoteType type;

  NoteModel({
    required this.id,
    required this.content,
    required this.createdAt,
    this.isPinned = false,
    this.type = NoteType.normal,
  });
}
