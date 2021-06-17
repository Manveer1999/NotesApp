import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notenote/create_note_screen.dart';
import 'package:hive/hive.dart';
import 'package:notenote/notes_model.dart';
import 'package:notenote/Models/popup_ model.dart';
import 'package:notenote/Models/popupmenu_items.dart';


class NotesList extends StatefulWidget {

  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {

  List<Note> noteList = [ ];

  @override
  void initState() {
    super.initState();
    openBox();
    dbContent();
  }

  openBox() async{
    await Hive.openBox('notes').then((value) {
      print(value.toString());
    });
  }

    void dbContent() async{
    await openBox();
    setState(() {
     noteList.clear();
    });
    int index;
      final newBox = Hive.box('notes');
      for( index =0 ; index< newBox.length ; index++) {
        final newNote = newBox.get(index) as Note ;
        setState(() {
          noteList.add(newNote);
        });
        print('title:${noteList[index].title}  note:${noteList[index].noteText}  time:${noteList[index].time}  color:${noteList[index].noteColor}');
      }
    }

    void deleteNote(dynamic item) async{
       noteList.remove(item);
       final delNot = Hive.box('notes');
       await delNot.delete(item);
    }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF151515),
        drawer: Drawer(
          child: Container(
            color: Color(0xFF151515),
          ),
        ),
        body: noteList.isEmpty
            ? Center(
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/HomeScreen/no_notes.png",
                    width: 180,
                  ),
                  SizedBox(height: 50,),
                  Text(
                      "+ Add Note",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "Make a note of whatever is on your mind",
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w400,
                      fontSize: 14
                    ),
                  )
                ],
              ),
            )
            : Container(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  ///MY NOTES
                  Container(
                    height: 50,
                    width: 150,
                    padding: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        //color: Color(0xFF343434),
                        borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text('My Notes',style: GoogleFonts.poppins(
                          fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      ),
                    ),
                  ),

                  ///SEARCH BUTTON
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      height: 42,
                      width: 42,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xFF343434),
                          borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                          child: Icon(Icons.search,color: Colors.white,size: 25,
                          ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Hive.isBoxOpen("notes")
                        ? _buildGridView()
                        : Container()
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Center(child: Icon(Icons.add),),
          elevation: 10,
          highlightElevation: 20,
          backgroundColor: Color(0xFF343434),
          onPressed: () async{
            await Navigator.push(context, MaterialPageRoute(
              builder: (context) => CreateNote(),
            ),
            );
            dbContent();
          },
        ),

      ),
    );
  }


  StaggeredGridView _buildGridView() {
    //final noteBox = Hive.box('notes');

    return StaggeredGridView.countBuilder(
        itemCount: noteList.length,
        staggeredTileBuilder: (index) =>
            StaggeredTile.count(((index + 1) % 5 == 0) ? 2 : 1, 1),
        crossAxisCount: 2,
        itemBuilder: (context, index) {
          //final note = noteList.get(index) as Note;

          return noteList[index] == null ? Container() : Container(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  child: PopupMenuButton(
                    onSelected: (index) => onSelected(context, index),
                    color: Color(0xFF343434),
                    itemBuilder: (context) =>
                    [
                      ...PopupMenuItems.noteCardList.map(buildItems).toList(),
                    ],
                  ),
                ),
                Center(child: Text(noteList[index].title ?? "", style: TextStyle(
                    fontSize: 25, fontWeight: FontWeight.w600),),),
                SizedBox(height: 10,),
                Center(child: Text(noteList[index].time ?? " "),),
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: noteList[index].noteColor == null?  Colors.grey.shade400 : HexColor(noteList[index].noteColor),
            ),
          );
        },
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
      );
  }

  PopupMenuItem<PopUpMenu> buildItems(PopUpMenu item) {
    return PopupMenuItem<PopUpMenu>(
      value: item,
      child: Row(
        children: [
          Icon(item.icon,color: Colors.white,size: 20,),
          SizedBox(width: 20,),
          Text(item.popupText,style: TextStyle(color: Colors.white,fontSize: 17),
          ),
        ],
      ),
    );
  }

  void onSelected(BuildContext context , PopUpMenu item) {
    switch (item) {
      case PopupMenuItems.delete:
       deleteNote(item);


    }
  }

}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}






//HexColor.fromHex(noteList[index].noteColor)





//noteBox[index] == null ? Container() :






















// class NoteCard extends StatelessWidget {
//   //const ImageCard({Key key}) : super(key: key);
//
//   NoteCard({this.index});
//   final dynamic index;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(
//         child: Center(child: Text('data'),
//         ),
//       ),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color:  Color(0xFF343434),
//       ),
//     );
//   }
// }

