import 'package:hive/hive.dart';
part 'notes_model.g.dart';

@HiveType(typeId: 0)
class Note{

  @HiveField(0)
  final String title ;

  @HiveField(1)
  final String noteText ;

  @HiveField(2)
  String time ;

  @HiveField(3)
  String noteColor ;

  Note({this.title , this.noteText , this.time , this.noteColor});
}