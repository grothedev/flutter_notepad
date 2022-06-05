import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'appstate.dart';
import 'action.dart';

class Store with ChangeNotifier {
  AppState state = AppState();
  List<Action> actions = []; //actions currently being taken

  void loadState() {}

  void saveState() {}

  bool isLoading() {
    return actions
        .where((a) =>
            a.type == ActionType.STATE_LOAD && a.state == ActionState.RUNNING)
        .isNotEmpty;
  }
}

class NoteStore {
  List<Note> notes = <Note>[];

  NoteStore({List<Note>? notes}) {
    this.notes = notes == null ? [] : notes;
  }

  void add(String n) {
    notes.add(new Note(n));
  }

  void remove(int i) {
    notes.removeAt(i);
  }

  void edit(int i, String n) {
    notes[i].n = n;
  }

  void select(int i) {
    notes[i].sel = !notes[i].sel;
  }

  int size() => notes.length;

  String operator [](int i) => notes[i].n;

  //extract the map from each json object, then construct a note from it and add it to result list of new notes
  static NoteStore fromJson(String json) {
    List jsonNotes = jsonDecode(json);
    List<Note> notes = [];
    jsonNotes.forEach((e){
      notes.add(new Note(e));
    });
    return NoteStore(
        notes: json == '' ? [] : notes);
  }

  String toJson() {
    dynamic test = jsonEncode(notes);
    return jsonEncode(notes);
  }
}

class Note {
  String n = '';
  bool sel = false;
  bool saved = false;

  Note(dynamic data) {
    if (data is String) {
      n = data;
    } else if (data is Map) {
      this.n = data['n'];
      this.sel = data['sel'];
      this.saved = data['saved'];
    }
  }

  Map<String, dynamic> toJson() {
    return {'n': n, 'sel': sel, 'saved': saved};
  }
}
