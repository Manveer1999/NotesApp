import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:notenote/notes_model.dart';
import 'package:hive/hive.dart';

import 'package:notenote/Models/popup_ model.dart';
import 'package:notenote/Models/popupmenu_items.dart';
import 'package:notenote/color_bottom_sheet.dart';

class CreateNote extends StatefulWidget {

  @override
  _CreateNoteState createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {

  String _noteColour;
  String _title;
  String _noteText;
  //Box<Note> noteBox;
  String dateAndTime = DateFormat.jm().format(DateTime.now());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteTextController = TextEditingController();

  void addNote(Note noteModel) {
    final noteBox = Hive.box('notes');
    noteBox.add(noteModel).then((value){
      print("DATA ADDED : $value");
    }).catchError((e){
      print("ERROR WHILE SAVING NOTE : $e");
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   noteBox = Hive.box('notes');
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF151515),
        body: Container(
          padding: EdgeInsets.only(top: 7, left: 5, right: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    ///BACK BUTTON
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 42,
                        width: 43,
                        padding: EdgeInsets.only(left: 7),
                        decoration: BoxDecoration(
                            color: Color(0xFF343434),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),

                    ///SAVE BUTTON
                    GestureDetector(
                      onTap: () {
                        _title = titleController.text;
                        _noteText = noteTextController.text;
                        Note noteModel = Note(title: _title, noteText: _noteText ,time: dateAndTime,noteColor: _noteColour);
                        print(_title);
                        print(_noteText);
                        addNote(noteModel);
                        Navigator.pop(context);
                        },
                      child: Container(
                        height: 42,
                        width: 70,
                        //padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Color(0xFF343434),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                          'Save',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ],
                ),
              ),

              ///TITLE TEXT
              Container(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 15,
                  right: 15,
                ),
                width: double.infinity,
                height: 65,
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                    ),
                    border: InputBorder.none,
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              ///DATE AND TIME
              Container(
                padding: EdgeInsets.only(top: 10 ,left: 15),
                height: 30,
                child: Text(
                  dateAndTime,
                  style: TextStyle(
                    color: Color(0xFF626262),
                    fontSize: 17,
                  ),
                ),
              ),

              ///NOTE TEXT
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                    top: 12,
                    left: 15,
                    right: 15,
                  ),
                  child: TextField(
                    controller: noteTextController,
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(
                      //fillColor: Colors.black,
                      //filled: true,
                      hintText: 'Type something...',
                      hintStyle: TextStyle(
                        color: Color(0xFF8D8E98),
                        fontSize: 18,
                      ),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      color: Color(0xFF8D8E98),
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.only(bottom: 20),
                alignment: Alignment.centerRight,
                height: 50,
                color: Color(0xFF151515),
                 child: PopupMenuButton<PopUpMenu>(
                   onSelected: (item) => onSelected(context,item),
                   icon: Icon(Icons.add,color: Colors.white,),
                   color: Color(0xFF343434),
                     itemBuilder: (context) => [
                       ...PopupMenuItems.createNoteList.map(buildItems).toList(),
                     ],
                 ),
              ),
            ],
          ),
        ),
      ),
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
      case PopupMenuItems.color:
        showModalBottomSheet(
          backgroundColor: Color(0xff0A0A0A),
            context: context,
            builder: (context) => Container(
              color: Color(0xff0A0A0A),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF151515),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),),
                ),
                padding: EdgeInsets.only(left: 30,right: 30,bottom: 20),
                height: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        ColorNote(
                          color: Color(0xffFFCA84),
                          onPressed: (){
                            setState(() {
                              _noteColour = 'FFCA84';
                              //addColor(noteColour);
                            });
                          },
                        ),

                        ColorNote(
                          color: Color(0xffFFAB91),
                          onPressed: (){
                            setState(() {
                              _noteColour = 'FFAB91';
                              //addColor(noteColour);
                            });
                            },
                        ),

                        ColorNote(
                          color: Color(0xff80DDEC),
                          onPressed: (){
                            setState(() {
                              _noteColour = '80DDEC';
                              //addColor(noteColour);
                            });
                            },
                        ),

                        ColorNote(
                          color: Color(0xffCF93D9),
                          onPressed: (){
                            setState(() {
                              _noteColour = 'CF93D9';
                              //addColor(noteColour);
                            });
                            },
                        ),

                        ColorNote(
                          color: Color(0xff82CAC1),
                          onPressed: (){
                            setState(() {
                              _noteColour = '82CAC1';
                              //addColor(noteColour);
                            });
                            },
                        ),

                        ColorNote(
                          color: Color(0xffE6EE9B),
                          onPressed: (){
                            setState(() {
                              _noteColour = 'E6EE9B';
                              //addColor(noteColour);
                            });
                            },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        );
    }
  }
}
