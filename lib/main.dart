import 'package:flutter/material.dart';
import 'package:notenote/note_list_screen.dart';
import 'package:notenote/notes_model.dart';
import 'create_note_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:notenote/notes_model.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final appDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDirectory.path);
  Hive.registerAdapter(NoteAdapter());
  //await Hive.openBox<Note>('notes');
  runApp(Home());
}

class Home extends StatefulWidget {
  //const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
    openBox();
  }

  openBox() async{
    await Hive.openBox('notes').then((value) {
      print(value.toString());
    });
  }

  // void dbContent() {
  //   int index;
  //   final newBox = Hive.box('notes');
  //   for( index =0 ; index< newBox.length ; index++) {
  //     final newNote = newBox.get(index) as Note;
  //     print('title: ${newNote.title} , note: ${newNote.noteText} , time: ${newNote.time}');
  //   }
  // }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home:NotesList(),
      // Container(
      //   color: Colors.green,
      //   child: TextButton(
      //     child: Text('database Content'),
      //     onPressed: () {
      //       dbContent();
      //     },
      //   ),
      // ),
    );
  }
}
