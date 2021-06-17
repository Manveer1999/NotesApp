import 'package:notenote/Models/popup_ model.dart';
import 'package:flutter/material.dart';


class PopupMenuItems {

  ///item list in popup menu of create_note_screen
  static const List<PopUpMenu> createNoteList = [
    color,
    image
  ];
  ///item list in popup menu of note_list_screen
  static const List<PopUpMenu> noteCardList = [
    share,
    delete,
  ];


  ///item list in popup menu of create_note_screen
  static const color = PopUpMenu(
      popupText: 'Color',
      icon: Icons.colorize,
  );
  static const image = PopUpMenu(
    popupText: 'Add Image',
    icon: Icons.add_a_photo,
  );
  ///item list in popup menu of note_list_screen
  static const share = PopUpMenu(
    popupText: 'Share',
    icon: Icons.share,
  );
  static const delete = PopUpMenu(
    popupText: 'Delete',
    icon: Icons.delete,
  );
}