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

  void select(int i){
    notes[i].sel = !notes[i].sel;
  }

  int size() => notes.length;

  String operator [](int i) => notes[i].n;

  static NoteStore fromJSON(String json) =>
      NoteStore(notes: json == null || json == '' ? [] : jsonDecode(json));
  String toJson() => jsonEncode(notes);
}

class Note {
  String n;
  bool sel = false;
  bool saved = false;

  Note(this.n);

  Map<String, dynamic> toJson() {
    return {'n': n, 'sel': sel, 'saved': saved};
  }
}
